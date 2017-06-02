import React, { Component } from 'react';

import GroupsList from '../components/Groups';
import Nav from '../components/Nav';

class Groups extends Component {
  render() {
    return (
      <div>
        <Nav activeTab='groups' />

        <GroupsList location={this.props.location}/>
      </div>
    );
  }
}

export default Groups;
