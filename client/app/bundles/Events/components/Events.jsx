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
      <div>
        <h3>
          {this.state.events.length} events!
        </h3>
        <hr />
        {this.state.events.map(event => <Event key={event.id} {...event.attributes} /> )}
      </div>
    );
  }
}
