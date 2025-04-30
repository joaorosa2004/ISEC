import React from 'react';
import './Jogo.css';

export default function NivelDificuldade(props) {
  return (
    <button
      className={'nivel-dificuldade ' + (props.isSelected ? 'selected' : '')}
      onClick={props.onClick}
    >
      {props.label}{' '}
    </button>
  );
};
