import React from 'react'; // Importa o módulo React, necessário para criar componentes React
import './Jogo.css'; // Importa o arquivo CSS associado a este componente

// Definição de classes CSS para os diferentes valores do tabuleiro do jogo
const classesEmojis = {
  'C': 'emoji mina clicada', 
  'M': 'emoji mina', 
  'B': 'emoji bandeira', 
  'E': 'emoji errado', 
  'I': 'interrogacao', 
  null: 'por selecionar', 
};

// Definição de símbolos para os diferentes valores do tabuleiro do jogo
const simbolosEmoji = {
  'C': '💣', 
  'M': '💣', 
  'B': '🚩', 
  'E': 'X', 
  'I': '?', 
};

// Função para obter a classe CSS com base no valor da célula
const obterClasse = valor => classesEmojis[valor] || 'revelado numero' + valor;

// Função para obter o símbolo correspondente ao valor da célula
const obterSimbolo = valor => simbolosEmoji[valor] || (valor ? valor : null);

// Componente funcional Quadrado que representa uma célula do tabuleiro do jogo
export default function Quadrado(props) {
  return (
    <button
      className={`Quadrado ${obterClasse(props.valor)}`} // Aplica classes CSS dinamicamente com base no valor da célula
      onClick={props.onClick} // Manipulador de evento para cliques na célula
      onContextMenu={props.onRightClick} // Manipulador de evento para cliques com o botão direito do mouse na célula
    >
      {obterSimbolo(props.valor)} {/* Renderiza o símbolo correspondente ao valor da célula */}
    </button>
  );
};
