import React, { Component } from 'react';

import Breadcrumbs from '../components/Breadcrumbs';
import Nav from '../components/Nav';

class Dashboard extends Component {
  render() {
    return (
      <div>
        <Breadcrumbs active='Dashboard' />

        <br />
        
        <Nav activeTab='dashboard' />
      </div>
    );
  }
}

export default Dashboard;
