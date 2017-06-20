import axios from 'axios';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import Nav from '../components/Nav';
import Tags from '../components/Tags';
import Notes from '../components/Notes';
import Event from '../components/Event';
import EmailLink from '../components/EmailLink';
import ActionHistory from '../components/ActionHistory';
import { membersPath, membershipPath } from '../utils';

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
    const phone = attributes['primary-phone-number'];

    return (
      <div>
        <Nav activeTab='members'/>

        <br />

        <div className='row container'>
          <h1>{`${attributes['given-name']} ${attributes['family-name']} `}</h1>
        </div>

        <div className='row container' style={{ marginTop: '10px' }}>
          <span style={{ textTransform: 'capitalize', marginRight: '40px' }}>
            {membership.attributes.role}
          </span>

          {phone && <span style={{ marginRight: '20px' }}> Phone: {phone} </span>}

          <span>
            Email:&nbsp;
            <a href={`mailto:${attributes['primary-email-address']}`}>
              {attributes['primary-email-address']}
            </a>
          </span>
        </div>

        <hr style={{ marginTop: '0.5rem' }} />

        <br/>

        <div className='row'>
          <div className='col-6'>
            <ActionHistory attendances={this.state.attendances}/>
          </div>
          <div className='col-6'>
            <h4 style={{ marginRight: '10px' }}>Tags</h4>
            <Tags tags={membership.attributes.tags} membershipId={membership.id} />
            <br/>
            <h4>Notes</h4>
            <Notes notes={membership.attributes.notes} membershipId={membership.id}/>
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
