import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import AttendanceEvent from './AttendanceEvent';
import Nav from './Nav';
import Attendance from './Attendance';
import Pagination from './Pagination';
import AttendanceForm from '../containers/AttendanceForm';
import { fetchEvent, fetchAttendances } from '../actions';
import { eventsPath, attendancesPath } from '../utils/Pathnames';

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
      return <AttendanceEvent event={this.props.event} />;
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
        <Nav activeTab='events'/>

        {this.renderEvent()}
        <div className='container'>
          <div className='list-group'>
            {this.renderAttendances()}
          </div>

          <br />
          {this.renderPagination()}
          <br />

          <AttendanceForm match={this.props.match} />
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
