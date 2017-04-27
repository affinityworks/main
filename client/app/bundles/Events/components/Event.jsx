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
      <div className='list-group-item'>
        <div className='col-8'>
          <a href='' data-toggle="modal" data-target="#event_add-modal">{attributes.title}</a>
          <span> {` at ${attributes.location || 'Event Location'}`} </span>
          <span> {` hosted by ${this.organizerName() || 'Event Organizer'}`} </span>
        </div>

        <div className='col-2'>
          {`${attributes['rsvp-count']} RSVPs`}
        </div>

        <div className='col-2'>
          <Link className='event_list-toggle' to={`/${id}/attendances`}>
            <button className='btn btn-primary'>
              RSVPs
            </button>
          </Link>
        </div>
      </div>
    );
  }
}
