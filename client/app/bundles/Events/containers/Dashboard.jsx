import React, { Component } from 'react';

import Nav from '../components/Nav';

class Dashboard extends Component {
  render() {
    return (
      <div>
        <Nav activeTab='dashboard' />
      </div>
    );
  }
}

export default Dashboard;
