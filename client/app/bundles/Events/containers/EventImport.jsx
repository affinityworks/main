import axios from 'axios';
import React, { Component } from 'react';

import Nav from '../components/Nav';
import RemoteEventSearch from '../components/RemoteEventSearch';
import RemoteEventMatch from '../components/RemoteEventMatch';
import { eventsPath } from '../utils';

class EventImport extends Component {
  constructor(props) {
    super(props);

    this.state = { remoteEvent: {}, events: [] }

    this.searchEvent = this.searchEvent.bind(this);
  }

  searchEvent(eventUrl) {
    axios.get(`${eventsPath()}/imports/find.json?remote_event_url=${eventUrl}`).then(response => {
      const { events } = response.data;
      const remoteEvent = response.data.remote_event;
      this.setState({ remoteEvent, events })
    })
  }

  render() {
    return (
      <div>
        <Nav activeTab='events'/>
        <div className='row'>
          <div className='col-5'>
            <h3>Facebook Event Import</h3>
          </div>
        </div>
        <br />
        <div className='row'>
          <RemoteEventSearch onSearchSubmit={this.searchEvent} />
        </div>
        <br />
        <RemoteEventMatch remoteEvent={this.state.remoteEvent} events={this.state.events} />
      </div>
    );
  }
}

export default EventImport;
