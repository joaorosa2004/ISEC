//
// Created by reisd on 11/12/2023.
//

#ifndef T2_ALGORITMO_H
#define T2_ALGORITMO_H
typedef struct Info info;
struct info{

    //tamanho da populacao
    int popsize;

    // probabilidade de mutacao
    float pm;

    // probabilidade de recombinacao
    float pr;

    //tamanho do torneio de selecao (vai ser sempre 2)
    int tsize;

    //penalizacao
    int pen;
    int k;
    // numero de subconjuntos (g)
    int v;

    // v(v)
    int ar;


    // numero de geracoes
    int numGeracoes;
};

typedef struct  individual chrom, *pchrom;
struct individual {


    // solucao
    int p[10000];

    // valor da fitnesss
    int fitness;

    // flag para ver se solucao e ou nao valida
    int validez;
};
int trepa_colinas(int sol[], int *mat, int vert, int num_iter);
void torneioSelecao(pchrom pop, struct info *d, pchrom pais);
void selecaoProporcional(pchrom pop, struct info *d, pchrom pais);
void mutacao(pchrom filhos, struct info *d);
void inversaoMutacao(pchrom filhos, struct info *d);
void recombinaUniforme(pchrom pais, struct info *d, pchrom filhos);
void recombinacao(pchrom pais, struct info *d, pchrom filhos);
#endif //T2_ALGORITMO_H
