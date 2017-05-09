import React, { Component, PropTypes } from 'react';
import axios from 'axios';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import { fetchEvent } from '../actions';
import Event from './Event';
import Attendance from './Attendance';

class Attendances extends Component {
  constructor(props) {
    super(props);

    this.state = { attendances: [] };
  }

  componentWillMount() {
    const eventId = this.props.match.params.id;

    this.props.fetchEvent(eventId);

    axios.get(`/events/${eventId}/attendances.json`)
      .then(res => {
        const attendances = res.data.data;
        this.setState({ attendances });
      });
  }

  renderEvent() {
    if (this.props.event)
      return <Event event={this.props.event} />;
  }

  renderAttendances() {
    if (this.state.attendances)
      return this.state.attendances.map(attendance => (
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
  const { event } = state;
  return { event }
};

export default connect(mapStateToProps, { fetchEvent })(Attendances);
