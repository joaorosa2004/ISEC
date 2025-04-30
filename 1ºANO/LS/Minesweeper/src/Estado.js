import React from 'react';
import './Jogo.css';

export default function Estado(props) {
  return (
    <div className="estado">
      <div className="minasFaltam">{props.minasFaltam}</div>
      <button className="reiniciar" onClick={props.onClick}>
        {props.estadoBotao}
      </button>
      <div className="cronometro">{props.tempo}</div>
    </div>
  );
};
