import React, { Component } from 'react';
import Breadcrumbs from '../components/Breadcrumbs';
import { connect } from 'react-redux';

import Nav from '../components/Nav';
import EventActivityFeed from '../components/EventActivityFeed';
import AttendanceActivityFeed from '../components/AttendanceActivityFeed';
import TextEditor from '../components/TextEditor';
import PersonActivityFeed from '../components/PersonActivityFeed';
import SyncActivityFeed from '../components/SyncActivityFeed';
import { fetchGroup, fetchFeatureToggles, addAlert } from '../actions';
import UserAuth from '../components/UserAuth';
import GroupResources from '../components/GroupResources';
import { client, dashboardPath } from '../utils';

class Dashboard extends Component {
  state = { events: { updated: [], created: [] }, attendances: [],
    people: { updated: [], created: [] }, sync: {}
  }

  componentWillMount() {
    const { groupId } = this.props.match.params;
    this.props.fetchGroup(groupId);
    this.props.fetchFeatureToggles('events', groupId)
  }

  renderTextEditor () {
    const { attributes } = this.props.group;

    return (
      <section>
        <TextEditor
          textDescription={attributes.whiteboard}
          addAlert={this.props.addAlert}
        />
      </section>
    )
  }

  render() {
    const { group: { attributes }, featureToggles } = this.props;
    const { events, attendances, people, sync, editText } = this.state;

    if(!attributes) { return null }

    return (
      <div>

        <Breadcrumbs active='Dashboard' location={this.props.location} />
        <br />

        <Nav activeTab='dashboard' eventsOn={featureToggles.events} />
        <br />

        {this.renderTextEditor()}
        <hr/>
        <GroupResources {...{
          resources: [{
            description: 'Recruit new members', link: attributes['signup-url'],
          },{
            description: 'Google Group', link: attributes['google-group-url'],
          },{
            description: 'Google Group Email', mailto: attributes['google-group-email']
          }]
        }}/>
        <hr/>

        <div className="edit-button">
          <UserAuth allowed={['organizer']}>
            <a href="edit">
              <button className='btn btn-primary'>Edit Group</button>
            </a>
          </UserAuth>
          <br />
        </div>
      </div>
    );
  }
}

const mapStateToProps = ({ group, featureToggles }) => {
  return { group, featureToggles }
};

export default connect(
  mapStateToProps,
  {
    fetchGroup,
    fetchFeatureToggles,
    addAlert
  }
)(Dashboard);
