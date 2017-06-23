import React, { Component } from 'react';
import _ from 'lodash';

import { formatDay, formatTime } from '../utils';

class AttendanceActivityFeed extends Component {
  showAttendedInfo({ attended, missed, unknown }) {
    return(
      <div>
        { !!attended && <div className='badge badge-primary attendance-badge'>{`${attended} Attended`}</div>}
        { !!unknown && <div className='badge badge-primary attendance-badge'>{`${unknown} Unknown`}</div>}
        { !!missed && <div className='badge badge-primary attendance-badge'>{`${missed} Missed`}</div>}
      </div>
    )
  }

  showAttendances() {
    const eventAttendances = this.props.attendances;

    return (eventAttendances.map(attendances => {
      const { event_id, event_title, group_name, whodunnit, updated_at } = attendances;
      return(
        <div className='list-group-item' key={event_id} style={{ flexDirection: 'column', alignItems: 'start' }}>
          <div className="d-flex w-100 justify-content-between">
            <h5 className="mb-1">{event_title}</h5>
            <small>{formatDay(updated_at)} {formatTime(updated_at)}</small>
          </div>
          <div>{`${group_name}`}</div>
          { whodunnit && <small> by {whodunnit} </small>}
          {this.showAttendedInfo(attendances)}
        </div>
      )
    }))
  }

  render() {
    return (
      <div className="list-group">
        {this.showAttendances()}
      </div>
    );
  }
}

export default AttendanceActivityFeed;
