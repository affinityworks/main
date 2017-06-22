import React, { Component } from 'react';
import { connect } from 'react-redux';

import Nav from '../components/Nav';
import AttendanceImportComponent from '../components/AttendanceImport';
import { eventsPath, client } from '../utils';
import { Link } from 'react-router-dom';
import { addAlert } from '../actions';

class AttendanceImport extends Component {
  state = { attendances: [], remote_event: {} };

  componentWillMount() {
    const { id } = this.props.match.params;

    client.get(`${eventsPath()}/imports/${id}/attendances/new.json`)
      .then((response) => {
        this.setState({ ...response.data });
      }).catch(alert => {
        this.props.addAlert(alert);
      });
  }

  renderBlankTemplate() {
    return(
      <div>
        <Nav activeTab='events'/>
        <h2>Import new Facebook RSVP's</h2>
        <br />
        <Link to={eventsPath()} className='btn btn-primary pull-left'>Back To Events</Link>
      </div>
    )
  }

  render() {
    const { remote_event, attendances } = this.state;

    if (!remote_event.name ) { return this.renderBlankTemplate() }

    return (
      <AttendanceImportComponent remote_event={remote_event} attendances={attendances} />
    );
  }
}

export default connect(null, { addAlert })(AttendanceImport);
