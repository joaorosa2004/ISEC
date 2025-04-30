//
// Created by reisd on 11/12/2023.
//

#include "funcao.h"
#include "utils.h"
int calcula_fit(int a[], int *mat, int vert) {
    int total = 0;
    // Array de conexões
    int con[vert];
    for (int i = 0; i < vert; i++) {
        con[i] = 0;
    }

    // Loop por toda a matriz para verificar se é válida
    for (int i = 0; i < vert; i++) {
        // Verifica se a linha pertence à solução
        if (a[i] == 1) {
            for (int j = 0; j < vert; j++) {
                // Verifica se há uma conexão entre os vértices i e j

                if (a[j] == 1 && *(mat+i*vert+j) != 0) {
                    con[i] = 1;
                    con[j] = 1;
                    // Adiciona o custo
                   // printf("%d",*(mat + i * vert + j));
                    total += *(mat + i * vert + j);
                }

            }
        }
    }

    // Verifica se a solução é válida
    for (int i = 0; i < vert; i++) {
        if (con[i] == 0 && a[i] == 1) {
            // Solução inválida
            return 5000;
        }
    }

    // Retorna o custo total
    return total/2;
}

int avaliaIndividual_2(int solucao[], struct info *d, int *grafo,int *valido) {
    int total = 0,contador=0;
    // Array de conexões
    int con[d->v];
    for (int i = 0; i < d->v; i++) {
        con[i] = 0;
    }

    for(int y=0;y<d->v;y++)
    {
        if(solucao[y]==1)
        {
            contador++;
        }
    }
    if(contador!=d->k)
    {
        *valido=1;
    }
    else
    {
        *valido=0;
    }
    // Loop por toda a matriz para verificar se é válida
    for (int i = 0; i < d->v; i++) {
        // Verifica se a linha pertence à solução

        if (solucao[i] == 1) {
            for (int j = 0; j < d->v; j++) {
                // Verifica se há uma conexão entre os vértices i e j
                if (solucao[j] == 1 && *(grafo + i * d->v + j) != 0) {
                    con[i] = 1;
                    con[j] = 1;
                    // Adiciona o custo

                    total += *(grafo + i * d->v + j);
                }

            }
        }
    }
    // Verifica se a solução é válida
    for (int i = 0; i < d->v; i++) {
        if ((con[i] == 0 && solucao[i] == 1)||*valido==1) {
            // Solução inválida
            return 5000;
        }
    }
    return total/2;
}