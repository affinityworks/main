import React, { Component } from 'react';

class Attendance extends Component {
  constructor(props) {
    super(props);
  }

  componentWillMount() {
    this.state = { attended: this.props.attendance.attributes.attended };
  }

  render() {
    console.log(this.state);
    const { attributes, id } = this.props.attendance;
    const attendee = attributes.person.data.attributes;

    return (
      <div className='list-group-item'>
        <div className='col-8'>
          <div className='row'>
            {`${attendee['given-name']} ${attendee['family-name']}`}
          </div>

          <div> {this.state.attended} </div>

          <div className='row'>
            <small>{`${attendee['primary-email-address']}`}</small>
          </div>
        </div>

        <div className='col-4'>
          <div className='btn-group' role='group'>
            <button
              type='button'
              className={`btn ${this.state.attended === true ? 'btn-success' : 'btn-secondary'}`}
              onClick={() => this.setState({ attended: true })}>
              Y
            </button>

            <button
              type='button'
              className={`btn ${this.state.attended === undefined ? 'btn-warning' : 'btn-secondary'}`}
              onClick={() => this.setState({ attended: undefined })}>
              ?
            </button>

            <button
              type='button'
              className={`btn ${this.state.attended === false ? 'btn-danger' : 'btn-secondary'}`}
              onClick={() => this.setState({ attended: false })}>
              N
            </button>
          </div>
        </div>
      </div>
    );
  }
}

export default Attendance;
