import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';

import NavItem from './NavItem';
import { membersPath, eventsPath, affiliatesPath, groupsPath } from '../utils/Pathnames';

class Nav extends Component {
  renderGroupsTab() {
    const { activeTab, root } = this.props;

    if (this.isNationalOrgnizer() && root)
      return <NavItem
        title='Groups'
        path={groupsPath()}
        active={activeTab === 'groups'}
      />
  }

  isNationalOrgnizer() {
    return this.props.currentRole == 'national_organizer';
  }

  render() {
    const { activeTab, root } = this.props;

    return (
      <div>
        <ul className="nav nav-tabs">
          {this.renderGroupsTab()}

          <NavItem
            title={`${this.isNationalOrgnizer() && root ? 'All' : ''} Members`}
            path={membersPath()}
            active={activeTab === 'members'}
          />

          <NavItem
            title={`${this.isNationalOrgnizer() && root ? 'All' : ''} Events`}
            path={eventsPath()}
            active={activeTab === 'events'}
          />
        </ul>
        <br />
      </div>
    );
  }
}

const mapStateToProps = ({ currentRole }) => {
  return { currentRole }
};

export default connect(mapStateToProps)(Nav);
