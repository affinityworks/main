import React, { Component } from 'react';
import axios from 'axios';

import Group from './Group';

class Groups extends Component {
  state = { groups: [] };

  componentDidMount() {
    const uri = `/groups.json`;

    axios.get(uri)
      .then(res => {
        const groups = res.data;
        this.setState({ groups });
      });
  }

  render() {
    return (
      <table className='table table-striped'>
        <thead>
          <tr>
            <th>Name</th>
            <th>Location</th>
            <th>Description</th>
            <th>Public Contact</th>
            <th>Leaders</th>
            <th>Internal Notes</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {this.state.groups.map(group => <Group key={group.id} group={group} />)}
        </tbody>
      </table>
    );
  }
}

export default Groups;
