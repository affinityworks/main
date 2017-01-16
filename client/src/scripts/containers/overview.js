import React, { Component } from 'react';

import Header from '../components/header/header';

import style from './overview.scss';

class Overview extends Component {
  constructor() {
    super();
    this.goToGroup = this.goToGroup.bind(this);
  }

  goToGroup(e) {
    e.preventDefault();
    this.context.router.transitionTo('/group');
  }

  render() {
    return (
      <div className="overview" style={style}>
        <Header />
        <a
          href=""
          className="group-link"
          onClick={(e) => { this.goToGroup(e); }}
        >
          East Bay Rising
        </a>
      </div>
    );
  }

}

Overview.contextTypes = {
  router: React.PropTypes.object,
};

export default Overview;
