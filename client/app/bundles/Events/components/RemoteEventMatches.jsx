import React, { Component } from 'react';
import { formatDay, formatTime} from '../utils';

class RemoteEventMatches extends Component {
  constructor(props) {
    super(props);

    this.renderEvent = this.renderEvent.bind(this);
  }

  renderEvent(event) {
    const { attributes } = event;
    return (
      <div
        className={`list-group-item list-group-item-action ${this.props.selected === event.id ? 'active' : ''}`}
        key={event.id}
        onClick={ev => this.props.onClick(event.id)}
        style={{cursor: 'pointer'}} >

        <span className='text-primary'>{attributes.title}</span>
        <span>{this.startEndTime(attributes)}</span>
        {this.eventLocation(attributes)}
      </div>
    )
  }

  eventLocation(event) {
    if (event.location)
      return <span>&nbsp; at {event.location.venue}</span>
  }

  startEndTime(event) {
    if (event['end-date'])
      return (
        <span>&nbsp;{`${formatTime(event['start-date'])} - ${formatTime(event['end-date'])}`}</span>
      )
    else
      return (<span>&nbsp;{formatTime(event['start-date'])}</span>)
  }

  render() {
    const { date, events } = this.props;
    if (events.data.length < 1) { return <div>No Events were found.</div> }

    return (
      <div>
        <div className='row'>
          <h5>{`Events on ${formatDay(date)}`}</h5>
          <small>Click the matching event on the list below.</small>
        </div>
        <br />
        <div className='row'>
          <div className='list-group'>
            {events.data.map(this.renderEvent)}
          </div>
        </div>
      </div>
    );
  }
}

export default RemoteEventMatches;
