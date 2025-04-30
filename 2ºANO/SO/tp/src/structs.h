#ifndef STRUCTS_H
#define STRUCTS_H

#include <pthread.h>

#define MAX_USERS 10
#define MAX_TOPICS 20
#define MAX_MSG_PERSISTENTE 5
#define MAX_MSG_SIZE 300
#define MAX_MSG_TO_FEED_SIZE 500
#define MAX_TOPIC_SIZE 20

typedef struct {
    int pid;                          
    char username[30];               
} User;

typedef struct {
    User usr;                         
    char msg[MAX_MSG_SIZE];           
    char topico[MAX_TOPIC_SIZE];     
    int dur;                          
} MSG;

typedef struct {
    char mensagem[MAX_MSG_TO_FEED_SIZE]; 
    pthread_mutex_t *m;   
} MsgToFeed;


typedef struct {
    char nome[MAX_TOPIC_SIZE]; 
    User users[MAX_USERS];     
    MSG msgPer[MAX_MSG_PERSISTENTE];  
    int numUsers, numMsgs, block;                     
    pthread_mutex_t* m;               
} Topic;

void removeTopic(Topic* topic, Topic topics[]);
void exit_signal(User users[]);
int login(User *new_user ,User users[]);
void loginIn(MSG msg);
void printUsers(User users[]);
int msgManager(MSG msg, Topic topics[]);
void printTopics(Topic topics[]);
int subscribe(MSG *msg, Topic topics[]);
int addPersistentMsg(MSG msg, Topic topics[]);
int unsubscribe(MSG *msg, Topic topics[]);
void lock(Topic topics[], char topic[]);
void unlock(Topic topics[], char topic[]);
void save_persistent_messages(const char* filename, Topic topics[]);
void load_persistent_messages(const char* filename, Topic topics[]);
void showTopic(Topic topics[], char topic[]);
void removeTopic(Topic *topic, Topic topics[]);
void removeUser(User *usr, Topic topics[], User users[]);
void userExitHandler(int signum, siginfo_t *info, void *secret);
void* TimerPersistentMsg(void* dados);
void *recebePipes(void* msgFeed);

#endif 