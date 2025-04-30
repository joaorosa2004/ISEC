#include <stdio.h>
#include <stdlib.h>

#include "utils.h"
#include "algoritmo.h"
#define tam 50
#define DEFAULT_RUNS 10
int main() {

    char nfile[tam];
    int i,vert,runs,ar,k,custo,best_custo,escolha;
    int g_atual;
    pchrom pop= NULL;
    pchrom pais=NULL;
    chrom best_pop, best_pop_final;

    int     *grafo, *sol, *best,p;
    struct info AE_param;
    double   mbf = 0.0;
    runs=DEFAULT_RUNS;
    printf("Introduza nome do ficheiro:");
    gets(nfile);

    if(runs <= 0)
        return 0;
    init_rand();
    // Preenche matriz de adjacencias
    grafo = init_dados(nfile, &vert, &ar,&k);


    if(vert>500)
    {
        printf("Vertices acima do aguentado\n");
        return 0;
    }

        printf("1-Colina\n2-Evolutivo\n3-Misto\n");
    do {
        scanf("%d", &escolha);
    }while(escolha>3||escolha<1);

    if(escolha==1) {
        sol = malloc(sizeof(int) * vert);
        best = malloc(sizeof(int) * vert);

        if (sol == NULL || best == NULL) {
            printf("Erro na alocacao de memoria");
            exit(1);
        }
        for (i = 0; i < runs; i++) {
            // Gerar solucao inicial
            gera_sol_inicial(sol, vert, k);
            puts("\n");

            printf("\nSolucao inicial %d:", i);
            escreve_sol(sol, vert);
            // Trepa colinas

            custo = trepa_colinas(sol, grafo, vert, 100000);
            printf("Custo final: %2d\n", custo);
            mbf += custo;
            if (i == 0 || best_custo > custo) {
                best_custo = custo;
                substitui(best, sol, vert);
            }
        }
        // Escreve eresultados globais
        printf("\n\nMBF: %.2f\n", (float) mbf / i);
        printf("\nMelhor solucao encontrada");
        escreve_sol(best, vert);
        printf("Custo final: %2d\n", best_custo);
        free(grafo);
        free(sol);
        free(best);
        return 0;
    }
    else if(escolha==2)
    {
        int escolha_selecao;
        printf("1-Selecao por torneio\n2-Selecao proporcional\n");
        do {
            scanf("%d", &escolha_selecao);
        } while (escolha_selecao<1||escolha_selecao>2);
        AE_param = leAE(nfile);
        for (i = 0; i < runs; i++) {
            printf("\nSolucao inicial %d:\n", i);
            pop = initPop(&AE_param);

            // for(int j=0;j<vert;j++)
            //printf("%d ",pop->p[j]);

            verificaGeral_2(pop,&AE_param,grafo);

            g_atual=1;

            best_pop = pop[0];

            best_pop = getMelhor(pop,&AE_param,best_pop);


            pais = malloc(sizeof(chrom) * AE_param.popsize);
            if (pais == NULL) {
                printf("Erro na alocacao de memoria\n");
                exit(1);
            }

            while (g_atual <= AE_param.numGeracoes) {
                //torneio binario
               if(escolha_selecao==1) {
                   torneioSelecao(pop, &AE_param, pais);

                   //aplicar os operadores geneticos

                   //crossover


                       recombinacao(pais, &AE_param, pop);


                   //mutacao


                       mutacao(pop, &AE_param);

               }
               if(escolha_selecao==2)
               {
                   /*
                   selecaoProporcional(pop, &AE_param, pais);

                   recombinaUniforme(pais, &AE_param, pop);

                   inversaoMutacao(pop, &AE_param);
                    */
               }

                //avalia a nova pop
                 verificaGeral_2(pop,&AE_param,grafo);

                //atualizar a melhor solucao encontrada
                best_pop = getMelhor(pop, &AE_param, best_pop);


                //incrementamos a geracao atual
                g_atual++;

            }
            free(pais);
            printf("\nNa repeticao %d a melhor solucao foi: ", i);
            mostraPop(&best_pop, &AE_param);

            mbf += best_pop.fitness;

            if(i == 0 || best_pop.fitness < best_pop_final.fitness)
                best_pop_final = best_pop;


            free(pop);
        }
        printf("\n\nMBF: %f\n", mbf/i);
        printf("\nMelhor solucao encontrada");
        mostraPop(&best_pop_final,&AE_param);


        return 0;
    }
    else if(escolha==3)
    {

        return 0;
    }

    return 0;
}



