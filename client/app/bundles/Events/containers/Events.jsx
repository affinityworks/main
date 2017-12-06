import React, { Component } from 'react';
import { connect } from 'react-redux';

import history from '../history';
import Nav from '../components/Nav';
import GroupEvents from '../components/Events';
import Breadcrumbs from '../components/Breadcrumbs';
import { fetchCurrentUserGroups } from '../actions';
import { managingCurrentGroupWithAffiliates } from '../utils'

class Events extends Component {
  showGroupName() {
    const { currentGroup } = this.props;
    return managingCurrentGroupWithAffiliates(currentGroup);
  }

  showPrintIcon() {
    const { currentGroup } = this.props;
    return (!(managingCurrentGroupWithAffiliates(currentGroup)));
  }

  render() {
    const { currentGroup, location, currentRole } = this.props;
    const activeText = managingCurrentGroupWithAffiliates(currentGroup)
      ? 'All Events'
      : 'Events';

    return (
      <div>
        <Breadcrumbs
          active={activeText}
          location={location}
        />

        <br />

        <Nav activeTab='events' />

        <GroupEvents
          currentGroup={this.props.currentGroup}
          location={this.props.location}
          history={this.props.history}
          showGroupName={this.showGroupName()}
          showPrintIcon={this.showPrintIcon()}
        />
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const {currentGroup, currentRole} = state;

  return { currentGroup, currentRole }
};

export default connect(mapStateToProps, { fetchCurrentUserGroups })(Events);
