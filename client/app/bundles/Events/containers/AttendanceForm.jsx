import _ from 'lodash';
import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import UserAuth from '../components/UserAuth';
import FormGroup from '../components/FormGroup';
import Input from '../components/Input';
import Spinner from '../components/Spinner';

import {
  lookUpMember, setAttendanceAttribute,
  createAttendance, resetAttendanceForm
} from '../actions';

class AttendanceForm extends Component {
  state = { showAddressForm: false };
  debouncedLookUp = _.debounce(value => {
    this.props.lookUpMember(value)
  }, 250);

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
              label='Zip Code:'
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

  renderSpinner() {
    if (this.props.newAttendance.loading)
      return (
        <div className='col-md-2' style={{ marginTop: '40px' }}>
          <Spinner />
        </div>
      );
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

  handleEmailChange(e) {
    const { setAttendanceAttribute } = this.props;

    setAttendanceAttribute('primary-email-address', e.target.value);
    this.debouncedLookUp(e.target.value);
  }

  render() {
    const { newAttendance, setAttendanceAttribute } = this.props;

    return (
      <div>
        <UserAuth allowed={['organizer']}>
          <form onSubmit={this.handleSubmit.bind(this)}>
            <FormGroup row>
              <div className='col-md-3'>
                <div className='row'>
                  <Input
                    label='Email'
                    classes='col-md-10'
                    onBlur={(e) => setAttendanceAttribute('loading', false)}
                    onChange={this.handleEmailChange.bind(this)}
                    value={newAttendance['primary-email-address']}
                  />

                  {this.renderSpinner()}
                </div>
              </div>

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
        </UserAuth>
      </div>
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
