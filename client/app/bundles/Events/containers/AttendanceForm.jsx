import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import FormGroup from '../components/FormGroup';
import Input from '../components/Input';

import {
  lookUpMember, setAttendanceAttribute,
  createAttendance, resetAttendanceForm
} from '../actions';

class AttendanceForm extends Component {
  state = { showAddressForm: false };

  componentWillUnmount() {
    this.props.resetAttendanceForm();
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

  renderAddressForm() {
    if (this.state.showAddressForm) {
      const { newAttendance, setAttendanceAttribute } = this.props;

      return(
        <div>
          <FormGroup row>
            <Input
              label='Street Address:'
              classes='col-md-3'
              value={newAttendance.address_lines}
              onChange={(e) => setAttendanceAttribute('address_lines', e.target.value)}
              disabled={newAttendance.disabled}
            />

            <Input
              label='City:'
              classes='col-md-2'
              value={newAttendance['locality']}
              onChange={(e) => setAttendanceAttribute('locality', e.target.value)}
              disabled={newAttendance.disabled}
            />

            <Input
              label='Zipcode:'
              classes='col-md-2'
              value={newAttendance.postal_code}
              onChange={(e) => setAttendanceAttribute('postal_code', e.target.value)}
              disabled={newAttendance.disabled}
            />

            {this.renderButtons()}
          </FormGroup>
        </div>
      );
    }

    return (
      <div>
        <a href='#' onClick={() => this.setState({ showAddressForm: true })}>
          Enter address...
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

  renderButtons() {
    const col = this.state.showAddressForm ? '5' : '3';
    return(
      <div className={`col-${col} text-right`} style={{ marginTop: 'auto' }}>
        <button
          className='btn btn-danger'
          type='button'
          style={{ marginRight: '10px' }}
          onClick={() => (this.props.resetAttendanceForm() & this.setState({ showAddressForm: false }))}>
          Cancel
        </button>

        <button type='submit' className='btn btn-success'>
          Save
        </button>
      </div>
    )
  }

  render() {
    const { lookUpMember, newAttendance, setAttendanceAttribute } = this.props;

    return (
      <form onSubmit={this.handleSubmit.bind(this)}>
        {this.renderAlert()}

        <FormGroup row>
          <Input
            label='Email'
            classes='col-md-3'
            onBlur={(e) => lookUpMember(e.target.value)}
            onChange={(e) => setAttendanceAttribute('primary-email-address', e.target.value)}
            value={newAttendance['primary-email-address']}
          />

          <Input
            label='First Name:'
            classes='col-md-2'
            onChange={(e) => setAttendanceAttribute('given-name', e.target.value)}
            value={newAttendance['given-name']}
            disabled={newAttendance.disabled}
          />

          <Input
            label='Last Name:'
            classes='col-md-2'
            onChange={(e) => setAttendanceAttribute('family-name', e.target.value)}
            value={newAttendance['family-name']}
            disabled={newAttendance.disabled}
          />

          <Input
            label='Phone:'
            classes='col-md-2'
            onChange={(e) => setAttendanceAttribute('primary-phone-number', e.target.value)}
            value={newAttendance['primary-phone-number']}
            disabled={newAttendance.disabled}
          />

          {!this.state.showAddressForm && this.renderButtons()}

        </FormGroup>

        {this.renderAddressForm()}

        <br />

      </form>
    );
  }
}

const mapStateToProps = ({ newAttendance }) => {
  return { newAttendance }
};

export default connect(
  mapStateToProps, {
    lookUpMember,
    setAttendanceAttribute,
    createAttendance,
    resetAttendanceForm
  }
)(AttendanceForm);
