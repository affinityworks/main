import React, { Component } from 'react';
import axios from 'axios';
import queryString from 'query-string';
import Nav from '../components/Nav';
import { connect } from 'react-redux';

import history from '../history';
import GroupMembers from '../components/Members';
import Breadcrumbs from '../components/Breadcrumbs';

class Members extends Component {
  render() {
    const { currentGroup } = this.props;

    return (
      <div>
        <Breadcrumbs active='All Members' />
        <h2>{`${currentGroup.name} Members`}</h2>
        <br />
        <Nav activeTab='members'/>

        <GroupMembers location={this.props.location} history={this.props.history} />
      </div>
    );
  }
}

const mapStateToProps = ({ currentGroup }) => {
  return { currentGroup }
};

export default connect(mapStateToProps)(Members);
