import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';

import { updateAttendance } from '../actions';

class Attendance extends Component {
  constructor(props) {
    super(props)

    const { attended } = props.attendance.attributes;
    this.state = { attended }
  }

  updateAttended(attended) {
    const id = this.props.attendance.id;
    const eventId = this.props.eventId;

    this.setState({ attended });
    this.props.updateAttendance({ id, eventId, attended });
  }

  render() {
    const attendee = this.props.attendance.attributes.person.data.attributes;
    const { attended } = this.state;

    return (
      <div className='list-group-item'>
        <div className='col-8'>
          <div className='row'>
            {`${attendee['given-name']} ${attendee['family-name']}`}
          </div>

          <div className='row'>
            <small>{`${attendee['primary-email-address']}`}</small>
          </div>
        </div>

        <div className='col-4'>
          <div className='btn-group' role='group'>
            <button
              type='button'
              className={`btn ${attended === true ? 'btn-success' : 'btn-secondary'}`}
              onClick={() => this.updateAttended(true)}>
              Y
            </button>

            <button
              type='button'
              className={`btn ${attended === undefined ? 'btn-warning' : 'btn-secondary'}`}
              onClick={() => this.updateAttended(undefined)}>
              ?
            </button>

            <button
              type='button'
              className={`btn ${attended === false ? 'btn-danger' : 'btn-secondary'}`}
              onClick={() => this.updateAttended(false)}>
              N
            </button>
          </div>
        </div>
      </div>
    );
  }
}

export default connect(null, { updateAttendance })(Attendance);
