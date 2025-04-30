//
// Created by reisd on 11/12/2023.
//
#include <stdio.h>
#include <stdlib.h>
#include "funcao.h"
#include "utils.h"
#include "algoritmo.h"


void gera_vizinho(int a[], int b[], int n)
{
    int i, p1, p2,indice=2;

    for(i=0; i<n; i++){
        b[i]=a[i];}
        for(i=0;i<indice;i++) {
            // Encontra posicao com valor 0
            do
                p1 = random_l_h(0, n - 1);
            while (b[p1] != 0);
            // Encontra posicao com valor 0
            do
                p2 = random_l_h(0, n - 1);
            while (b[p2] != 1);
            // Troca
            b[p1] = 1;
            b[p2] = 0;
        }
    }
void torneioSelecao(pchrom pop, struct info *d, pchrom pais){
    int a,b;


    for(int i = 0; i < d->popsize;i++){

        //gero um indice aleatorio
        a = random_l_h(0,(d->popsize-1));

        // gero outro indice aleatorio ate ambos serem diferentes
        do
            b = random_l_h(0,(d->popsize-1));
        while(a == b);

        if(pop[a].fitness < pop[b].fitness)
            pais[i] = pop[a];
        else
            pais[i] = pop[b];
    }
}

void selecaoProporcional(pchrom pop, struct info *d, pchrom pais) {
    int fitness_total = 0;
    double *probabilidades = malloc(sizeof(double ) * d->popsize);

    // Calcula o fitness total da população
    for (int i = 0; i < d->popsize; i++) {
        fitness_total += pop[i].fitness;
    }

    // Calcula as probabilidades de seleção para cada indivíduo
    for (int i = 0; i < d->popsize; i++) {
        probabilidades[i] = (double)pop[i].fitness / fitness_total;
    }

    // Realiza a seleção proporcional
    for (int i = 0; i < d->popsize; i++) {
        double r = rand_01(); // Gera um número aleatório entre 0 e 1
        double somaprobabilidades = 0;
        int j = 0;

        // Encontra o indivíduo correspondente à probabilidade gerada aleatoriamente
        while (somaprobabilidades < r && j < d->popsize) {
            somaprobabilidades += probabilidades[j];
            j++;
        }

        // Salva o indivíduo selecionado na lista de pais
        pais[i] = pop[j - 1]; // Decrementa j para ajustar ao índice do vetor
    }

    free(probabilidades);
}

void recombinacao(pchrom pais, struct info *d, pchrom filhos){

    //ponto de corte aleatorio
        int ponto,j;

    for(int i = 0; i < d->popsize; i+=2){

        // vai haver ponto de corte
        if(rand_01() < d->pr){
            ponto = random_l_h(0, d->v);
            for(j = 0; j < ponto; j++){
                // passamos ao mesmo tempo os numeros ate ao ponto de corte
                filhos[i].p[j] = pais[i].p[j];
                filhos[i+1].p[j] = pais[i+1].p[j];
            }
            // preenchemos o primeiro filho
            if(j == ponto){
                for(int x = j; x < d->v; x++)
                    filhos[i].p[x] = pais[i+1].p[x];
            }
            // preenchemos o segundo filho
            j = ponto;
            for(int x = j; x < d->v; x++)
                filhos[i+1].p[x] = pais[i].p[x];
        }

        else{
            // faz uma copia exata porque nao houve a pr
            filhos[i] = pais[i];
            filhos[i+1] = pais[i+1];
        }
    }
}



void mutacao(pchrom filhos, struct info *d){
    int num;

    for(int i = 0; i < d->popsize; i++){
        for(int j = 0; j < d->v; j++){
            if(rand_01() < d->pm){

                // encontramos um nr aleatorio != do nr atual
                do{
                    num = random_l_h(0,1);
                }while(num == filhos[i].p[j]);

                // alteramos o nr atual pelo num
                filhos[i].p[j] = num;
            }
        }
    }
}

void recombinaUniforme(pchrom pais, struct info *d, pchrom filhos) {
    for (int i = 0; i < d->popsize; i += 2) {
        for (int j = 0; j < d->v; j++) {
            if(rand_01() < d->pr){
            // Gera um número aleatório entre 0 e 1 para decidir a fonte do gene
            float prob = rand_01();

            // Se prob for menor que 0.5, utiliza o gene do primeiro pai
            // Caso contrário, utiliza o gene do segundo pai
            if (prob < 0.5) {
                filhos[i].p[j] = pais[i].p[j];
                filhos[i + 1].p[j] = pais[i + 1].p[j];
            } else {
                filhos[i].p[j] = pais[i + 1].p[j];
                filhos[i + 1].p[j] = pais[i].p[j];
            }
         }
            else{
                filhos[i] = pais[i];
                filhos[i+1] = pais[i+1];
        }

        }
    }

}

void inversaoMutacao(pchrom filhos, struct info *d) {
    int ponto1, ponto2;

    for(int i = 0; i < d->popsize; i++) {
        if(rand_01() < d->pm) {
            ponto1 = random_l_h(0, d->v - 1);
            ponto2 = random_l_h(0, d->v - 1);

            if (ponto2 < ponto1) {
                int temp = ponto1;
                ponto1 = ponto2;
                ponto2 = temp;
            }

            while (ponto1 < ponto2) {
                // Realiza a inversão dos genes entre os pontos 1 e 2
                int temp = filhos[i].p[ponto1];
                filhos[i].p[ponto1] = filhos[i].p[ponto2];
                filhos[i].p[ponto2] = temp;

                ponto1++;
                ponto2--;
            }
        }
    }

}

// Trepa colinas first-choice
// Parametros: solucao, matriz de adjacencias, numero de vertices e numero de iteracoes
// Devolve o custo da melhor solucao encontrada
int trepa_colinas(int sol[], int *mat, int vert, int num_iter)
{
    int *nova_sol, custo, custo_viz, i;

    nova_sol = malloc(sizeof(int)*vert);
    if(nova_sol == NULL)
    {
        printf("Erro na alocacao de memoria");
        exit(1);
    }
    // Avalia solucao inicial
    custo = calcula_fit(sol, mat, vert);
    for(i=0; i<num_iter; i++)
    {
        gera_vizinho(sol, nova_sol, vert);
        // Avalia vizinho
        custo_viz = calcula_fit(nova_sol, mat, vert);
        if(custo_viz < custo)
        {
            substitui(sol, nova_sol, vert);
            custo = custo_viz;
        }
    }
    free(nova_sol);
    return custo;
}
