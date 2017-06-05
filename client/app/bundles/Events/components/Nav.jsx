import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';

import NavItem from './NavItem';
import { membersPath, eventsPath, affiliatesPath, groupsPath, groupId } from '../utils/Pathnames';

class Nav extends Component {
  renderGroupsTab() {
    const { activeTab } = this.props;

    if (this.isRootNav())
      return <NavItem
        title='Groups'
        path={groupsPath()}
        active={activeTab === 'groups'}
      />
  }

  isNationalOrgnizer() {
    return this.props.currentRole === 'national_organizer';
  }

  managingCurrentGroup() {
    return this.props.currentGroup.id == groupId()
  }

  isRootNav() {
    return this.isNationalOrgnizer() && this.managingCurrentGroup();
  }

  render() {
    const { activeTab } = this.props;

    return (
      <div>
        <ul className="nav nav-tabs">
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
