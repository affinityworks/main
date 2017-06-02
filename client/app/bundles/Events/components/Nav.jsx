import React, { Component } from 'react';
import { connect } from 'react-redux';

import NavItem from './NavItem';

class Nav extends Component {
  renderGroupsTab() {
    const { activeTab, root } = this.props;

    if (this.isNationalOrgnizer() && root)
      return <NavItem title='Groups' path='/groups' active={activeTab === 'groups'} />
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
            path='/members'
            active={activeTab === 'members'}
          />

          <NavItem
            title={`${this.isNationalOrgnizer() && root ? 'All' : ''} Events`}
            path='/events'
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
