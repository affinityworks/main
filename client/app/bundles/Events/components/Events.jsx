import axios from 'axios';
import React, { PropTypes, Component } from 'react';

import Event from './Event';
import EventsFilter from './EventsFilter';

export default class Events extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.state = {events: []};
  }

  componentDidMount () {
    axios.get(`/events.json`)
      .then(res => {
        const events = res.data.data;
        this.setState({ events });
      });
  }

  render() {
    return (
      <div>
        <EventsFilter />
        <br />
        <div className='list-group'>
          {this.state.events.map(event => <Event key={event.id} event={event} />)}
        </div>
      </div>
    );
  }
}
