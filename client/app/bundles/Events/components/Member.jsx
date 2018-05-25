import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import EmailLink from './EmailLink';
import Tags from './Tags';
import { pickBy, map } from 'lodash'
import UserAuth from '../components/UserAuth';
import { membersPath, groupPath, isAllowed } from '../utils';

class Member extends Component {
  emailAddressLink() {
    const email = this.props.member['primary-email-address']

    if (email)
      return <a href={`mailto:${email}`} className='fa fa-envelope-o'
                target="_blank"/>
  }

  localityAndRegion() {
    const address = this.props.member['primary-personal-address']
    if (address) {
      if (address['locality'] && address['region']) {
        return <span>{address['locality']}, {address['region']}</span>
      }
      else if (address['locality']) {
        return <span>{address['locality']}</span>
      }
      else if (address['region']){
        return <span>{address['region']}</span>
      }
      else if (address['postal_code']){
        return <span>{address['region']}</span>
      }
    }
    return <span></span>
  }

  handleChange(ev) {
    const { member, onCheckboxChecked, onCheckboxUnChecked } = this.props;
    const email = member['primary-email-address'];

    if(ev.target.checked && email)
      onCheckboxChecked(email);
    else
      onCheckboxUnChecked(email)
  }

  showEmailCheckbox() {
    const email = this.props.member['primary-email-address'];
    return <input type='checkbox' disabled={email ? false : true} onChange={this.handleChange.bind(this)}/>
  }

  groupColumn() {
    const {groups} = this.props;
    if (groups.length && this.props.showGroupName){
      return <td>{groups.map(group => {
        const { id, name } = group;
        return (
          <div>
            <Link className='group-list' to={`${groupPath(id)}/dashboard`} key={id} >{name}</Link>
            <br/>
          </div>
          )
      })}</td>
    }
  }

  deleteMembershipColumn() {
    const { role, currentRole, membershipId, deleteMembership } = this.props

    return (
      <UserAuth allowed={['organizer']}>
        <td>
          { (role === "member") &&
            <a
               style={{cursor: 'pointer', color: "royalblue"}}
               onClick={() => deleteMembership(membershipId)}>
              <b>x</b>
            </a>
          }
        </td>
      </UserAuth>
    )
  }

  showTags() {
    const { tags, membershipId } = this.props;

  return (
      <td>
        <UserAuth allowed={['organizer']}>
          {tags ? <Tags tags={tags} membershipId={membershipId} tagList={this.props.memberTagList}/> : null} 
        </UserAuth>
      </td>
    )
  }

  getGroupId () {
    const { groups } = this.props;

    return map(groups, (item) => {
      const groupId = item.id;
      return `/groups/${groupId}/members`
    })
  }

  renderMemberProfileLink () {
    const { member, id, groups, location } = this.props;    
    const groupPath = this.getGroupId()
    const groupId = groupPath.indexOf(location.pathname) >= 0 
      ? location.pathname : membersPath(groups[0]['id']) 

    if (groupId === location.pathname) {
      return (
        <span>
          <Link to={`${location.pathname}/${id}`}>
            {member['given-name']} {member['family-name']}
          </Link>
        </span>
      )
    }

    return <span>{member['given-name']} {member['family-name']}</span>
  }

  renderNameLink () {
    const { member } = this.props;

    return (
      <td>
        <UserAuth allowed={['member']}>
          <strong>{member['given-name']} {member['family-name']}</strong>
        </UserAuth>
        <UserAuth allowed={['organizer', 'volunteer']}>
          {this.renderMemberProfileLink()}
        </UserAuth>   
      </td>   
    )
  }

  render() {
    const { member, role, currentRole, membershipId, deleteMembership } = this.props
    
    if(!member) { return null }

    const email = this.props.member['primary-email-address']

    return(
        <tr>
          <td>{this.showEmailCheckbox()}</td>
          {this.renderNameLink()}
          <td>{member['primary-phone-number']}</td>
          <td>{this.localityAndRegion()}</td>
          {isAllowed(['member'], currentRole) && this.groupColumn()}
          {this.showTags()}
          <td>{role}</td>
          <td>
            <EmailLink email={email} />
          </td>
          {this.deleteMembershipColumn()}
        </tr>
    );
  }
}

export default Member;
