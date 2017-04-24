import axios from 'axios';
import React, { PropTypes } from 'react';
import Event from './Event';

export default class Events extends React.Component {
  constructor(props, _railsContext) {
    super(props);

    // How to set initial state in ES6 class syntax
    // https://facebook.github.io/react/docs/reusable-components.html#es6-classes
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
          {this.state.events.map(event => <Event key={event.id} {...event.attributes} /> )}
        </tbody>
      </table>
    );
  }
}
