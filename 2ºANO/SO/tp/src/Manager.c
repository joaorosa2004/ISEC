#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <errno.h>
#include <string.h>
#include "structs.h"
#include <sys/select.h>
#include <pthread.h>


 
#define FEED_FIFO "FEEDFIFO%d"
#define MANAGER_FIFO "MANAGERFIFO"
char FEED_FIFO_FINAL[256];

int nUsers = 0;
int nTopics = 0;


void* TimerPersistentMsg(void* dados) {
    Topic* topics = (Topic*) dados; 

    while (1) {
        sleep(1); 

        for (int i = 0; i < nTopics; i++) {
            Topic* topic = &topics[i];

            
            if (topic->numMsgs <= 0) {
                continue;
            }

            pthread_mutex_lock(topic->m);

            for (int j = 0; j < topic->numMsgs; j++) {
                MSG* message = &topic->msgPer[j];
                if (message->dur > 0) {
                    message->dur--; 
                    if (message->dur == 0) { 
                    printf("Mensagem do tópico '%s' removida: %s\n", topic->nome, message->msg);
                    for (int k = j; k < topic->numMsgs - 1; k++) {
                        topic->msgPer[k] = topic->msgPer[k + 1];
                    }
                    topic->numMsgs--; 
                    --j; 
                    if(topic->numMsgs == 0 && topic->numUsers == 0)
                        removeTopic(&topics[i], topics);
                    }
                }
            }

            pthread_mutex_unlock(topic->m);
        }
    }

    return NULL;
}

void exit_signal(User users[]){
    for(int i = 0; i < nUsers; i++){
        if(kill(users[i].pid, SIGUSR1) == -1){
		perror("Erro ao enviar SIGUSR1");
		unlink(FEED_FIFO_FINAL);
	    }
    }
}

int login(User *new_user ,User users[]){
    if (nUsers >= MAX_USERS) {
        return 0; 
    }
    for (int i = 0; i < nUsers; i++) {
        if (strcmp(users[i].username, new_user->username) == 0) {
            return 0; 
        }
    }
    users[nUsers] = *new_user;
    nUsers++;
    printf("Utilizador '%s' logado com sucesso (PID: %d).\n", new_user->username, new_user->pid);

    return 1; 
}

void printUsers(User users[]){
    printf("Users: \n");
    for(int i = 0; i < nUsers; i++){
        printf("- %s (PID: %d)\n", users[i].username, users[i].pid);
    }
}   

int msgManager(MSG msg, Topic topics[]) {
    for (int i = 0; i < nTopics; i++) {
        if (strcmp(topics[i].nome, msg.topico) == 0) { 
            for (int j = 0; j < topics[i].numUsers; j++) {
                if (msg.usr.pid == topics[i].users[j].pid) {
                    if (topics[i].block) { 
                        return -1;
                    }
                    if(msg.dur > 0){
                        topics[i].numMsgs++;
                        int aux = topics[i].numMsgs;
                        topics[i].msgPer[aux-1] = msg;
                    }
                    return 2; 
                }
            }
            return 0; 
        }
    }

    if (nTopics >= MAX_TOPICS) {
        printf("Limite de tópicos atingido!\n");
        return 0;
    }

    Topic new_topic;
    strcpy(new_topic.nome, msg.topico);
    new_topic.users[0] = msg.usr;
    new_topic.block = 0;
    if(msg.dur > 0){
        new_topic.numMsgs = 1;
        new_topic.msgPer[0] = msg;
    }
    else new_topic.numMsgs = 0;
    new_topic.numUsers = 1;

    topics[nTopics] = new_topic;
    nTopics++;

    printf("Tópico %s criado com sucesso e utilizador com pid %d subscrito.\n", new_topic.nome, msg.usr.pid);

    return 1;
}


void printTopics(Topic topics[]){
    printf("Topics:\n");
    for(int i = 0; i < nTopics; i++)
        printf("- %s: %d users. %d persistent messages. blocked? (no - 0, yes - 1): %d\n", topics[i].nome, 
            topics[i].numUsers, topics[i].numMsgs, topics[i].block);
}

int subscribe(MSG *msg, Topic topics[]){
    for(int i = 0; i < nTopics; i++){
        if(strcmp(msg->topico, topics[i].nome) == 0){
             for(int j = 0; j < topics[i].numUsers; j++){
                if(msg->usr.pid == topics[i].users[j].pid)
                    return 0;
             }
            int aux = topics[i].numUsers;
            topics[i].users[aux] = msg->usr;
            topics[i].numUsers++;
            printf("O utilizador com pid %d subscreveu em %s\n", msg->usr.pid, topics[i].nome);
            return 1;
        }
    }
    return 0;
}

int addPersistentMsg(MSG msg, Topic topics[]){
    for(int i = 0; i < nTopics; i++){
        if(strcmp(msg.topico, topics[i].nome) == 0){
            if(topics[i].numMsgs >= MAX_MSG_PERSISTENTE)
                return 0;
            int aux = topics[i].numMsgs;
            topics[i].msgPer[aux] = msg;
            topics[i].numMsgs++;
            printf("Message added to topic %s for %d seconds", topics[i].nome, msg.dur);
            return 1;
        }
    }
    return 0;
}

int unsubscribe(MSG *msg, Topic topics[]) {
    for (int i = 0; i < nTopics; i++) {
        if (strcmp(msg->topico, topics[i].nome) == 0) { 
            for (int j = 0; j < topics[i].numUsers; j++) {
                if (msg->usr.pid == topics[i].users[j].pid) { 
                    for (int k = j; k < topics[i].numUsers - 1; k++) {
                        topics[i].users[k] = topics[i].users[k + 1];
                    }
                    topics[i].numUsers--;
                    printf("O utilizador com pid %d cancelou a subscrição em %s\n", msg->usr.pid, topics[i].nome);
                    if(topics[i].numUsers == 0 && topics[i].numMsgs == 0)
                        removeTopic(&topics[i], topics);
                    return 1; 
                }
            }
            return 0; 
        }
    }
    return 0;   
}

void lock(Topic topics[], char topic[]){
    if(nTopics == 0){
        printf("Nao existem topicos!\n");
        return;
    }
    for(int i = 0; i < nTopics; i++){
        if(strcmp(topics[i].nome, topic) == 0){
            if(topics[i].block == 1){
                printf("O topico %s ja estava bloqueado!\n", topics[i].nome);
                return;
            }
            topics[i].block = 1;
            printf("Topico %s bloqueado!\n", topics[i].nome);
            return;
        }
    }

    printf("O topico %s nao existe!\n", topic);
}

void unlock(Topic topics[], char topic[]){
    if(nTopics == 0){
        printf("Nao existem topicos!\n");
        return;
    }
    for(int i = 0; i < nTopics; i++){
        if(strcmp(topics[i].nome, topic) == 0){
            if(topics[i].block == 0){
                printf("O topico %s ja estava desbloqueado!\n", topics[i].nome);
                return;
            }
            topics[i].block = 0;
            printf("Topico %s desbloqueado!\n", topics[i].nome);
            return;
        }
    }

    printf("O topico %s nao existe!\n", topic);
}

void save_persistent_messages(const char* filename, Topic topics[]) {
    if (!filename) {
        fprintf(stderr, "Erro: A variável de ambiente MSG_FICH não está definida.\n");
        return;
    }
    FILE* file = fopen(filename, "w");
    if (!file) {
        perror("Erro ao abrir ficheiro para escrita");
        return;
    }

    for (int i = 0; i < nTopics; i++) {
        for (int j = 0; j < topics[i].numMsgs; j++) {
            MSG* msg = &topics[i].msgPer[j];
            if (msg->dur > 0) { 
                fprintf(file, "%s %s %d %s\n", 
                        topics[i].nome, 
                        msg->usr.username, 
                        msg->dur, 
                        msg->msg);
            }
        }
    }

    fclose(file);
    printf("Mensagens persistentes salvas em '%s'\n", filename);
}

void load_persistent_messages(const char* filename, Topic topics[]) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        perror("Erro ao abrir ficheiro para leitura");
        return;
    }

    char line[512]; 
    while (fgets(line, sizeof(line), file)) {
        char usernameAux[30], topicAux[MAX_TOPIC_SIZE], msgAux[MAX_MSG_SIZE];
        int dur;
        if (sscanf(line, "%s %s %d %[^\n]", topicAux, usernameAux, &dur, msgAux) == 4) {
            MSG msg; 
                msg.dur = dur;
                strcpy(msg.msg, msgAux);
                strcpy(msg.topico, topicAux);
                strcpy(msg.usr.username, usernameAux);
            for(int i = 0; i < nTopics; i++){
                if(strcmp(topics[i].nome, topicAux) == 0){
                    if(!addPersistentMsg(msg, topics)){
                        printf("Error creating persistent messages\n");
                        unlink(MANAGER_FIFO);
                        exit(-1);
                    }
                }
            }

            Topic new_topic;
            strcpy(new_topic.nome, topicAux);
            new_topic.block = 0;
            new_topic.numMsgs = 1;
            new_topic.msgPer[0] = msg;
            new_topic.numUsers = 0;
            topics[nTopics] = new_topic;
            nTopics++;
        }
    }

    fclose(file);
    printf("Mensagens persistentes carregadas de '%s'\n", filename);
}

void showTopic(Topic topics[], char topic[]){
    for(int i = 0; i < nTopics; i++){
        if(strcmp(topics[i].nome, topic) == 0){
            if(topics[i].numMsgs == 0){
                printf("O topico %s nao tem mensagens persistentes!\n", topics[i].nome);
                return;
            }
            else{
                printf("Topico %s:\n", topics[i].nome);
                for(int j = 0; j < topics[i].numMsgs; j++){
                    printf("- %s\n", topics[i].msgPer[j].msg);
                }
                return;
            }
        }
    }
    printf("That topic does not exist\n");
}

void removeTopic(Topic *topic, Topic topics[]){
    for(int i = 0; i < nTopics; i++){
        if(strcmp(topics[i].nome, topic->nome) == 0){
            printf("O topico %s foi apagado por estar inativo\n", topic->nome);
            for(int j = i; j < nTopics - 1; j++)
                topics[j] = topics[j + 1];
            nTopics--;
            break;
        }
    }
}

void removeUser(User *usr, Topic topics[], User users[]) {
    for (int i = 0; i < nTopics; i++) {
        for (int j = 0; j < topics[i].numUsers; j++) {
            if (topics[i].users[j].pid == usr->pid) {
                for (int k = j; k < topics[i].numUsers - 1; k++) {
                    topics[i].users[k] = topics[i].users[k + 1];
                }
                topics[i].numUsers--;
                j--; 
            }
        }
    }

    for (int i = 0; i < nUsers; i++) {
        if (strcmp(users[i].username, usr->username) == 0) {
            for (int j = i; j < nUsers - 1; j++) {
                users[j] = users[j + 1];
            }
            nUsers--;
            printf("Utilizador '%s' removido com sucesso (PID: %d).\n", usr->username, usr->pid);
            break;
        }
    }
}


int main(){
    char* filename = getenv("MSG_FICH"); 
    setbuf(stdout, NULL);
    char input[30], username[30], topico[30];
    int fd_user_envia, fd_user_recebe, size;
    fd_set readFds;
    MSG msg;
    User users[MAX_USERS];
    Topic topics[MAX_TOPICS];
    MsgToFeed msgFeed;
    struct timeval tv;
    pthread_t timer;
    pthread_mutex_t mutex;

    
    if (pthread_create(&timer, NULL, TimerPersistentMsg, &topics) != 0) {
        perror("Error creating timer thread");
        exit(-1);
    }

    pthread_mutex_init(&mutex, NULL);


    if (mkfifo(MANAGER_FIFO, 0660) == -1) {
        if (errno != EEXIST) {
            perror("Error creating MANAGER_FIFO");
            return -1;
        }
    }

    fd_user_recebe = open(MANAGER_FIFO, O_RDONLY | O_NONBLOCK);
    if (fd_user_recebe == -1) {
        perror("Error opening MANAGER_FIFO");
        return -1;
    }

    if (filename) {
    load_persistent_messages(filename, topics);
    } else {
    printf("Variável de ambiente MSG_FICH não definida.\n");
    }

    while(1){
        tv.tv_sec = 5;
        tv.tv_usec = 0;
        FD_ZERO(&readFds);
        FD_SET(0, &readFds);
        FD_SET(fd_user_recebe, &readFds);

        int nfd = select(fd_user_recebe+1, &readFds, NULL, NULL, &tv);
        if (nfd < 0) {
            perror("Erro no select");
            unlink(MANAGER_FIFO);
            exit(-1);
        }

        if(FD_ISSET(0, &readFds)){
            fgets(input, sizeof(input), stdin);
            input[strcspn(input, "\n")] = '\0';

            if (strcmp(input, "topics") == 0) {
                printTopics(topics);
            } 
            else if (strcmp(input, "users") == 0) {
                 printUsers(users);
            } 
            else if (sscanf(input, "remove %s", username) == 1) {
                for(int i = 0; i < nUsers; i++){
                    if(strcmp(username, users[i].username) == 0){
                        User aux;
                        strcpy(aux.username, username);
                        aux.pid = users[i].pid;
                        sprintf(FEED_FIFO_FINAL, "FEEDFIFO%d", aux.pid);
                        fd_user_envia = open(FEED_FIFO_FINAL, O_WRONLY);
                        if(fd_user_envia == -1){
                        perror("Erro ao abrir cliente\n");
                        unlink(MANAGER_FIFO);
                        return -1;
                        }
                        strcpy(msgFeed.mensagem, "Foste removido!\n");
                        write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem));
                        removeUser(&aux, topics, users);
                        close(fd_user_envia);
                        for(int j = 0; j < nUsers; j++){
                            sprintf(FEED_FIFO_FINAL, "FEEDFIFO%d", users[j].pid);
                            fd_user_envia = open(FEED_FIFO_FINAL, O_WRONLY);
                            if(fd_user_envia == -1){
                            perror("Erro ao abrir cliente\n");
                            unlink(MANAGER_FIFO);
                            return -1;
                            }
                            sprintf(msgFeed.mensagem, "O utilizador %s com pid %d foi removido\n", aux.username, aux.pid);
                            write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem));
                        }
                    }
                }
            } 
            else if (sscanf(input, "show %s", topico) == 1) {
                showTopic(topics, topico);
            } 
            else if (sscanf(input, "lock %s", topico) == 1) {
                lock(topics, topico);
            } 
            else if (sscanf(input, "unlock %s", topico) == 1) {
                unlock(topics, topico);
            } 
            else if (strcmp(input, "close") == 0) {
                printf("\nClosing server\n");
                break;
            } 
            else {
                printf("Invalid command!\n");
            }
        }
        
        else if(FD_ISSET(fd_user_recebe, &readFds)){
            size = read(fd_user_recebe, &msg, sizeof(msg));
            if(size > 0){
                if(msg.msg[0] == '\0' && msg.topico[0] == '\0'){
                    sprintf(FEED_FIFO_FINAL, "FEEDFIFO%d", msg.usr.pid);
                    fd_user_envia = open(FEED_FIFO_FINAL, O_WRONLY);
                    if(fd_user_envia == -1){
                        perror("Erro ao abrir cliente\n");
                        unlink(MANAGER_FIFO);
                        return -1;
                    }
                    int loginRespond = (login(&msg.usr, users)) ? 1 : 0;
                    write(fd_user_envia, &loginRespond, sizeof(loginRespond));
                    close(fd_user_envia);
                }
                else if(strcmp(msg.msg, "topics")==0 && msg.topico[0] == '\0'){
                    if(nTopics == 0){
                        strcpy(msgFeed.mensagem, "Sistema: Nao existem topicos\n");
                    }
                    else{
                        strcpy(msgFeed.mensagem, "");
                        for(int i = 0; i < nTopics; i++){
                            char temp[256]; 
                            sprintf(temp, "- %s: %d users. %d persistent messages. blocked? (no - 0, yes - 1): %d\n", 
                            topics[i].nome, topics[i].numUsers, topics[i].numMsgs, topics[i].block);
                            strcat(msgFeed.mensagem, temp);    
                        }
                    }
                    sprintf(FEED_FIFO_FINAL, "FEEDFIFO%d", msg.usr.pid);
                    fd_user_envia = open(FEED_FIFO_FINAL, O_WRONLY);
                    if(fd_user_envia == -1){
                        perror("Erro ao abrir cliente\n");
                        return -1;
                    }
                    write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem));
                    close(fd_user_envia);
                }
                else if(strcmp(msg.msg, "subscribe")==0 && msg.topico[0] != '\0'){
                    int subscribeResponde = (subscribe(&msg, topics));
                    sprintf(FEED_FIFO_FINAL, "FEEDFIFO%d", msg.usr.pid);
                    fd_user_envia = open(FEED_FIFO_FINAL, O_WRONLY);
                    if(fd_user_envia == -1){
                        perror("Erro ao abrir cliente\n");
                        return -1;
                    }
                    if(subscribeResponde == 0){
                        strcpy(msgFeed.mensagem, "Sistema: Ja estas inscrito nesse topico ou esse topico nao existe!\n");
                    }
                    else{
                        for(int j = 0; j < nTopics; j++){
                            if(strcmp(topics[j].nome, msg.topico) == 0){
                                for(int jj = 0; jj < topics[j].numMsgs; jj++){
                                    sprintf(msgFeed.mensagem, "[%s] %s: %s\n", topics[j].msgPer[jj].topico, topics[j].msgPer[jj].usr.username, topics[j].msgPer[jj].msg);
                                    write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem));
                                }
                            }
                        }
                        sprintf(msgFeed.mensagem, "Sistema: Inscrito com sucesso em %s\n", msg.topico);
                    }
                    write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem));
                    close(fd_user_envia);
                }
                else if(strcmp(msg.msg, "exit") == 0 && msg.topico[0] != '\0'){
                    removeUser(&msg.usr, topics, users);
                }
                else if(strcmp(msg.msg, "unsubscribe")==0 && msg.topico[0] != '\0'){
                    int unsubscribeResponde = (unsubscribe(&msg, topics));
                    sprintf(FEED_FIFO_FINAL, "FEEDFIFO%d", msg.usr.pid);
                    fd_user_envia = open(FEED_FIFO_FINAL, O_WRONLY);
                    if(fd_user_envia == -1){
                        perror("Erro ao abrir cliente\n");
                        return -1;
                    }
                    if(unsubscribeResponde == 0){
                        strcpy(msgFeed.mensagem, "Sistema: Nao estas inscrito nesse topico ou esse topico nao existe!\n");
                        
                    }
                    else{
                        sprintf(msgFeed.mensagem, "Sistema: Desinscrito com sucesso em %s\n", msg.topico);
                    }
                    write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem));
                    close(fd_user_envia);
                }
                else if(msg.msg[0] != '\0' && msg.topico[0] != '\0'){
                    int topicResponde = (msgManager(msg, topics));
                    sprintf(FEED_FIFO_FINAL, "FEEDFIFO%d", msg.usr.pid);
                    fd_user_envia = open(FEED_FIFO_FINAL, O_WRONLY);
                    if(fd_user_envia == -1){
                        perror("Erro ao abrir cliente\n");
                        return -1;
                    }
                    if(topicResponde == 1){
                        topics[nTopics-1].m = &mutex;
                        sprintf(msgFeed.mensagem, "[%s] %s: %s\n", msg.topico, msg.usr.username, msg.msg);
                        write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem));
                        close(fd_user_envia);
                    }
                    else if(topicResponde == 0){
                        strcpy(msgFeed.mensagem, "Sistema: Limite de topicos atingido ou topico ja existe!\n");
                        write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem));
                        close(fd_user_envia);
                    }else if(topicResponde == -1){
                        strcpy(msgFeed.mensagem, "Sistema: O topico esta bloqueado, tente mais tarde\n");
                        write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem));
                        close(fd_user_envia);
                    }else{
                        close(fd_user_envia);
                        sprintf(msgFeed.mensagem, "[%s] %s: %s\n", msg.topico, msg.usr.username, msg.msg);
                        for(int i = 0; i < nTopics; i++){
                            if(strcmp(topics[i].nome, msg.topico) == 0){
                                for(int j = 0; j < topics[i].numUsers; j++){
                                    sprintf(FEED_FIFO_FINAL, "FEEDFIFO%d", topics[i].users[j].pid);
                                    
                                    fd_user_envia = open(FEED_FIFO_FINAL, O_WRONLY);
                                    if (fd_user_envia == -1) {
                                        perror("Erro ao abrir cliente\n");
                                        unlink(MANAGER_FIFO);
                                        exit(1);
                                    }

                                    if (write(fd_user_envia, &msgFeed.mensagem, sizeof(msgFeed.mensagem)) == -1) {
                                        perror("Erro ao enviar mensagem\n");
                                    }

                                    close(fd_user_envia); 
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    save_persistent_messages(filename, topics);

    pthread_cancel(timer);
    pthread_join(timer, NULL);
    pthread_mutex_destroy(&mutex);

    exit_signal(users);
    close(fd_user_recebe);
    unlink(MANAGER_FIFO);
    printf("Server Closed\n");\
    return 0;
}