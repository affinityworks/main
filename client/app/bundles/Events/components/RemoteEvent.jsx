import React, { Component } from 'react';
import { formatDay, formatTime} from '../utils';

class RemoteEvent extends Component {
  constructor(props) {
    super(props);
  }

  eventTime() {
    const { event } = this.props;
    const startTime = formatTime(event.start_time);

    if (!startTime) { return null }

    if (event.end_time) {
      const endTime = formatTime(event.end_time);
      return (<div>{`${startTime} - ${endTime}`}</div>)
    } else {
      return (<div>{startTime}</div>)
    }
  }

  eventPlace() {
    const { event } = this.props;
    if (event.place)
      return(<div>{event.place.name}</div>);
    else
      return null;
  }

  render() {
    const { event } = this.props;
    return (
      <div>
        <h5>{event.name}</h5>
        <div>{formatDay(event.start_time)}</div>
        {this.eventTime()}
        {this.eventPlace()}
      </div>
    );
  }
}

export default RemoteEvent;
