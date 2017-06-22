import React, { Component } from 'react';
import _ from 'lodash';

import { formatDateTime } from '../utils';

class AttendanceActivityFeed extends Component {
  showAttendedInfo(attendances) {
    let [attended, missed, unknown] = [0,0,0];

    attendances.forEach(attendance => {
      switch (attendance.attended) {
      case true:
        attended += 1;
        break;
      case false:
        missed += 1;
        break;
      default:
        unknown += 1;
      }
    });

    return(
      <div>
        { !!attended && <div>{`Attended: ${attended}`}</div>}
        { !!unknown && <div>{`Unknown: ${unknown}`}</div>}
        { !!missed && <div>{`Missed: ${missed}`}</div>}
      </div>
    )
  }

  showAttendances() {
    const groupedAttendances = this.props.attendances;
    const events = Object.keys(groupedAttendances)

    return (events.map(event => {
      const [eventName, eventId] = event.split('-');
      return(
        <div key={eventId}>
          <div>{`Event: ${eventName}`}</div>
          {this.showAttendedInfo(groupedAttendances[event])}
          <br />
        </div>
      )
    }))
  }

  render() {
    return (
      <div>
        {this.showAttendances()}
      </div>
    );
  }
}

export default AttendanceActivityFeed;
