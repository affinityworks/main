import moment from 'moment';
import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import { formatDate, eventsPath, attendancesPath, membersPath } from '../utils';

export default class AttendanceEvent extends Component {
  locationName() {
    const { location } = this.props.event.attributes;

    if (location)
      return `${location.venue}`;
  }

  renderOrganizer() {
    const { organizer } = this.props.event.attributes;

    if (organizer) {
      const primaryEmailAddress = organizer.data.attributes['primary-email-address'];
      const { name } = organizer.data.attributes;

      return <Link to={`${membersPath()}/${organizer.data['id']}`}>{name}</Link>
    }
  }

  render() {
    const { attributes, id, rsvpCount } = this.props.event;

    return (
      <div className='list-group-item'>
        <div className='col-2  text-center'>
          {formatDate(attributes['start-date'])}
        </div>

        <div className='col-7'>
          <Link to={`${eventsPath()}/${id}`}> {attributes.name || attributes.title} </Link>
          <br />
          <span> {`${this.locationName() || 'Location Unknown' }`} </span>
          {this.renderOrganizer()}
        </div>

        <div className='col-2 text-center'>
          <Link className='event_list-toggle' to={attendancesPath(id)}>
            <button className='btn btn-primary'>
              {`${rsvpCount || attributes['rsvp-count']} RSVPs`}
            </button>
          </Link>
        </div>
        <div className='col-1 text-center'>
          <a href={`${attendancesPath(id)}.pdf`} target="_blank">
            <i className='fa fa-print fa-2x'>
            </i>
          </a>
        </div>
      </div>
    );
  }
}
