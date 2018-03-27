import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import Nav from '../components/Nav';
import Tags from '../components/Tags';
import Notes from '../components/Notes';
import CustomFields from '../components/CustomFields';
import UserAuth from '../components/UserAuth';
import Event from '../components/Event';
import EmailLink from '../components/EmailLink';
import ActionHistory from '../components/ActionHistory';
import { membersPath, membershipPath, client } from '../utils';
import { addAlert } from '../actions';
import { map } from 'lodash';

function isOrganizer (membership) {
  return membership.attributes.role === 'organizer';
}

class MemberDetail extends Component {
  state = { attendances: [], membership: {}, isOrganizer: false }

  componentWillMount() {
    const { id } = this.props.match.params;
    
    this.fetchMembership(id);
    this.fetchAttendances(id);
  }

  fetchAttendances(id) {
    client.get(`${id}/attendances.json`)
      .then(response => this.setState({ attendances: response.data.data }))
      .catch(err => {
        let text = 'An error ocurred while retrieving the Attendances.';
        let type = 'error';
        this.props.addAlert({ text, type });
      });
  }

  fetchMembership(id) {
    client.get(`${membershipPath()}/${id}.json`)
      .then(response => response.data.data)
      .then(membership => this.setState({ membership, isOrganizer: isOrganizer(membership) }))
      .catch(err => {
        let text = 'An error ocurred while retrieving the Members.';
        let type = 'error';
        this.props.addAlert({ text, type });
      });
  }

  createChangeRole (id, role) {
    client.put(`${this.props.match.url}.json`, {person: { memberships_attributes: {'0': {id: `${id}`, role: `${role}`} }}} )
      .then(response => {
        let type = 'success';
      })
      .catch(err => {
        let text = 'An error ocurred while retrieving the Members.';
        let type = 'error';
        this.props.addAlert({ text, type });
      });
  }

  renderBlankTemplate() {
    return(
      <div>
        <Nav activeTab='members'/>
        <br/>

        <Link to={membersPath()}>
          <button className='btn btn-primary'>Back to Members</button>
        </Link>
      </div>
    )
  }

  setRole () {
    const { id } =  this.state.membership;
 
    if (!this.state.isOrganizer) {
      return this.createChangeRole(id, 'organizer') 
    } else {
      return this.createChangeRole(id, 'member')
    }
  }

  handleInputChange(event) {
    const { membership } = this.state;
    const target = event.target;
    const value = target.type === 'checkbox' ? target.checked : target.value;
    const name = target.name;

    this.setState({ [name]: value });
    this.setRole();
  }

  inputCheckMember () {
    const { membership, isOrganizer } = this.state;

    return (
      <div className='check-member mb-3'>
        <span className='mr-3'>{`Is ${isOrganizer ? 'organizer' : 'member'} of ${membership.attributes.group.data.attributes.name}`}</span>
        <label className='switch'>
        <input
          name='isOrganizer'
          type='checkbox'
          checked={isOrganizer}
          onChange={this.handleInputChange.bind(this)}
          ref='checkbox'
        />
        <span className='slider round'></span>
        </label>
      </div>
    )
  }

  render() {
    const { membership, isOrganizer } = this.state;
    if (!membership.attributes)
      return this.renderBlankTemplate();
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
            {isOrganizer ? 'Organizer' : 'Member'}
          </span>

          {phone && <span style={{ marginRight: '20px' }}> Phone: {phone} </span>}

          <span>
            Email:&nbsp;
            <a href={`mailto:${attributes['primary-email-address']}`}
               target="_blank">
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
            <UserAuth allowed={['organizer']}>
              <div>
                {this.inputCheckMember()}
                <h4 style={{ marginRight: '10px' }}>Tags</h4>
                <Tags tags={membership.attributes.tags} membershipId={membership.id} />
              </div>
            </UserAuth>
            <br/>
            <h4>Custom Fields</h4>
            <CustomFields customFields={attributes['custom-fields']} />
            <br/>
            <h4>Notes</h4>
            <Notes notes={membership.attributes.notes} membershipId={membership.id}/>
          </div>
        </div>

        <br/>
        <br/>
        
        <div className='btn-toolbar'>
          <Link to={membersPath()} className='btn btn-primary' role='button'>
            Back to Members
          </Link>&nbsp;
          <UserAuth allowed={['organizer']}>
            <a href={attributes['id']+"/edit"} className='btn btn-primary' role='button'>
              Edit
            </a>
          </UserAuth>
        </div>
      </div>
    );
  }
}

export default connect(null, { addAlert })(MemberDetail);
