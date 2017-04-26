import axios from 'axios';
import React, { PropTypes } from 'react';

import Event from './Event';
import EventsFilter from './EventsFilter';

export default class Events extends React.Component {
  constructor(props, _railsContext) {
    super(props);

    this.state = {events: []};
  }

  componentDidMount () {
    axios.get(`events.json`)
      .then(res => {
        const events = res.data.data;
        this.setState({ events });
      });
  }

  render() {
    return (
      <div>
        <EventsFilter />
        <table className="table table-striped">
          <thead>
            <tr>
              <th>Name</th>
              <th>Organizer</th>
              <th>Date</th>
              <th>Status</th>
              <th>Tentative</th>
              <th>Attending</th>
              <th>Attended</th>
              <th></th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {this.state.events.map(event => <Event key={event.id} event={event} />)}
          </tbody>
        </table>
      </div>
    );
  }
}
