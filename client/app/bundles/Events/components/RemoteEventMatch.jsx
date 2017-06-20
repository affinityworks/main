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

    this.state = { selectedEvent: '' };
    this.setActiveEvent = this.setActiveEvent.bind(this);
    this.createRemoteEvent = this.createRemoteEvent.bind(this);
  }

  createRemoteEvent() {
    const { remoteEvent } = this.props;
    const { selectedEvent } = this.state;

    if (!selectedEvent) {
      window.flash_messages.addMessage({ id: remoteEvent.id, text: 'Please select an event.', type: 'alert' });
      return;
    }

    axios.post(`${eventsPath()}/imports.json`, { remote_event: remoteEvent, event_id: selectedEvent })
      .then((response) => {
        history.push(`${eventsPath()}/imports/${response.data.id}/attendances`);
      }).catch((err) => {
        window.flash_messages.addMessage({ id: selectedEvent, text: 'An error ocurred. Try again later.', type: 'error' });
      });
  }

  setActiveEvent(event_id) {
    this.setState({selectedEvent: event_id})
  }

  render() {
    const { remoteEvent, events } = this.props;

    if (!remoteEvent)
      return <div><h2>We could not find an Event for the given url.</h2></div>
    else if (!remoteEvent.name)
      return null;

    return (
      <div className='row'>
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
              onClick={this.createRemoteEvent}
               style={{ cursor: 'pointer'}}>
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
