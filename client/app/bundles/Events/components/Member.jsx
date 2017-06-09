import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import Tags from './Tags';
import { membersPath, groupPath } from '../utils/Pathnames';

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
      return <Tags tags={tags} membershipId={membershipId} />
  }

  render() {
    const { member, role, id } = this.props;

    if(!member) { return null }

    return(
      <tr>
        <td>{this.showEmailCheckbox()}</td>
        <td>
          <Link to={`${membersPath()}/${id}`}>
            {member['given-name']} {member['family-name']}
          </Link>
        </td>
        <td>{member['primary-phone-number']}</td>
        <td>{this.localityAndRegion()}</td>
        {this.groupColumn()}
        <td>{this.showTags()}</td>
        <td>{role}</td>
        <td>{this.emailAddressLink()}</td>
      </tr>
    );
  }
}

export default Member;
