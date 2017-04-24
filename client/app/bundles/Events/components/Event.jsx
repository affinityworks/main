import moment from 'moment';
import React, { PropTypes } from 'react';

var Link = require('react-router-dom').Link;

export default class Event extends React.Component {
  constructor(props, _railsContext) {
    super(props);
    this.state = {...props};
  }

  organizerName() {
    if (this.state.organizer) {
      return this.state.organizer.name;
    }
  }

  render() {
    return (
    <tr>
      <td><a href="" data-toggle="modal" data-target="#event_add-modal">{this.state.title}</a></td>
      <td>{this.organizerName()}</td>
      <td>{moment(this.state['start-date']).format('M/D/Y H:mm')}</td>
      <td>{this.state.status}</td>
      <td>{this.state['invited-count']}</td>
      <td>{this.state['rsvp-count']}</td>
      <td>{this.state['attended-count']}</td>
      <td>
        <Link className='event_list-toggle' to={`/events/${this.id}`}>See Attendees</Link>
      </td>
    </tr>
    );
  }
}
