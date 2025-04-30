import React from 'react';
import Quadrado from './Quadrado';
import './Jogo.css';

// Função para renderizar um quadrado (Quadrado)
const renderizarQuadrado = (props, linha, coluna, valor) => {
  return (
    <Quadrado
      // Define uma chave única para cada quadrado com base na linha e coluna
      key={linha + "_" + coluna}
      // O valor que será exibido no quadrado
      valor={valor}
      // Função de clique esquerdo que chama props.onClick passando a linha e coluna
      onClick={() => props.onClick(linha, coluna)}
      // Função de clique direito que chama props.onRightClick passando o evento, linha e coluna
      onRightClick={(evento) => props.onRightClick(evento, linha, coluna)}
    />
  );
};

// Função para renderizar uma linha de quadrados
const renderizarLinha = (props, linha, itens) =>
  // Mapeia cada valor da linha (itens) e renderiza um quadrado para cada um
  itens.map((valor, chave) => renderizarQuadrado(props, linha, chave, valor));

// Componente Tabuleiro que renderiza todo o tabuleiro
export default function Tabuleiro(props) {
  return (
    <div
      // Adiciona a classe 'Tabuleiro' e, se o jogo terminou, adiciona também a classe 'desabilitado'
      className={'Tabuleiro' + (props.jogoTerminado ? ' desabilitado' : '')}
      // Define o layout da grade com um número de colunas baseado na largura (props.largura)
      style={{gridTemplateColumns: `repeat(${props.largura}, 1fr)`}}
    >
      {/* Mapeia cada linha do jogo e renderiza uma linha de quadrados */}
      {props.jogo.map((valor, chave) => renderizarLinha(props, chave, valor))}
    </div>
  );
};
