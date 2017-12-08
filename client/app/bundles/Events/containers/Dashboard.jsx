import React, { Component } from 'react';
import Breadcrumbs from '../components/Breadcrumbs';
import { connect } from 'react-redux';

import Nav from '../components/Nav';
import EventActivityFeed from '../components/EventActivityFeed';
import AttendanceActivityFeed from '../components/AttendanceActivityFeed';
import TextEditor from '../components/TextEditor';
import PersonActivityFeed from '../components/PersonActivityFeed';
import SyncActivityFeed from '../components/SyncActivityFeed';
import { fetchGroup, addAlert } from '../actions';
import { client, dashboardPath } from '../utils';

class Dashboard extends Component {
  state = { events: { updated: [], created: [] }, attendances: [],
    people: { updated: [], created: [] }, sync: {}
  }

  componentWillMount() {
    const { groupId } = this.props.match.params;

    this.props.fetchGroup(groupId);

    client.get(`${dashboardPath()}.json`).then(response => {
      this.setState({ ...response.data })
    }).catch(alert => {
      this.props.addAlert(alert);
    });
  }

  showAttendancesActivity() {
    const { attendances } = this.state;

    if (!attendances.length)
      return null

    return (
      <div>
        <br />
        <h3>New Recorded Attendances</h3>
        <AttendanceActivityFeed attendances={attendances} />
      </div>
    )
  }

  hasActivity() {
    const { people, events, attendances, sync } = this.state;
    return !! people.updated.length
      || !! people.created.length
      || !! events.created.length
      || !! events.updated.length
      || !! attendances.length
      || !! (sync && sync.data)
  }

  renderTextEditor () {
    const { attributes } = this.props.group;
    
    return (
      <section>
        <TextEditor
          hideTextEdit={this.hideTextEdit}
          textDescription={attributes.description}
          addAlert={this.props.addAlert}
        />
      </section>
    )
  }

  render() {
    const { attributes } = this.props.group;
    const { events, attendances, people, sync, editText } = this.state;

    if(!attributes) { return null }

    return (
      <div>
        <Breadcrumbs active='Dashboard' location={this.props.location} />

        <br />

        <Nav activeTab='dashboard' />

        <br />

        {this.renderTextEditor()}

        <hr/>
        {this.hasActivity() && <h2>Activity Feed</h2> || <h4> There's no recent activity for this group.</h4>}
        {this.hasActivity() && <hr />}

        { !!sync && !!sync.data && <SyncActivityFeed sync={sync} />}

        <div className="edit-button">
          <a href="edit">
            <button className='btn btn-primary'>Edit Group</button>
          </a>
          <br />
        </div>

        {(!!events.updated.length || !!events.created.length) && <h3>Events</h3>}
        <div className='list-group'>
          <EventActivityFeed events={events.updated} type='Updated'/>
          <EventActivityFeed events={events.created} type='Created'/>
        </div>

        {this.showAttendancesActivity()}

        <br />
        {(!!people.updated.length || !!people.created.length) && <h3>People</h3>}
        <div className='list-group'>
          <PersonActivityFeed people={people.updated} type='Updated'/>
          <PersonActivityFeed people={people.created} type='Created'/>
        </div>
      </div>
    );
  }
}

const mapStateToProps = ({ group }) => {
  return { group }
};

export default connect(mapStateToProps, { fetchGroup, addAlert })(Dashboard);
