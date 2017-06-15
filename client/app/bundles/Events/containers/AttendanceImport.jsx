import React, { Component } from 'react';
import axios from 'axios';

import Nav from '../components/Nav';
import RemoteAttendance from '../components/RemoteAttendance';
import { eventsPath } from '../utils/Pathnames';
import _ from 'lodash';
import { Link } from 'react-router-dom';

class AttendanceImport extends Component {
  state = { attendances: [], remote_event: {}, newAttendances: [],
    errorAlert: '', successAlert: '', noticeAlert: '', loading: true
  };

  componentWillMount() {
    const { id } = this.props.match.params;

    axios.get(`${eventsPath()}/imports/${id}/attendances/new.json`)
      .then((response) => {
        this.setState({ ...response.data, loading: false });
      });
  }

  importAttendances() {
    const { newAttendances, remote_event } = this.state;
    const { event_id } = remote_event;

    if (!newAttendances.length) {
      this.setState({ noticeAlert: 'Please select attendees from the list' })
      return;
    }

    axios.post(`${eventsPath()}/${event_id}/attendances/import_remote.json`, {
      remote_attendances: newAttendances
    })
    .then((response) => {
      const { attendances, newAttendances} = this.state;
      const notImported = _.difference(attendances, newAttendances);

      this.setState({ successAlert: 'Attendees successfully imported.', attendances: notImported, newAttendances: [] })
    }).catch((err) => {
      this.setState({ errorAlert: 'An error ocurred. Try again later.' })
    });
  }

  renderAttendances() {
    const { attendances, newAttendances } = this.state;
    return attendances.map(attendance => (<RemoteAttendance
        key={attendance.id} attendance={attendance}
        onCheckboxChecked={this.addAttendanceToNewAttendances.bind(this)}
        onCheckboxUnChecked={this.removeAttendanceFromNewAttendances.bind(this)}
        checked={_.includes(newAttendances, attendance)}
        updateAttendanceEmail={this.updateAttendanceEmail.bind(this)}
        hasEmail={!!attendance.email}
      />
    ))
  }

  updateAttendanceEmail(id, attendanceEmail) {
    const { attendances, newAttendances } = this.state;
    const attendance = _.find(attendances, attendanceItem => (attendanceItem.id == id))
    attendance.email = attendanceEmail;
    this.setState({attendances: attendances, newAttendances: newAttendances});
    console.log('attendance', attendance);
    console.log(this.state);
  }

  addAttendanceToNewAttendances(attendance) {
    const newAttendances = this.state.newAttendances.concat(attendance);
    this.setState({ newAttendances });
  }

  removeAttendanceFromNewAttendances(newAttendance) {
    const newAttendances = _.filter(this.state.newAttendances, (attendance) => (attendance.id !== newAttendance.id));
    this.setState({ newAttendances });
  }

  handleChange(ev) {
    const newAttendances = ev.target.checked ? this.state.attendances : [];
    this.setState({newAttendances})
  }

  renderAlert() {
    const { errorAlert, successAlert, noticeAlert } = this.state;

    if (errorAlert.length)
      return (
        <div className='row'>
          <div className="col-12 alert alert-danger">{errorAlert}</div>
        </div>
      )

    if(successAlert.length)
      return (
        <div className='row'>
          <div className="col-12 alert alert-success">{successAlert}</div>
        </div>
      )

    if(noticeAlert.length)
      return (
        <div className='row'>
          <div className="col-12 alert alert-info">{noticeAlert}</div>
        </div>
      )
  }

  showActionButtons() {
    const { attendances, loading } = this.state;

    if (!loading && attendances.length)
      return (
        <div className='col-3 text-right'>
          <label className="form-check-label" style={{ marginRight: '20px' }}>
            <input type="checkbox" className="form-check-input"
              style={{ marginRight: '5px' }}
              onChange={this.handleChange.bind(this)}
            />
            Select All
          </label>
          <div className='btn btn-success' onClick={this.importAttendances.bind(this)}>Import</div>
        </div>
      )
  }

  showAttendancesList() {
    const { attendances, loading } = this.state;

    if (!loading && attendances.length)
      return(
        <div>
          <table className='table'>
            <tbody>
              {this.renderAttendances()}
            </tbody>
          </table>
          <br />
          <div className='btn btn-success pull-right' onClick={this.importAttendances.bind(this)}>Import</div>
        </div>
      )
    else
      return(
        <div>
          <p>There are not unmatched attendees between the facebook and affinity version of the event.</p>
          <br />
        </div>
      )
  }

  render() {
    const { remote_event, attendances } = this.state;

    if (!remote_event.name ) { return null }

    return (
      <div>
        <Nav activeTab='events'/>
        {this.renderAlert()}
        <h2>Import new Facebook RSVP's</h2>
        <br/>
        <div className='row'>
          <div className='col-9'>
            <h2>{`${remote_event.name} RSVP's to Import`}</h2>
          </div>
          { this.showActionButtons() }
        </div>
        <br />
        { this.showAttendancesList() }
        <Link to={eventsPath()} className='btn btn-primary pull-left'>Back To Events</Link>
      </div>
    );
  }
}

export default AttendanceImport;
