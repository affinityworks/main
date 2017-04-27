import React, { Component, PropTypes } from 'react';
import axios from 'axios';

class Attendance extends Component {
  static contextTypes = {
    router: PropTypes.object
  };

  componentWillMount() {
    this.state = { attended: this.props.attendance.attributes.attended };
  }

  updateAttended(attended) {
    const id = this.props.attendance.id;
    const eventId = this.props.eventId;

    axios.put(`/events/${eventId}/attendances/${id}`, { attended })
      .then(() => this.setState({ attended }))
  }

  render() {
    console.log(this.props);
    const attendee = this.props.attendance.attributes.person.data.attributes;

    return (
      <div className='list-group-item'>
        <div className='col-8'>
          <div className='row'>
            {`${attendee['given-name']} ${attendee['family-name']}`}
          </div>

          <div> {this.state.attended} </div>

          <div className='row'>
            <small>{`${attendee['primary-email-address']}`}</small>
          </div>
        </div>

        <div className='col-4'>
          <div className='btn-group' role='group'>
            <button
              type='button'
              className={`btn ${this.state.attended === true ? 'btn-success' : 'btn-secondary'}`}
              onClick={() => this.updateAttended(true)}>
              Y
            </button>

            <button
              type='button'
              className={`btn ${this.state.attended === undefined ? 'btn-warning' : 'btn-secondary'}`}
              onClick={() => this.updateAttended(undefined)}>
              ?
            </button>

            <button
              type='button'
              className={`btn ${this.state.attended === false ? 'btn-danger' : 'btn-secondary'}`}
              onClick={() => this.updateAttended(false)}>
              N
            </button>
          </div>
        </div>
      </div>
    );
  }
}

export default Attendance;
