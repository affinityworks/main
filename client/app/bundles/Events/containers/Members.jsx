import React, { Component } from 'react';
import queryString from 'query-string';
import { connect } from 'react-redux';

import history from '../history';
import Nav from '../components/Nav';
import GroupMembers from '../components/Members';
import Breadcrumbs from '../components/Breadcrumbs';
import { managingCurrentGroupWithAffiliates } from '../utils'

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
