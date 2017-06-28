import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import _ from 'lodash';

import { formatDay, formatTime, eventPath } from '../utils';

class AttendanceActivityFeed extends Component {
  showAttendedInfo({ attended, missed, unknown }) {
    return(
      <div>
        { !!attended && <div className='badge badge-success attendance-badge'>{`${attended} Attended`}</div>}
        { !!unknown && <div className='badge badge-warning attendance-badge'>{`${unknown} RSPVs`}</div>}
        { !!missed && <div className='badge badge-danger attendance-badge'>{`${missed} Missed`}</div>}
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
            <Link to={`${eventPath(event_id)}`}>
              <h5 className="mb-1">{event_title}</h5>
            </Link>
            <small>{formatDay(updated_at)} {formatTime(updated_at)}</small>
          </div>
          <p>{`${group_name}`}</p>
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
