import React, { Component } from 'react';
import axios from 'axios';
import queryString from 'query-string';
import Nav from '../components/Nav';
import { connect } from 'react-redux';

import history from '../history';
import GroupMembers from '../components/Members';
import Breadcrumbs from '../components/Breadcrumbs';
import { managingCurrentGroupWithAffiliates } from '../utils/Permissions'

class Members extends Component {
  showGroupName() {
    const { currentGroup } = this.props;
    return managingCurrentGroupWithAffiliates(currentGroup);
  }

  render() {
    const { currentGroup, location } = this.props;
    const activeText = managingCurrentGroupWithAffiliates(currentGroup)
      ? 'All Members'
      : 'Members';

    return (
      <div>
        <Breadcrumbs active={activeText} location={location} />

        <br />

        <Nav activeTab='members'/>

        <GroupMembers location={this.props.location} history={this.props.history}
          showGroupName={this.showGroupName()}
        />
      </div>
    );
  }
}

const mapStateToProps = ({ currentGroup }) => {
  return { currentGroup }
};

export default connect(mapStateToProps)(Members);
