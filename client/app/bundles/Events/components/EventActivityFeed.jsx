import React, { Component } from 'react';

import { formatDateTime } from '../utils';

class EventActivityFeed extends Component {
  render() {
    const { events, type } = this.props;
    return (
      <div>
        {events.map(event => {
          return (<div key={event.id}>
            <div>{`Change type: ${type}`}</div>
            <div>{`Date: ${formatDateTime(event.updated_at)}`}</div>
            <div>{`Name: ${event.title}`}</div>
            <div>{`Group: ${event.group.name}`}</div>
          </div>);
        })}
      </div>
    );
  }
}

export default EventActivityFeed;
