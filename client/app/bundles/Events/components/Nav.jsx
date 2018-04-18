import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';

import UserAuth from '../components/UserAuth';
import NavItem from './NavItem';
import {
  membersPath,
  eventsPath,
  affiliatesPath,
  dashboardPath
} from '../utils';

import { managingCurrentGroupWithAffiliates } from '../utils/Permissions'

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
    return managingCurrentGroupWithAffiliates(this.props.currentGroup);
  }

  render() {
    const { activeTab, eventsOn } = this.props;

    return (
      <div>
        <UserAuth allowed={['member']}>
          <div>
            <ul className="nav nav-tabs">
              <NavItem
                title='Members'
                path={membersPath()}
                active={activeTab === 'members'}
              />
              {eventsOn && <NavItem
                title='Events'
                path={eventsPath()}
                active={activeTab === 'events'}
              />}
            </ul>
            <br />
          </div>
        </UserAuth>
        <UserAuth allowed={['organizer', 'volunteer']}>
          <div>
            <ul className="nav nav-tabs">
              <NavItem
                title='Dashboard'
                path={dashboardPath()}
                active={activeTab === 'dashboard'}
              />

              { this.renderGroupsTab() }

              <NavItem
                title="Members"
                path={membersPath()}
                active={activeTab === 'members'}
              />

              {eventsOn && <NavItem
                title={`${this.isRootNav() ? 'All' : ''} Events`}
                path={eventsPath()}
                active={activeTab === 'events'}
              />}
            </ul>
            <br />
          </div>
        </UserAuth>
      </div>
    );
  }
}

const mapStateToProps = ({ currentGroup }) => {
  return { currentGroup }
};

export default connect(mapStateToProps)(Nav);
