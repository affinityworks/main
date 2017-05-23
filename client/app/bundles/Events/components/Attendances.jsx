import React, { Component, PropTypes } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import Event from './Event';
import Attendance from './Attendance';
import Pagination from './Pagination';
import { fetchEvent, fetchAttendances } from '../actions';

class Attendances extends Component {
  componentWillMount() {
    const eventId = this.props.match.params.id;

    this.props.fetchEvent(eventId);
    this.props.fetchAttendances(eventId, this.props.location.search);
  }

  componentWillReceiveProps(nextProps) {
    const eventId = this.props.match.params.id;
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchAttendances(eventId, nextProps.location.search);
  }

  renderPagination() {
    const { total_pages, page, location } = this.props;
    if (total_pages) {
      return <Pagination
        page={page}
        totalPages={total_pages}
        currentSearch={location.search} />
    }
  }

  renderEvent() {
    if (this.props.event.attributes)
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
    const eventId = this.props.match.params.id;

    return (
      <div>
        {this.renderEvent()}
        <div className='container'>
          <div className='list-group'>
            {this.renderAttendances()}
          </div>

          <br />

          <div className='row text-right'>
            <div className='col-md-8' />
            <div className='col-md-2'>
              <Link to={`/events/${eventId}/attendances/new`} className='btn btn-primary'>
                Add New Attendee
              </Link>
            </div>

            <div className='col-md-2'>
              <Link to='/events' className='btn btn-success'> Done </Link>
            </div>
          </div>

          <br />
          {this.renderPagination()}
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const event = state.event;
  const { attendances, total_pages, page } = state.attendances;
  return { event, attendances, page, total_pages }
};

export default connect(mapStateToProps, { fetchEvent, fetchAttendances })(Attendances);
