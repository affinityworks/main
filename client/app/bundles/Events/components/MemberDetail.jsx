import axios from 'axios';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import Nav from './Nav';
import Tags from './Tags';
import Event from './Event';
import { membersPath, membershipPath } from '../utils/Pathnames';
import EmailLink from './EmailLink';
import ActionHistory from './ActionHistory';

class MemberDetail extends Component {
  state = { attendances: [], membership: {} }

  componentWillMount() {
    const { id } = this.props.match.params;
    this.fetchMembership(id);
    this.fetchAttendances(id);
  }

  fetchAttendances(id) {
    axios.get(`${id}/attendances.json`)
      .then(response => this.setState({ attendances: response.data.data }));
  }

  fetchMembership(id) {
    axios.get(`${membershipPath()}/${id}.json`)
      .then(response => this.setState({ membership: response.data.data }));
  }

  render() {
    const { membership } = this.state;

    if (!membership.attributes)
      return null;

    const { attributes } = membership.attributes.person.data;
    return (
      <div>
        <Nav activeTab='members'/>

        <br />

        <div className='row container'>
          <h1>{`${attributes['given-name']} ${attributes['family-name']} `}</h1>
          <EmailLink
            email={attributes['primary-email-address']}
            style={{ marginLeft: '14px', alignSelf: 'center' }}
          />
        </div>

        <div> {attributes['primary-phone-number']} </div>

        <br/>

        <div className='row'>
          <div className='col-6'>
            <ActionHistory attendances={this.state.attendances}/>
          </div>
          <div className='col-6'>
            <h4>Notes</h4>
            <div className='list-group'>
            </div>
          </div>
        </div>

        <br/>

        <div className='row'>
          <div className='col-6'>
            <h4 style={{ marginRight: '10px' }}>Tags</h4>
            <Tags tags={membership.attributes.tags} membershipId={membership.id} />
          </div>
        </div>

        <br/>
        <br/>

        <Link to={membersPath()}>
          <button className='btn btn-primary'>Back to Members</button>
        </Link>
      </div>
    );
  }
}

export default MemberDetail;
