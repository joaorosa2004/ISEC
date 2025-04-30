import React, { Component } from 'react';
import './Jogo.css';
import Tabuleiro from './Tabuleiro';
import Estado from './Estado';
import NivelDificuldade from './NivelDificuldade';

// Frases usadas para representar o estado do jogo
const COMECAR = 'Pronto para começar!';
const RECOMECAR = 'Recomeçar jogo';
const PERDEU = 'ACABOU O JOGO!';
const GANHOU = 'GANHOU O JOGO!';

class Jogo extends Component {
  // Função para gerar um número aleatório entre um mínimo e máximo
  static numeroAleatorio(minimo, maximo) {
    return Math.floor(Math.random() * (maximo - minimo + 1)) + minimo;
  }

  // Função para verificar se uma célula contém uma mina
  static temMina(quadrados, linha, coluna) {
    return quadrados[linha][coluna] === 'M';
  }

  // Função para gerar um array bidimensional com valores iniciais
  static gerarArray(altura, largura, valor) {
    return Array.from(
      { length: altura },
      () => Array.from({ length: largura }, () => valor)
    );
  }

  // Função para obter a solução do jogo
  static obterSolucao(jogo, solucao, simbolo) {
    return jogo.map(
      (linha, indiceLinha) => linha.map(
        (quadrado, indiceQuadrado) =>
          Jogo.temMina(solucao, indiceLinha, indiceQuadrado) ? simbolo : solucao[indiceLinha][indiceQuadrado]
      )
    );
  }

  // Função para verificar se ainda há movimentos restantes
  static haMovimentosRestantes(quadrados, maximoMinas) {
    return quadrados.flat().filter(
      quad => (quad === null || quad === 'B')
    ).length > maximoMinas;
  }

  // Função para adicionar zeros à esquerda de um número
  static adicionarZerosAEsquerda(numero) {
    if (numero < 0) {
      return '-' + Math.abs(numero).toString().padStart(2, '0');
    }

    return numero.toString().padStart(3, '0');
  }

  constructor(props) {
    super(props);
    this.state = this.obterEstadoInicial();
  }

  // Função para reiniciar o jogo
  reiniciar(...args) {
    this.setState(this.obterEstadoInicial(...args));
  }

  // Função para obter o estado inicial do jogo
  obterEstadoInicial(altura = 9, largura = 9, maximoMinas = 10) {
    // Para o timer se estiver rodando
    this.pararTemporizador();

    // Retorna o estado inicial do jogo
    return {
      altura: altura,  // Altura do tabuleiro
      largura: largura,    // Largura do tabuleiro
      maximoMinas: maximoMinas,  // Número máximo de minas
      minasFaltam: maximoMinas,     // Número de minas restantes
      jogo: Jogo.gerarArray(altura, largura, null), // Cria o tabuleiro vazio
      solucao: null, // Solução não é conhecida no início
      jogoComecou: false,  // Indica se o jogo já começou
      jogoTerminado: false, // Indica se o jogo já terminou
      estadoBotao: COMECAR, // Estado inicial do botão
      tempo: 0,  // Tempo inicial
      inicio: 0, // Momento em que o jogo começou
    };
  }

  // Função para verificar se o jogo já começou
  verificarInicio() {
    if (!this.state.jogoComecou) {
      this.iniciarTemporizador();
    }
  }

  // Função para lidar com cliques nas células
  lidarComClique(linha, coluna) {
    let jogo = this.state.jogo.slice(); // Cria uma cópia do tabuleiro atual
    let solucao;

    // Se a solução ainda não foi gerada, gera um novo jogo
    if (!this.state.solucao) {
      solucao = this.gerarJogo(this.state.altura, this.state.largura, linha, coluna, this.state.maximoMinas);
      this.setState({ jogoComecou: true, solucao: solucao });
    } else {
      solucao = this.state.solucao.slice(); // Cria uma cópia da solução
    }
    this.setState({ estadoBotao: RECOMECAR }); // Atualiza o botão para "Recomeçar jogo!"
    this.verificarInicio();

    // Se o jogo terminou ou a célula já foi clicada, retorna
    if (this.state.jogoTerminado || jogo[linha][coluna] !== null) {
      return;
    }

    // Revela a célula clicada
    this.revelar(jogo, solucao, linha, coluna);

    // Atualiza o estado do jogo
    this.atualizarEstadoJogo(jogo, solucao, linha, coluna);
  }

  // Função para lidar com cliques com o botão direito nas células
  lidarComCliqueDireito(evento, linha, coluna) {
    let jogo = this.state.jogo.slice(); // Cria uma cópia do tabuleiro atual
    evento.preventDefault(); // Previne o menu de contexto padrão do clique com o botão direito
    this.setState({ estadoBotao: RECOMECAR }); // Atualiza o botão para "Recomeçar jogo!"
    this.verificarInicio();

    let valor = jogo[linha][coluna];
    // Se o jogo terminou ou a célula já foi revelada (mas não marcada), retorna
    if (this.state.jogoTerminado || (valor !== null && valor !== 'I' && valor !== 'B')) {
      return;
    }

    if (valor === null) {
      jogo[linha][coluna] = 'B'; // Primeiro clique: bandeira
      this.setState(prevState => ({ minasFaltam: prevState.minasFaltam - 1 }));
    } else if (valor === 'B') {
      jogo[linha][coluna] = 'I'; // Segundo clique: ponto de interrogação
      this.setState(prevState => ({ minasFaltam: prevState.minasFaltam + 1 }));
    } else if (valor === 'I') {
      jogo[linha][coluna] = null; // Terceiro clique: desmarcar
    }

    // Atualiza o estado com a nova marcação
    this.setState({ jogo });
  }

  // Função para revelar células
  revelar(jogo, solucao, linha, coluna) {
    // Se a célula não está no intervalo ou já foi revelada, retorna
    if (!this.noIntervalo(linha, coluna) || jogo[linha][coluna] !== null) {
      return;
    }

    // Revela a célula
    jogo[linha][coluna] = solucao[linha][coluna];

    // Se a célula é vazia, expande a revelação
    if (jogo[linha][coluna] === 0) {
      this.expandir(jogo, solucao, linha, coluna);
    }
  }

  // Função para expandir a revelação de células adjacentes
  expandir(jogo, solucao, linha, coluna) {
    this.revelar(jogo, solucao, linha - 1, coluna);
    this.revelar(jogo, solucao, linha + 1, coluna);
    this.revelar(jogo, solucao, linha, coluna - 1);
    this.revelar(jogo, solucao, linha, coluna + 1);
    this.revelar(jogo, solucao, linha - 1, coluna - 1);
    this.revelar(jogo, solucao, linha - 1, coluna + 1);
    this.revelar(jogo, solucao, linha + 1, coluna + 1);
    this.revelar(jogo, solucao, linha + 1, coluna - 1);
  }

  // Função para atualizar o estado do jogo
  atualizarEstadoJogo(jogo, solucao, linha, coluna) {
    // Se a célula clicada é uma mina, termina o jogo
    if (Jogo.temMina(solucao, linha, coluna)) {
      return this.definirFimDeJogo(jogo, solucao, linha, coluna);
    }

    // Verifica se o jogo terminou (não há mais movimentos restantes)
    const jogoTerminado = !Jogo.haMovimentosRestantes(jogo, this.state.maximoMinas);
    const estadoBotao = jogoTerminado ? GANHOU : this.state.estadoBotao;
    let minasFaltam = this.state.minasFaltam;

    if (jogoTerminado) {
      // Para o timer e revela todas as minas
      this.pararTemporizador();
      jogo = Jogo.obterSolucao(jogo, solucao, 'B');
      minasFaltam = 0;
    }

    // Atualiza o estado com o novo estado do jogo
    this.setState({ jogo, jogoTerminado, estadoBotao, minasFaltam });
  }

  // Função para definir o jogo como terminado
  definirFimDeJogo(jogo, solucao, linha, coluna) {
    this.pararTemporizador();

    // Revela todas as minas e marca incorretamente as bandeiras
    jogo = jogo.map(
      (linhaJogo, indiceLinha) => linhaJogo.map(
        (quadrado, indiceQuadrado) => {
          const temMina = Jogo.temMina(solucao, indiceLinha, indiceQuadrado);
          if (quadrado === 'B') {
            return temMina ? quadrado : 'E';
          }

          return temMina ? 'M' : quadrado;
        }
      )
    );

    jogo[linha][coluna] = 'C'; // Célula da mina clicada que levou ao game over

    // Atualiza o estado para refletir que o jogo terminou
    this.setState({
      jogo,
      jogoTerminado: true,
      estadoBotao: PERDEU,
    });
  }

  // Função para gerar o campo minado
  gerarJogo(altura, largura, linhaAtual, colunaAtual, maximoMinas) {
    const jogo = Jogo.gerarArray(altura, largura, 0); // Inicializa o tabuleiro com zeros
    let minasGeradas = 0;
    let linha;
    let coluna;

    // Gera minas aleatoriamente até atingir o máximo
    while (minasGeradas < maximoMinas) {
      linha = Jogo.numeroAleatorio(0, altura - 1);
      coluna = Jogo.numeroAleatorio(0, largura - 1);

      // Verifica se a célula já contém uma mina ou é a célula inicial clicada
      if (!Jogo.temMina(jogo, linha, coluna) && !(linhaAtual === linha && colunaAtual === coluna)) {
        jogo[linha][coluna] = 'M'; // Coloca uma mina na célula
        // Incrementa o contador de minas nas células adjacentes
        this.incrementarMinasProximas(jogo, linha - 1, coluna);
        this.incrementarMinasProximas(jogo, linha + 1, coluna);
        this.incrementarMinasProximas(jogo, linha, coluna - 1);
        this.incrementarMinasProximas(jogo, linha, coluna + 1);
        this.incrementarMinasProximas(jogo, linha - 1, coluna - 1);
        this.incrementarMinasProximas(jogo, linha - 1, coluna + 1);
        this.incrementarMinasProximas(jogo, linha + 1, coluna + 1);
        this.incrementarMinasProximas(jogo, linha + 1, coluna - 1);
        minasGeradas++;
      }
    }

    return jogo;
  }

  // Função para incrementar o contador de minas nas células adjacentes
  incrementarMinasProximas(jogo, linha, coluna) {
    if (this.noIntervalo(linha, coluna) && !Jogo.temMina(jogo, linha, coluna)) {
      jogo[linha][coluna] = jogo[linha][coluna] + 1; // Incrementa o contador
    }
  }

  // Função para verificar se a célula está dentro dos limites do tabuleiro
  noIntervalo(linha, coluna) {
    return linha >= 0 && linha < this.state.altura
      && coluna >= 0 && coluna < this.state.largura;
  }

  // Função para iniciar o temporizador
  iniciarTemporizador() {
    this.setState({
      jogoComecou: true,
      tempo: 1,
      inicio: Date.now(),
    });
    if (this.temporizador) {
      this.pararTemporizador();
    }
    this.temporizador = setInterval(() => this.setState({
      tempo: Math.floor((Date.now() - this.state.inicio) / 1000) + 1,
    }), 1000);
  }

  // Função para parar o temporizador
  pararTemporizador() {
    clearInterval(this.temporizador);
  }

  // Função para verificar se o jogo atual tem as mesmas configurações
  eJogo(altura, largura, maximoMinas) {

    // Verifica se o número de minas é 10
    if (maximoMinas === 10) {
      return this.state.altura === altura
        && this.state.largura === largura
        && this.state.maximoMinas === 10;
    }

    // Verifica se o número de minas é 40
    if (maximoMinas === 40) {
      return this.state.altura === altura
        && this.state.largura === largura
        && this.state.maximoMinas === 40;
    }

    // Verifica se o número de minas é 99
    if (maximoMinas === 99) {
      return this.state.altura === altura
        && this.state.largura === largura
        && this.state.maximoMinas === 99;
    }
  }

  render() {
    return (
      <div className="Jogo"> {/* Container principal do jogo */}
        <div className="wrapper"> {/* Wrapper para o estado do jogo */}
          {/* Componente Estado exibe o botão de reiniciar, minas restantes e tempo */}
          <Estado
            estadoBotao={this.state.estadoBotao}
            minasFaltam={Jogo.adicionarZerosAEsquerda(this.state.minasFaltam)}
            tempo={Jogo.adicionarZerosAEsquerda(this.state.tempo)}
            onClick={() => this.reiniciar(this.state.altura, this.state.largura, this.state.maximoMinas)}
          />
        </div>
        {/* Componente Tabuleiro exibe o tabuleiro do jogo */}
        <Tabuleiro
          onClick={(linha, coluna) => this.lidarComClique(linha, coluna)}
          onRightClick={(evento, linha, coluna) => this.lidarComCliqueDireito(evento, linha, coluna)}
          jogo={this.state.jogo}
          jogoTerminado={this.state.jogoTerminado}
          largura={this.state.largura}
        />
        <div className="dificuldade"> {/* Container para os botões de nível de dificuldade */}
          <NivelDificuldade
            isSelected={this.eJogo(9, 9, 10)}
            onClick={() => this.reiniciar(9, 9, 10)}
            label="FÁCIL"
          />
          {/* Botão para nível de dificuldade MÉDIO */}
          <NivelDificuldade
            isSelected={this.eJogo(16, 16, 40)}
            onClick={() => this.reiniciar(16, 16, 40)}
            label="MÉDIO"
          />
          {/* Botão para nível de dificuldade DÍFICIL */}
          <NivelDificuldade
            isSelected={this.eJogo(16, 30, 99)}
            onClick={() => this.reiniciar(16, 30, 99)}
            label="DIFÍCIL"
          />
        </div>
      </div>
    );
  }

}

export default Jogo;
