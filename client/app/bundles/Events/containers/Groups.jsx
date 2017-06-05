import React, { Component } from 'react';

import GroupsList from '../components/Groups';
import Nav from '../components/Nav';
import Breadcrumbs from '../components/Breadcrumbs';

class Groups extends Component {
  render() {
    return (
      <div>
        <Breadcrumbs active='All Groups' />

        <Nav activeTab='groups' />

        <GroupsList location={this.props.location} />
      </div>
    );
  }
}

export default Groups;
