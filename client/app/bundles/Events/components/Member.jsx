import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import EmailLink from './EmailLink';
import Tags from './Tags';
import { membersPath, groupPath } from '../utils';

class Member extends Component {
  emailAddressLink() {
    const email = this.props.member['primary-email-address']

    if (email)
      return <a href={`mailto:${email}`} className='fa fa-envelope-o'/>
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
        return <Link className='group-list' to={`${groupPath(id)}/dashboard`} key={id} >{name}</Link>
      })}</td>
    }
  }

  showTags() {
    const { tags, membershipId } = this.props;

    if (tags)
      return <Tags tags={tags} membershipId={membershipId} tagList={this.props.memberTagList}/>
  }

  renderNameLink () {
    const { member, id, groups, currentUser } = this.props;

    if (currentUser === 'member') {
      return (
        <td>
          <strong>
            {member['given-name']} {member['family-name']}  
          </strong>
        </td>
      )
    }

    return (
      <td>
        <Link to={`${membersPath(groups[0]['id'])}/${id}`}>
          {member['given-name']} {member['family-name']}
        </Link>
      </td>
    )
  }

  render() {
    const { member, role, currentUser} = this.props;
    const isMember = currentUser !== 'member';

    if(!member) { return null }

    const email = this.props.member['primary-email-address']

    return(
      <tr>
        <td>{this.showEmailCheckbox()}</td>
        {this.renderNameLink()}
        <td>{member['primary-phone-number']}</td>
        <td>{this.localityAndRegion()}</td>
        {isMember ? this.groupColumn() : <th/>}
        {isMember ? <td>{this.showTags()}</td> : <th/>}
        <td>{role}</td>
        <td>
          <EmailLink email={email} />
        </td>
      </tr>
    );
  }
}

export default Member;
