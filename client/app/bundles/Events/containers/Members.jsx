import React, { Component } from 'react';
import queryString from 'query-string';
import { connect } from 'react-redux';

import history from '../history';
import Nav from '../components/Nav';
import GroupMembers from '../components/Members';
import Breadcrumbs from '../components/Breadcrumbs';
import { deleteMembership, fetchCurrentUserGroups } from '../actions';
import { managingCurrentGroupWithAffiliates } from '../utils';

class Members extends Component {
  showGroupName() {
    const { currentGroup } = this.props;
    return managingCurrentGroupWithAffiliates(currentGroup);
  }

  render() {
    const { currentRole, currentGroup, location, deleteMembership } = this.props;
    const activeText = 'Members';

    return (
      <div>
        <Breadcrumbs
          active={activeText}
          location={location}
        />

        <br />

        <Nav activeTab='members' />

        <GroupMembers
          location={this.props.location}
          history={this.props.history}
          showGroupName={this.showGroupName()}
          currentRole={currentRole}
          deleteMembership={deleteMembership}
        />
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { currentGroup, currentRole } = state;
  return { currentGroup, currentRole };
};

const actions = {
  deleteMembership,
  fetchCurrentUserGroups
};

export default connect(mapStateToProps, actions)(Members);
