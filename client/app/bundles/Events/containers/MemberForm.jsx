import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import FormGroup from '../components/FormGroup';
import Input from '../components/Input';
import { lookUpMember, setMemberAttribute } from '../actions';

class MemberForm extends Component {
  state = { showAddressForm: false };

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
    const { lookUpMember, newMember, setMemberAttribute } = this.props;

    return (
      <form onSubmit={this.props.onSubmit}>
        <FormGroup>
          <Input
            label='Email'
            classes='col-md-5'
            onBlur={(e) => lookUpMember(e.target.value)}
            onChange={(e) => setMemberAttribute('primary-email-address', e.target.value)}
            value={newMember['primary-email-address']} />
        </FormGroup>

        <FormGroup row>
          <Input
            label='First Name:'
            classes='col-md-4'
            onChange={(e) => setMemberAttribute('given-name', e.target.value)}
            value={newMember['given-name']}
            disabled={newMember.disabled} />

          <Input
            label='Last Name:'
            classes='col-md-4'
            onChange={(e) => setMemberAttribute('family-name', e.target.value)}
            value={newMember['family-name']}
            disabled={newMember.disabled} />
        </FormGroup>

        <FormGroup>
          <Input
            label='Phone:'
            classes='col-md-4'
            onChange={(e) => setMemberAttribute('primary-phone-number', e.target.value)}
            value={newMember['primary-phone-number']}
            disabled={newMember.disabled} />
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

const mapStateToProps = ({ newMember }) => {
  return { newMember }
};

export default connect(
  mapStateToProps, { lookUpMember, setMemberAttribute}
)(MemberForm);
