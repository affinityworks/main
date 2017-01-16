import React, { Component } from 'react';

import style from './header.scss';
import logo from '../../../img/logo.png';

class Header extends Component {
  constructor() {
    super();
    this.goHome = this.goHome.bind(this);
  }

  goHome(e) {
    e.preventDefault();
    this.context.router.transitionTo('/');
  }

  render() {
    return (
      <a
        href=""
        className="header"
        style={style}
        onClick={this.goHome}
      >
        <h2>
          <img
            className="app-logo"
            alt="Advocacy Commons Logo"
            src={logo}
          />
          Advocacy Commons
        </h2>
      </a>
    );
  }
}

export default Header;

Header.contextTypes = {
  router: React.PropTypes.object,
};
