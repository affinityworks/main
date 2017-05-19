import React, { Component } from 'react';

class MemberForm extends Component {
  state = {
    showAddressForm: false
  };

  renderAddressForm() {
    if (this.state.showAddressForm) {
      return(
        <div>
          OPTIONAL
          <div className='form-group'>
            <label> Street Address: </label>
            <input type='text' className='form-control col-md-6'/>
          </div>

          <div className='form-group row'>
            <div className='col-md-4'>
              <label> City: </label>
              <input type='text' className='form-control'/>
            </div>

            <div className='col-md-2'>
              <label> Zipcode: </label>
              <input type='text' className='form-control'/>
            </div>
          </div>
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
        <div className='form-group'>
          <label> Email: </label>
          <input type='text' className='form-control col-md-5'/>
        </div>

        <div className='form-group row'>
          <div className='col-md-4'>
            <label> First Name: </label>
            <input type='text' className='form-control'/>
          </div>

          <div className='col-md-4'>
            <label> Last Name: </label>
            <input type='text' className='form-control'/>
          </div>
        </div>

        <div className='form-group'>
          <label> Phone: </label>
          <input type='text' className='form-control col-md-4'/>
        </div>

        {this.renderAddressForm()}

        <br />

        <button type='submit' className='btn btn-success'>
          Done
        </button>
      </form>
    );
  }
}

export default MemberForm;
