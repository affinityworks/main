import React, { Component } from 'react';
import Nav from './Nav';
import RemoteEventSearch from './RemoteEventSearch';
import RemoteEventMatch from './RemoteEventMatch';
import axios from 'axios';
import { addAlert } from '../actions';
import { connect } from 'react-redux';

import { eventsPath } from '../utils/Pathnames';

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
    .catch(err => {
      let text = 'An error ocurred while retrieving the Facebook Event.';
      let type = 'error';
      this.props.addAlert({ text, type });
    });
  }

  render() {
    const { remoteEvent, events } = this.state;
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
        <RemoteEventMatch remoteEvent={remoteEvent} events={events} />
      </div>
    );
  }
}

export default connect(null, { addAlert })(EventImport);
