import React, { Component } from 'react';
import { connect } from 'react-redux';

import Nav from '../components/Nav';
import RemoteAttendance from '../components/RemoteAttendance';
import { eventsPath, client } from '../utils';
import _ from 'lodash';
import { Link } from 'react-router-dom';
import { addAlert } from '../actions';

class AttendanceImport extends Component {
  constructor(props) {
    super(props)

    const { attendances, remote_event } = props;
    this.state = { attendances: attendances, remote_event: remote_event, newAttendances: [] };
  }

  componentWillReceiveProps(nextProps) {
    const { attendances, remote_event } = nextProps;
    this.state = { attendances: attendances, remote_event: remote_event };
  }

  importAttendances() {
    const { newAttendances, remote_event } = this.state;
    const { event_id } = remote_event;

    if (!newAttendances.length) {
      let text = 'Please select attendees from the list';
      let type = 'alert';
      this.props.addAlert({ text, type });
      return;
    }

    client.post(`${eventsPath()}/${event_id}/attendances/import_remote.json`, {
      remote_attendances: newAttendances
    }).then((response) => {
      const { attendances, newAttendances} = this.state;
      const notImported = _.difference(attendances, newAttendances);

      let text = 'Attendees successfully imported.';
      let type = 'success';
      this.props.addAlert({ text, type });
      this.setState({ attendances: notImported, newAttendances: [] })
    }).catch((err, alert) => {
      this.props.addAlert(alert);
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

  showActionButtons() {
    const { attendances } = this.state;

    if (attendances.length)
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
    const { attendances } = this.state;

    if (attendances.length)
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
    const { remote_event } = this.state;
    return (
      <div>
        <Nav activeTab='events'/>
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

export default connect(null, { addAlert })(AttendanceImport);
