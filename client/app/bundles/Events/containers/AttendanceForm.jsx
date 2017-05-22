import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import FormGroup from '../components/FormGroup';
import Input from '../components/Input';
import { lookUpMember, setAttendanceAttribute, cleanAttendanceAlerts } from '../actions';

class AttendanceForm extends Component {
  state = { showAddressForm: false };

  componentWillUnmount() {
    this.props.cleanAttendanceAlerts();
  }

  renderAddressForm() {
    if (this.state.showAddressForm) {
      const { newAttendance, setAttendanceAttribute } = this.props;

      return(
        <div>
          OPTIONAL
          <FormGroup>
            <Input
              label='Street Address:'
              classes='col-md-6'
              value={newAttendance.address_lines}
              onChange={(e) => setAttendanceAttribute('address_lines', e.target.value)}
              disabled={newAttendance.disabled}
            />
          </FormGroup>

          <FormGroup row>
            <Input
              label='City:'
              classes='col-md-4'
              value={newAttendance['locality']}
              onChange={(e) => setAttendanceAttribute('locality', e.target.value)}
              disabled={newAttendance.disabled} />
            <Input
              label='Zipcode:'
              classes='col-md-2'
              value={newAttendance.postal_code}
              onChange={(e) => setAttendanceAttribute('postal_code', e.target.value)}
              disabled={newAttendance.disabled} />
          </FormGroup>
        </div>
      );
    }

    return (
      <div>
        <a href='#' onClick={() => this.setState({ showAddressForm: true })}>
          Click here to add optional street address
        </a>
      </div>
    );
  }

  renderAlert() {
    const { errorAlert, successAlert } = this.props.newAttendance;

    if (errorAlert.length)
      return <div className="alert alert-danger">{errorAlert} </div>

    if (successAlert.length)
      return <div className="alert alert-success">{successAlert} </div>
  }

  render() {
    const { lookUpMember, newAttendance, setAttendanceAttribute } = this.props;

    return (
      <form onSubmit={this.props.onSubmit}>
        {this.renderAlert()}

        <FormGroup>
          <Input
            label='Email'
            classes='col-md-5'
            onBlur={(e) => lookUpMember(e.target.value)}
            onChange={(e) => setAttendanceAttribute('primary-email-address', e.target.value)}
            value={newAttendance['primary-email-address']} />
        </FormGroup>

        <FormGroup row>
          <Input
            label='First Name:'
            classes='col-md-4'
            onChange={(e) => setAttendanceAttribute('given-name', e.target.value)}
            value={newAttendance['given-name']}
            disabled={newAttendance.disabled} />

          <Input
            label='Last Name:'
            classes='col-md-4'
            onChange={(e) => setAttendanceAttribute('family-name', e.target.value)}
            value={newAttendance['family-name']}
            disabled={newAttendance.disabled} />
        </FormGroup>

        <FormGroup>
          <Input
            label='Phone:'
            classes='col-md-4'
            onChange={(e) => setAttendanceAttribute('primary-phone-number', e.target.value)}
            value={newAttendance['primary-phone-number']}
            disabled={newAttendance.disabled} />
        </FormGroup>

        {this.renderAddressForm()}

        <br />
        <br />

        {this.props.children}
      </form>
    );
  }
}

const mapStateToProps = ({ newAttendance }) => {
  return { newAttendance }
};

export default connect(
  mapStateToProps, { lookUpMember, setAttendanceAttribute, cleanAttendanceAlerts }
)(AttendanceForm);
