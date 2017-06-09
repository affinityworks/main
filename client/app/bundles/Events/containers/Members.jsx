import React, { Component } from 'react';
import axios from 'axios';
import queryString from 'query-string';
import Nav from '../components/Nav';
import { connect } from 'react-redux';

import history from '../history';
import GroupMembers from '../components/Members';
import Breadcrumbs from '../components/Breadcrumbs';
import { isNationalOrgnizer, managingCurrentGroup } from '../utils/Permissions'

class Members extends Component {
  showGroupName() {
    const { currentGroup, currentRole } = this.props;
    return (isNationalOrgnizer(currentRole) && managingCurrentGroup(currentGroup))
  }

  render() {
    const { currentGroup, location } = this.props;

    return (
      <div>
        <Breadcrumbs active='All Members' location={location} />

        <br />

        <Nav activeTab='members'/>

        <GroupMembers location={this.props.location} history={this.props.history}
          showGroupName={this.showGroupName()}
        />
      </div>
    );
  }
}

const mapStateToProps = ({ currentGroup, currentRole }) => {
  return { currentGroup, currentRole }
};

export default connect(mapStateToProps)(Members);
