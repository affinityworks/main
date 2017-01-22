import React, { Component } from 'react';

import style from './header.scss';
import logo from '../../../img/logo.svg';

class Header extends Component {
  constructor(props) {
    super(props);
    this.goHome = this.goHome.bind(this);
  }

  goHome(e) {
    e.preventDefault();
    this.context.router.transitionTo('/');
  }

  render() {
    return (
      <div className="nav" style={style}>
        <a
          href="/"
          className="section home"
        >
          <img
            className="app-logo"
            alt="Advocacy Commons Logo"
            src={logo}
          />
          <span className="section-label">Advocacy Commons</span>
        </a>
        <a
          href="/"
          className={(this.props.current === 'group') ? 'section current' : 'section'}
        >
          <span className="section-label">Groups</span>
        </a>
        <a
          href="/"
          className={(this.props.current === 'events') ? 'section current' : 'section'}
        >
          <span className="section-label">Events</span>
        </a>
        <a
          href="/"
          className={(this.props.current === 'admin') ? 'section current' : 'section'}
        >
          <span className="section-label">Admin</span>
        </a>
      </div>

    );
  }
}

export default Header;

Header.contextTypes = {
  router: React.PropTypes.object,
};

Header.propTypes = {
  current: React.PropTypes.string,
};
