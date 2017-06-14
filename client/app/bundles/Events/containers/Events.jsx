import React, { Component } from 'react';
import Nav from '../components/Nav';
import { connect } from 'react-redux';

import history from '../history';
import GroupEvents from '../components/Events';
import Breadcrumbs from '../components/Breadcrumbs';
import { managingCurrentGroupWithAffiliates } from '../utils/Permissions'

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
    const { currentGroup, location } = this.props;
    const activeText = managingCurrentGroupWithAffiliates(currentGroup) 
      ? 'All Events'
      : 'Events';

    return (
      <div>
        <Breadcrumbs active={activeText} location={location} />

        <br />

        <Nav activeTab='events'/>

        <GroupEvents location={this.props.location} history={this.props.history}
          showGroupName={this.showGroupName()} showPrintIcon={this.showPrintIcon()}
        />
      </div>
    );
  }
}

const mapStateToProps = ({ currentGroup }) => {
  return { currentGroup }
};

export default connect(mapStateToProps)(Events);
