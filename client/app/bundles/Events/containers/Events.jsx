import React, { Component } from 'react';
import Nav from '../components/Nav';
import { connect } from 'react-redux';

import history from '../history';
import GroupEvents from '../components/Events';

class Events extends Component {
  render() {
    const { currentGroup } = this.props;

    return (
      <div>
        {/* NOTE Breadcrumbs */}

        <h2>{`${currentGroup.name} Events`}</h2>
        <br />
        <Nav activeTab='events'/>

        <GroupEvents location={this.props.location} history={this.props.history}
          showGroupName={true} showPrintIcon={false}
        />
      </div>
    );
  }
}

const mapStateToProps = ({ currentGroup }) => {
  return { currentGroup }
};

export default connect(mapStateToProps)(Events);
