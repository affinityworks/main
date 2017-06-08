import React, { Component } from 'react';
import Nav from '../components/Nav';
import { connect } from 'react-redux';

import history from '../history';
import GroupEvents from '../components/Events';
import Breadcrumbs from '../components/Breadcrumbs';
import { isNationalOrgnizer, managingCurrentGroup } from '../utils/Permissions'

class Events extends Component {
  showGroupName() {
    const { currentGroup, currentRole } = this.props;
    return (isNationalOrgnizer(currentRole) && managingCurrentGroup(currentGroup))
  }

  showPrintIcon() {
    const { currentGroup, currentRole } = this.props;
    return (!isNationalOrgnizer(currentRole) || !managingCurrentGroup(currentGroup))
  }

  render() {
    const { currentGroup } = this.props;

    return (
      <div>
        <Breadcrumbs active='All Events' />

        <br />

        <Nav activeTab='events'/>

        <GroupEvents location={this.props.location} history={this.props.history}
          showGroupName={this.showGroupName()} showPrintIcon={this.showPrintIcon()}
        />
      </div>
    );
  }
}

const mapStateToProps = ({ currentGroup, currentRole }) => {
  return { currentGroup, currentRole }
};

export default connect(mapStateToProps)(Events);
