import React, { Component } from 'react';

class Attendance extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    console.log(this.props.attendance);
    const { attributes, id } = this.props.attendance;
    const attendee = attributes.person.data.attributes;

    console.log(attendee);
    return (
      <div className='list-group-item'>
        <div className='col-8'>
          <div className='row'>
            {`${attendee['given-name']} ${attendee['family-name']}`}
          </div>

          <div className='row'>
            <small>{`${attendee['primary-email-address']}`}</small>
          </div>
        </div>

        <div className='col-4'>
          <div className='btn-group' role='group'>
            <button type='button' className='btn btn-secondary'> Y </button>
            <button type='button' className='btn btn-secondary'> ? </button>
            <button type='button' className='btn btn-secondary'> N </button>
          </div>
        </div>
      </div>
    );
  }
}

export default Attendance;
