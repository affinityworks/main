import React, { Component } from 'react';
import { connect} from 'react-redux';
import { Link } from 'react-router-dom';

import AttendanceForm from './AttendanceForm';
import Event from '../components/Event';
import { fetchEvent, createAttendance } from '../actions';

class NewAttendance extends Component {
  componentWillMount() {
    this.props.fetchEvent(this.props.match.params.id);
  }

  handleSubmit(e) {
    e.preventDefault();

    const { newAttendance, createAttendance, match } = this.props;

    const attributes = { //NOTE: ROAR MAKES THIS OVER COMPLICATED
      family_name: newAttendance['family-name'],
      given_name: newAttendance['given-name'],
      primary_email_address: newAttendance['primary-email-address'],
      primary_phone_number: newAttendance['primary-phone-number'],
      primary_personal_address: {
        address_lines: [newAttendance.address_lines],
        postal_code: newAttendance.postal_code,
        locality: newAttendance.locality
      }
    }

    createAttendance(match.params.id, attributes);
  }

  renderEvent() {
    if (this.props.event.attributes)
      return <Event event={this.props.event} />
  }

  render() {
    const eventId = this.props.match.params.id;
    return (
      <div>
        {this.renderEvent()}

        <br/>
        <br/>

        <h3> Add New Event Attendee </h3>

        <br/>

        <AttendanceForm onSubmit={this.handleSubmit.bind(this)}>
          <div className='row'>
            <div className='col-1'>
              <Link to={`/events/${eventId}/attendances`} className='btn btn-primary'>
                Back
              </Link>
            </div>
            <div className='col-1'/>
            <div className='col-2'>
              <button type='submit' className='btn btn-success'>
                Done
              </button>
            </div>
          </div>
        </AttendanceForm>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { event, newAttendance } = state;
  return { event, newAttendance }
}

export default connect(mapStateToProps, { fetchEvent, createAttendance })(NewAttendance);
