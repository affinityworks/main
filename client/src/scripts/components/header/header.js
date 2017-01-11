import React from 'react';

import style from './header.scss';
import logo from '../../../img/logo.png';

export default function Header() {
  return (
    <div className="header" style={style}>
      <h2>
        <img
          className="app-logo"
          alt="Advocacy Commons Logo"
          src={logo}
        />
        Advocacy Commons
      </h2>
    </div>
  );
}
