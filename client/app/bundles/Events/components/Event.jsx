import moment from 'moment';
import React, { Component } from 'react';

import { Link } from 'react-router-dom';

export default class Event extends Component {
  organizerName() {
    const attributes = this.props.event.attributes;

    if (attributes.organizer) {
      return attributes.organizer.name;
    }
  }

  render() {
    const { attributes, id } = this.props.event;

    return (
      <tr>
        <td>
          <a data-toggle="modal" data-target="#event_add-modal">{attributes.title}</a>
        </td>
        <td>{this.organizerName()}</td>
        <td>{moment(attributes['start-date']).format('M/D/Y H:mm')}</td>
        <td>{attributes.status}</td>
        <td>{attributes['invited-count']}</td>
        <td>{attributes['rsvp-count']}</td>
        <td>{attributes['attended-count']}</td>
        <td>
          <Link className='event_list-toggle' to={`/${id}`}>See Attendees</Link>
        </td>
      </tr>
    );
  }
}
