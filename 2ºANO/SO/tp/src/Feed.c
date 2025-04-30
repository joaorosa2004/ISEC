#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <signal.h>
#include <errno.h>
#include <string.h>
#include <pthread.h>
#include "structs.h" 
#include <sys/select.h>
#include <time.h>

#define FEED_FIFO "FEEDFIFO%d"
#define MANAGER_FIFO "MANAGERFIFO"
char FEED_FIFO_FINAL[100];

void userExitHandler(int signum, siginfo_t *info, void *secret){
    printf("Server closed!\n");
	unlink(FEED_FIFO_FINAL);
    exit(1);
}

void *recebePipes(void* msgFeed){
	MsgToFeed *msg = (MsgToFeed*) msgFeed;
	int size;
	int fd_recebe = open(FEED_FIFO_FINAL, O_RDONLY);
	if(fd_recebe == -1){
		perror("Erro ao abrir cliente");
		unlink(FEED_FIFO_FINAL);
		exit(1);
	}
	while(1){
		size = read(fd_recebe, &msg->mensagem, sizeof(msg->mensagem));
			if(size > 0){
			pthread_mutex_lock(msg->m);	
			printf("%s", msg->mensagem);
			pthread_mutex_unlock(msg->m);
			if(strcmp(msg->mensagem, "Foste removido!\n") == 0){
				close(fd_recebe);
				unlink(FEED_FIFO_FINAL);
				exit(-1);
			}
		}
	}
	close(fd_recebe);
	return NULL;
}

void loginIn(MSG msg){
	int fd_user_envia, fd_user_recebe, x, size2;

	fd_user_envia = open(MANAGER_FIFO, O_WRONLY);
	if(fd_user_envia == -1){
		printf("Erro ao abrir o servidor");
		unlink(FEED_FIFO_FINAL);
		exit(1);
	}

	strcpy(msg.msg, "");
	strcpy(msg.topico, "");

	write(fd_user_envia, &msg, sizeof(msg));
	
	fd_user_recebe = open(FEED_FIFO_FINAL, O_RDONLY);
	if(fd_user_recebe == -1){
		printf("Erro ao abrir o cliente");
		exit(1);
	}

	size2 = read(fd_user_recebe, &x, sizeof(x));
	if(size2 >= 0){
		if(x == 0){
			printf("\nJa existe um utilizador com esse username ou limite de utilizadores atingido!\n");
			close(fd_user_recebe);
			unlink(FEED_FIFO_FINAL);
			exit(1);
		}
		else
			printf("Logado com sucesso!\nBem-vindo!\n");
	}
	close(fd_user_envia);
	close(fd_user_recebe);
}

int main(int argc, char* argv[]){
	setbuf(stdout, NULL);

	if(argc!=2){
		printf("Erro de Sintaxe: <username>\n");
        return -1;  
	}

	MSG msg;
	MsgToFeed msgFeed;
	int fd_envia;
	char input[30];
	strcpy(msg.usr.username, argv[1]);
	msg.usr.pid = getpid();

	struct sigaction sa;	
    sa.sa_sigaction = userExitHandler;
    sa.sa_flags = SA_SIGINFO;   
    if(sigaction(SIGUSR1, &sa, NULL) == -1){
        perror("Erro ao configurar SIGUSR1");
        exit(1);
    }


	sprintf(FEED_FIFO_FINAL, "FEEDFIFO%d", msg.usr.pid);
	if (mkfifo(FEED_FIFO_FINAL, 0666) == -1) {
		if (errno != EEXIST) {
			perror("Erro ao criar FEED_FIFO");
			exit(1);
		}
	}

	pthread_mutex_t mutex;
	pthread_mutex_init(&mutex, NULL);
	pthread_t t;
	msgFeed.m = &mutex;

	if(pthread_create(&t, NULL, &recebePipes, &msgFeed) != 0){
		perror("Erro ao criar thread\n");
		exit(-1);
	}

	loginIn(msg);


	while(1){
		strcpy(msg.usr.username, argv[1]);
		msg.usr.pid = getpid();
		fgets(input, sizeof(input), stdin);
            input[strcspn(input, "\n")] = '\0';
        if (sscanf(input, "msg %s %d %[^\n]", msg.topico, &msg.dur, msg.msg) == 3) {
			fd_envia = open(MANAGER_FIFO, O_WRONLY);
			if(fd_envia == -1){
				perror("Erro ao abrir o cliente");
				exit(1);
			}
			write(fd_envia, &msg, sizeof(msg));
            memset(&msg, 0, sizeof(msg));
        } 
		else if (strcmp(input, "topics") == 0) {
            strcpy(msg.msg, "topics");
            fd_envia = open(MANAGER_FIFO, O_WRONLY);
			if(fd_envia == -1){
				perror("Erro ao abrir o cliente");
				exit(1);
			}
            printf("%s", msg.topico);
			write(fd_envia, &msg, sizeof(msg));
        } 
        else if (sscanf(input, "subscribe %s", msg.topico) == 1) {
			strcpy(msg.msg, "subscribe");
            fd_envia = open(MANAGER_FIFO, O_WRONLY);
			if(fd_envia == -1){
				perror("Erro ao abrir o cliente");
				exit(1);
			}
			write(fd_envia, &msg, sizeof(msg));
        } 
		else if (sscanf(input, "unsubscribe %s", msg.topico) == 1) {
            strcpy(msg.msg, "unsubscribe");
            fd_envia = open(MANAGER_FIFO, O_WRONLY);
			if(fd_envia == -1){
				perror("Erro ao abrir o cliente");
				exit(1);
			}
			write(fd_envia, &msg, sizeof(msg));
        } 
		else if(strcmp(input, "exit") == 0){
			strcpy(msg.msg, "exit");
			fd_envia = open(MANAGER_FIFO, O_WRONLY);
			if(fd_envia == -1){
				perror("Erro ao abrir o cliente");
				exit(1);
			}
			write(fd_envia, &msg, sizeof(msg));
			break;
		}
        else {
            printf("Comando invalido! Tente novamente\n>");
        }
	}

	unlink(FEED_FIFO_FINAL);
	pthread_cancel(t);
	pthread_join(t, NULL);
	pthread_mutex_destroy(&mutex);

	return 0;
}
