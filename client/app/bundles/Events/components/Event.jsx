import moment from 'moment';
import React, { Component } from 'react';

import { Link } from 'react-router-dom';
import { formatDate } from '../utils';

export default class Event extends Component {
  organizerName() {
    const attributes = this.props.event.attributes;

    if (attributes.organizer)
      return attributes.organizer.name;
  }

  locationName() {
    const location = this.props.event.attributes.location;

    if (location)
      return `${location.venue}`;
  }

  render() {
    const { attributes, id } = this.props.event;

    return (
      <div className='list-group-item'>
        <div className='col-2  text-center'>
          {formatDate(attributes['start-date'])}
        </div>

        <div className='col-7'>
          <Link to={`/events/${id}`}> {attributes.name || attributes.title} </Link>
          <span> {` at ${this.locationName() || 'Event Location' }`} </span>
          <span> {` hosted by ${this.organizerName() || 'Event Organizer'}`} </span>
        </div>

        <div className='col-2 text-center'>
          <Link className='event_list-toggle' to={`/events/${id}/attendances`}>
            <button className='btn btn-primary'>
              {`${attributes['rsvp-count']} RSVPs`}
            </button>
          </Link>
        </div>
        <div className='col-1 text-center'>
          <a href={`/events/${id}/attendances.pdf`} target="_blank">
            <i className='fa fa-print fa-2x'>
            </i>
          </a>
        </div>
      </div>
    );
  }
}
