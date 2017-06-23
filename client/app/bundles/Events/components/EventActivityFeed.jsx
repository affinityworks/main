import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import { formatDay, formatTime, eventsPath } from '../utils';

class EventActivityFeed extends Component {
  renderEvent(event) {
    const { type } = this.props;

    return (
      <div href="#" key={event.id} className="list-group-item list-group-item-action flex-column align-items-start">
        <div className="d-flex w-100 justify-content-between">
          <Link to={`${eventsPath()}/${event.id}`}><h5 className="mb-1">{event.title}</h5></Link>
          <small>{formatDay(event.updated_at)} {formatTime(event.updated_at)}</small>
        </div>
        <p className="mb-1">{event.group.name}</p>
        <i style={{ color: '#5cb85c' }}>{type}</i>
      </div>
    )
  }

  render() {
    const { events } = this.props;
    return (
      <div style={{marginBottom: '-1px' }}>
        {events.map(this.renderEvent.bind(this))}
      </div>
    );
  }
}

export default EventActivityFeed;
