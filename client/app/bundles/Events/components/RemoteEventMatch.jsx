import React, { Component } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';

import RemoteEventMatches from './RemoteEventMatches';
import RemoteEvent from './RemoteEvent';
import history from '../history';
import { eventsPath } from '../utils/Pathnames';

class RemoteEventMatch extends Component {
  constructor(props) {
    super(props);

    this.state = { selectedEvent: '', errorAlert: '' };
    this.setActiveEvent = this.setActiveEvent.bind(this);
    this.createRemoteEvent = this.createRemoteEvent.bind(this);
  }

  createRemoteEvent() {
    const { remoteEvent } = this.props;
    const { selectedEvent } = this.state;

    if (!selectedEvent) {
      this.setState({ errorAlert: 'Please select an event.' });
      return;
    }

    axios.post(`${eventsPath()}/imports.json`, { remote_event: remoteEvent, event_id: selectedEvent })
      .then((response) => {
        history.push(`${eventsPath()}/imports/${response.data.id}/attendances`);
      }).catch((err) => {
        this.setState({ errorAlert: 'An error ocurred. Try again later.' })
      });
  }

  setActiveEvent(event_id) {
    this.setState({selectedEvent: event_id})
  }

  renderAlert() {
    const { errorAlert } = this.state;

    if (errorAlert.length)
      return (
        <div className='container'>
          <div className="col-12 alert alert-danger">{errorAlert}</div>
        </div>
      )
    else
      return null;
  }

  render() {
    const { remoteEvent, events } = this.props;

    if (!remoteEvent)
      return <div><h2>We could not find an Event for the given url.</h2></div>
    else if (!remoteEvent.name)
      return null;

    return (
      <div className='row'>
        {this.renderAlert()}
        <div className='col-4'>
          <RemoteEvent event={remoteEvent} />
        </div>
        <div className='col-4'>
          <RemoteEventMatches date={remoteEvent.start_time}
            events={events}
            selected={this.state.selectedEvent}
            onClick={this.setActiveEvent}
          />
          <br/>
          <div>
            <a href='#'>Search other Affinity Events.</a>
          </div>
        </div>
        <div className='col-3 offset-1'>
          <div className='row'>
            <div className='btn btn-success'
              onClick={this.createRemoteEvent}>
              Sync RSVP's
            </div>
          </div>
          <br />
          <div className='row'>
            <Link className='btn btn-primary' to={`/events`}>
              Back to Events
            </Link>
          </div>
        </div>
      </div>
    );
  }
}

export default RemoteEventMatch;
