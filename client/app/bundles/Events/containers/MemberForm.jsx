import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import FormGroup from '../components/FormGroup';
import Input from '../components/Input';

class MemberForm extends Component {
  state = {
    showAddressForm: false
  };

  renderAddressForm() {
    if (this.state.showAddressForm) {
      return(
        <div>
          OPTIONAL
          <FormGroup>
            <Input label='Street Address:' classes='col-md-6' />
          </FormGroup>

          <FormGroup row>
            <Input label='City:' classes='col-md-4' />
            <Input label='Zipcode:' classes='col-md-2' />
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

  render() {
    return (
      <form onSubmit={this.props.onSubmit}>
        <FormGroup>
          <Input label='Email' classes='col-md-5' />
        </FormGroup>

        <FormGroup row>
          <Input label='First Name:' classes='col-md-4' />
          <Input label='Last Name:' classes='col-md-4' />
        </FormGroup>

        <FormGroup>
          <Input label='Phone:' classes='col-md-4' />
        </FormGroup>

        {this.renderAddressForm()}

        <br />

        <div>
          <button type='submit' className='btn btn-success'>
            Done
          </button>
        </div>
      </form>
    );
  }
}

export default MemberForm;
