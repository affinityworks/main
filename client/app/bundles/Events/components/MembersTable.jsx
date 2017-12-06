import React, { Component } from 'react';

import Member from './Member';
import SortableHeader from './SortableHeader';
import Spinner from './Spinner';
import { isAllowed } from '../utils';
import UserAuth from '../components/UserAuth';


class MembersTable extends Component {
  state = { emails: [] };

  groupColumn() {
    if (this.props.showGroupName)
      return <SortableHeader title='Group Name' sortBy='groups.name'  style={{ width: '20%' }}/>
  }

  locationColumn() {
    const width = this.props.showGroupName ? '12%' : '20%'
      return <SortableHeader title='Location' sortBy='addresses.locality' style={{ width: `${width}`}} />
  }

  phoneColumn() {
    const width = this.props.showGroupName ? '10%' : '15%'
    return <th style={{ width: `${width}`}}>Phone</th>
  }

  nameColumn() {
    const width = this.props.showGroupName ? '15%' : '20%'
    return <SortableHeader title='Name' sortBy='name' style={{ width: `${width}`}} />
  }

  generateEmailsLink() {
    const { emails } = this.state;
    if (emails.length)
      return (
        <a href={`mailto:${emails.join(',')}`} className='fa fa-envelope-o'/>
      );
    else
      return (<i className='fa fa-envelope-o'/>);
  }

  addMemberEmail(email) {
    const emails = this.state.emails.concat(email);
    this.setState({ emails });
  }

  showTags() {
    return (
      <td style={{ width: '20%'}}>
        <UserAuth allowed={['organizer']}>
          <strong>Tags</strong>
        </UserAuth>
      </td>
    )
  }

  removeMemberEmail(memberEmail) {
    const emails = _.filter(this.state.emails, (email) => (email !== memberEmail));
    this.setState({ emails });
  }

  renderMembers() {
    return this.props.memberships.map(membership => {
      const { tags } = membership.attributes;
      const person = membership.attributes.person.data;

      return <Member key={person.id} id={person.id}
        member={person.attributes}
        currentRole={this.props.currentRole}
        groups={person.relationships.groups.data}
        role={membership.attributes.role}
        onCheckboxChecked={this.addMemberEmail.bind(this)}
        onCheckboxUnChecked={this.removeMemberEmail.bind(this)}
        showGroupName={this.props.showGroupName}
        membershipId={membership.id}
        tags={tags}
        memberTagList={this.props.memberTagList}
        currentGroup={this.props.currentGroup}
      />
    })
  }

  render() {
    const { memberships, currentRole } = this.props;

    if (!memberships)
      return (
        <div style={{ alignItems: 'center', height: '150px', display: 'flex', justifyContent: 'center' }}>
          <Spinner classes='fa-3x' />
        </div>
      )

    if (!memberships.length)
      return (
        <div style={{ justifyContent: 'center', height: '150px', display: 'flex', alignItems: 'center' }}>
          <h4>
            No members found
          </h4>
        </div>
      );

    return (
      <table className='table'>
        <thead>
          <tr>
            <th style={{ width: '5%'}}>{this.generateEmailsLink()}</th>
            {this.nameColumn()}
            {this.phoneColumn()}
            {this.locationColumn()}
            {isAllowed(['member', 'volunteer'], currentRole)
              ? <th/>
              : this.groupColumn() }
            {this.showTags()}
            <SortableHeader title='Role' sortBy='role' style={{ width: '15%'}} />
            <th style={{ width: '5%'}}></th>
          </tr>
        </thead>
        <tbody>
          {this.renderMembers()}
        </tbody>
      </table>
    );
  }
}

export default MembersTable;
