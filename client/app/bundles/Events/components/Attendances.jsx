import React, { Component, PropTypes } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import Event from './Event';
import Attendance from './Attendance';
import { fetchEvent, fetchAttendances } from '../actions';

class Attendances extends Component {
  componentWillMount() {
    const eventId = this.props.match.params.id;

    this.props.fetchEvent(eventId);
    this.props.fetchAttendances(eventId);
  }

  renderEvent() {
    if (this.props.event)
      return <Event event={this.props.event} />;
  }

  renderAttendances() {
    return this.props.attendances.map(attendance => (
      <Attendance key={attendance.id}
        eventId={this.props.match.params.id}
        attendance={attendance} />
    ));
  }

  render() {
    const { goBack } = this.props.history;

    return (
      <div>
        {this.renderEvent()}
        <div className='container'>
          <div className='list-group'>
            {this.renderAttendances()}
          </div>

          <br />

          <div className='text-right'>
            <button onClick={goBack} className='btn btn-success'> Done </button>
          </div>
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { event, attendances } = state;
  return { event, attendances }
};

export default connect(mapStateToProps, { fetchEvent, fetchAttendances })(Attendances);
