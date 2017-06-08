import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';

import NavItem from './NavItem';

import {
  membersPath,
  eventsPath,
  affiliatesPath,
  dashboardPath
} from '../utils/Pathnames';

import { isNationalOrgnizer, managingCurrentGroup } from '../utils/Permissions'

class Nav extends Component {
  renderGroupsTab() {
    const { activeTab } = this.props;

    if (this.isRootNav())
      return <NavItem
        title='Groups'
        path={affiliatesPath()}
        active={activeTab === 'groups'}
      />
  }

  isRootNav() {
    return isNationalOrgnizer(this.props.currentRole) && managingCurrentGroup(this.props.currentGroup);
  }

  render() {
    const { activeTab } = this.props;

    return (
      <div>
        <ul className="nav nav-tabs">
          <NavItem
            title='Dashboard'
            path={dashboardPath()}
            active={activeTab === 'dashboard'}
          />

          {this.renderGroupsTab()}

          <NavItem
            title={`${this.isRootNav() ? 'All' : ''} Members`}
            path={membersPath()}
            active={activeTab === 'members'}
          />

          <NavItem
            title={`${this.isRootNav() ? 'All' : ''} Events`}
            path={eventsPath()}
            active={activeTab === 'events'}
          />
        </ul>
        <br />
      </div>
    );
  }
}

const mapStateToProps = ({ currentRole, currentGroup }) => {
  return { currentRole, currentGroup }
};

export default connect(mapStateToProps)(Nav);
