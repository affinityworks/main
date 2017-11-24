import moment from 'moment';
import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import Tags from './Tags';
import {
  formatDate, formatTime, eventsPath, attendancesPath, membersPath
} from '../utils';

export default class Event extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.showDate = this.date.bind(this);
    this.locationName = this.locationName.bind(this);
    this.groupColumn = this.groupColumn.bind(this);
    this.printColumn = this.printColumn.bind(this);
    this.rsvps = this.rsvps.bind(this);
  }

  locationName() {
    const { location } = this.props.event.attributes;

    if (location)
      return `${location.venue}`;
    else
      return 'Location Unknown'
  }

  date() {
    const event = this.props.event.attributes;

    if (!event['start-date']) { return null }

    const date = formatDate(event['start-date']);
    let time = formatTime(event['start-date'])
    if (event['end-date'])
      time = `${time}-${formatTime(event['end-date'])}`

    return `${date} ${time}`
  }

  groupColumn() {
    const group = this.props.event.attributes.group;
    if (group && this.props.showGroupName){
      const { attributes } = group.data;
      return <td>{attributes.name}</td>
    }
  }

  printColumn() {
    const { id } = this.props.event;

    if (this.props.showPrintIcon)
      return (
        <td>
          <a href={`${attendancesPath(id)}.pdf`} target="_blank">
            <i className='fa fa-print fa-2x'>
            </i>
          </a>
        </td>
      )
  }

  rsvps() {
    const { attributes, id, rsvpCount } = this.props.event;
    return (
      <Link className='event_list-toggle btn btn-primary' to={attendancesPath(id)}>
        {`${rsvpCount || attributes['rsvp-count']} RSVPs`}
      </Link>
    )
  }

  showTags() {
    const { tags } = this.props.event.attributes;
    const { id } = this.props.event;

    if (tags)
      return <Tags tags={tags} eventId={id} tagList={this.props.tagsEventList}/>
  }

  render() {
    const { attributes, id } = this.props.event;

    return (
      <tr>
        <td>
          <Link to={`${eventsPath()}/${id}`}> {attributes.name || attributes.title} </Link>
        </td>
        <td>{this.date()}</td>
        <td>{this.locationName()}</td>
        {this.groupColumn()}
        <td>{this.showTags()}</td>
        <td>{this.rsvps()}</td>
        {this.printColumn()}
      </tr>
    );
  }
}
