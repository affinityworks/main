import React, { Component, PropTypes } from 'react';
import axios from 'axios';

import Event from './Event';

export default class Attendances extends Component {
  static contextTypes = {
    router: PropTypes.object
  };

  constructor(props) {
    super(props);

    console.log();
    this.state = { event: null, attendances: [] };
  }

  componentDidMount() {
    const eventId = this.props.match.params.id;

    axios.get(`/event/${eventId}.json`)
      .then(res => {
        const event = res.data.data;
        this.setState({ event });
      });

    axios.get(`/event/${eventId}/attendances.json`)
      .then(res => {
        const event = res.data.data;
        this.setState({ event });
      });
  }

  renderEvent() {
    if (this.state.event)
      return <Event event={this.state.event} />;
  }

  render() {
    return (
      <div>
        {this.renderEvent}
        ATTENDANCES
      </div>
    );
  }
}
