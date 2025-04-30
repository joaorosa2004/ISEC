//
// Created by reisd on 11/12/2023.
//
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "utils.h"
#include "algoritmo.h"
#include "funcao.h"

int* init_dados(char *nome, int *v, int *ar ,int *k)
{
    FILE *f;
    int *p;
    int i, j,v1,v2,valor;

    f=fopen(nome, "r");
    if(!f)
    {
        printf("Erro no acesso ao ficheiro dos dados\n");
        exit(1);
    }

    fscanf(f, "k %d", k);
    // Numero de vertices
    fscanf(f, "\np edge %d %d", v,ar);
    // Alocacao dinamica da matriz
    p =  malloc(sizeof(int) * (*v) * (*v));
    if(!p)
    {
        printf("Erro na alocacao de memoria\n");
        exit(1);
    }

    // Preenchimento da matriz
    for(i=0; i<*v; i++)
        for(j=0; j<*v; j++)
            p[i*(*v)+j]=0;

    while(fscanf(f,"\ne %d %d %d",&v1,&v2,&valor)==3){
        p[(v1-1)*(*v)+(v2-1)]=valor;
        p[(v2-1)*(*v)+(v1-1)]=valor;
    }
    fclose(f);
    return p;
}

void gera_sol_inicial(int *sol, int v,int k)
{
    int i,x;
    for(i=0;i<v;i++)
    {
        sol[i]=0;
    }
    for(i=0;i<k;i++)
    {
        do{
            x= random_l_h(0,v-1);
        }while(sol[x]!=0);
    sol[x]=1;


    }
}

struct info leAE(char *nome_fich ){
    struct info temp;
    int v1,v2,valor,*p;
    FILE *f;

    f = fopen(nome_fich, "r");
    if(!f){
        printf("Erro ao abrir o ficheiro\n");
        exit(1);
    }

    fscanf(f, "k %d", &temp.k);
    // Numero de vertices
    fscanf(f, "\np edge %d %d", &temp.v,&temp.ar);
    p = malloc(sizeof(int)*(temp.v)*(temp.v));
    while(fscanf(f,"\ne %d %d %d",&v1,&v2,&valor)==3){
       p[(v1-1)*(temp.v)+(v2-1)]=valor;
       p[(v2-1)*(temp.v)+(v1-1)]=valor;
    }

    fclose(f);
    temp.pm = 0.01;
    temp.pr = 0.3;
    temp.tsize = 2;

    temp.popsize = 50000;
    temp.numGeracoes = 100;

    // printf("\nTamanho da populacao: ");scanf("%d",&temp.popsize);
    // printf("Tamanho do torneio: ");scanf("%d", &temp.tsize);
    //printf("Numero de geracoes: ");scanf("%d", &temp.numGeracoes);
    printf("\n");
    return temp;
}



pchrom initPop(struct info *d) {
    pchrom pop;
    pop = malloc(sizeof(chrom) * d->popsize);

    for (int j = 0; j < d->popsize; j++) {

        int aux[d->v];
        for (int i = 0; i < d->v; i++)
            aux[i] = 0;


        for (int i = 0; i < d->k; i++) {
            int x;
            do {
                x = random_l_h(0, d->v - 1);
            } while (aux[x] != 0);
            aux[x] = 1;

            pop[j].p[x] = aux[x];

        }

    }
    return pop;
}

void mostraPop(chrom *x, struct info *d){

    printf("\n[");
    for(int j = 0; j < d->v; j++){
        printf("%d ", x->p[j]);
    }
    printf("]\n");
    printf("Fitness:%d\n",x->fitness);
}
chrom getMelhor(pchrom pop, struct info *d, chrom best){

    for(int i = 0; i < d->popsize; i++){

        if(best.fitness > pop[i].fitness)
            best = pop[i];
    }

    return best;
}


// Escreve solucao
// Parametros: solucao e numero de vertices
void escreve_sol(int *sol, int vert)
{
    int i;

    printf("\nSolucao: ");
    for(i=0; i<vert; i++)

            printf("%d ", sol[i]);
    printf("\n");
}

void verificaGeral_2(pchrom pop, struct info *d,int *grafo){
    int i;
    for(i = 0; i < d->popsize; i++){
        pop[i].fitness = avaliaIndividual_2(pop[i].p, d,grafo,&pop[i].validez);
    }

}

// copia vector b para a (tamanho n)
void substitui(int a[], int b[], int n)
{
    int i;
    for(i=0; i<n; i++)
        a[i]=b[i];
}

// Inicializa o gerador de numeros aleatorios
void init_rand()
{
    srand((unsigned)time(NULL));
}

// Devolve valor inteiro aleatorio entre min e max
int random_l_h(int min, int max)
{
    return min + rand() % (max-min+1);
}

// Devolve um valor real aleatorio do intervalo [0, 1]
float rand_01()
{
    return ((float)rand())/RAND_MAX;
}
