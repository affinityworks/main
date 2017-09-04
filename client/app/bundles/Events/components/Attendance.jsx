import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import FacebookLink from './FacebookLink';
import { updateAttendance } from '../actions';
import { membersPath } from '../utils/Pathnames';

class Attendance extends Component {
  constructor(props) {
    super(props)

    const { attended } = props.attendance.attributes;
    this.state = { attended }
  }

  emailAddressLink() {
    const email = this.props.member['primary-email-address']

    if (email)
      return <a href={`mailto:${email}`} className='fa fa-envelope-o'/>
  }

  renderFacebookLink() {
    const { attributes } = this.props.attendance;

    let fromFB = _.find(attributes.origins, { name: 'Facebook' });

    if (fromFB) {
      const { identifiers } = attributes.person.data.attributes;
      const fbIdentifier = _.find(identifiers, (identifier) => {
        return identifier.indexOf('facebook') >= 0;
      });
      const fbUserId = fbIdentifier.replace('facebook:', '');

      return <FacebookLink id={fbUserId} />;
    }
  }

  updateAttended(attended) {
    const id = this.props.attendance.id;
    const eventId = this.props.eventId;

    this.setState({ attended });
    this.props.updateAttendance({ id, eventId, attended });
  }

  render() {
    const attendee = this.props.attendance.attributes.person.data.attributes;
    const person = this.props.attendance.attributes.person;
    const { attended } = this.state;


    return (
      <div className='list-group-item'>
        <div className='col-8' style={{ display: 'flex', alignItems: 'center' }}>
          <div style={{ marginRight: '20px' }}>
            <div>
              <Link to={`${membersPath()}/${person.data.id}`}>
                {attendee['given-name']} {attendee['family-name']}
              </Link>
            </div>

            <div>
              <small>{`${attendee['primary-email-address']}`}</small>
            </div>
          </div>

          <div>
            {this.renderFacebookLink()}
          </div>
        </div>

        <div className='col-4'>
          <div className='btn-group' role='group'>
            <button
              type='button'
              className={`btn ${attended === true ? 'btn-success' : 'btn-secondary'}`}
              onClick={() => this.updateAttended(true)}>
              Y
            </button>

            <button
              type='button'
              className={`btn ${attended === undefined ? 'btn-warning' : 'btn-secondary'}`}
              onClick={() => this.updateAttended(undefined)}>
              ?
            </button>

            <button
              type='button'
              className={`btn ${attended === false ? 'btn-danger' : 'btn-secondary'}`}
              onClick={() => this.updateAttended(false)}>
              N
            </button>
          </div>
        </div>
      </div>
    );
  }
}

export default connect(null, { updateAttendance })(Attendance);
