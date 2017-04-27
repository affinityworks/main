import axios from 'axios';

import React, { PropTypes, Component } from 'react';

import Event from './Event';
import EventsFilter from './EventsFilter';

export default class Events extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.state = {events: []};
    this.filterEvents = this.filterEvents.bind(this);
  }


  componentDidMount() {
    this.getEvents(null);
  }

  filterEvents(searchTerm) {
    this.getEvents(searchTerm);
  }

  getEvents(filter) {
    const uri = filter ? `events.json?filter=${filter}` : `events.json`;
    axios.get(uri)
      .then(res => {
        const events = res.data.data;
        this.setState({ events });
      });
  }

  render() {
    return (
      <div>
        <EventsFilter onSearchSubmit={this.filterEvents}/>
        <br />
        <div className='list-group'>
          {this.state.events.map(event => <Event key={event.id} event={event} />)}
        </div>
      </div>
    );
  }
}
