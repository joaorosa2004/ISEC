//
// Created by reisd on 11/12/2023.
//

#ifndef T2_UTILS_H
#define T2_UTILS_H

#include "algoritmo.h"

int* init_dados(char *nome, int *v, int *ar, int *k);
pchrom initPop(struct info *d);
struct info leAE(char *nome_fich);
chrom getMelhor(pchrom pop, struct info *d, chrom best);
void mostraPop(chrom *x, struct info *d);
void verificaGeral_2(pchrom pop, struct info *d,int* grafo);
void gera_sol_inicial(int *sol, int v,int k);
void escreve_sol(int *sol, int vert);
void substitui(int a[], int b[], int n);
void init_rand();
int random_l_h(int min, int max);
float rand_01();

#endif //T2_UTILS_H
