import React, { Component } from 'react';
import axios from 'axios';
import { connect } from 'react-redux';

import Group from './Group';
import { fetchGroups } from '../actions';

class Groups extends Component {
  componentWillMount() {
    this.props.fetchGroups();
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
          {this.props.groups.map(group => <Group key={group.id} group={group} />)}
        </tbody>
      </table>
    );
  }
}

const mapStateToProps = ({ groups }) => {
  return { groups };
};

export default connect(mapStateToProps, { fetchGroups })(Groups);
