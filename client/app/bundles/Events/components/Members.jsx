import React, { Component } from 'react';
import axios from 'axios';
import queryString from 'query-string';
import { connect } from 'react-redux';
import _ from 'lodash';

import Member from './Member';
import MembersFilter from './MembersFilter';
import Pagination from './Pagination';
import SortableHeader from './SortableHeader';
import { fetchMemberships } from '../actions'

class Members extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.filterMembers = this.filterMembers.bind(this);
    this.renderMembers = this.renderMembers.bind(this);
    this.state = { emails: [] };
  }

  componentWillMount() {
    this.props.fetchMemberships(this.props.location.search);
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchMemberships(nextProps.location.search);
  }

  filterMembers(filter) {
    this.props.history.push(`?${queryString.stringify({ filter })}`);
  }

  renderPagination() {
    const { total_pages, page, location } = this.props;
    if (total_pages) {
      return <Pagination
        page={page}
        totalPages={total_pages}
        currentSearch={location.search} />
    }
  }

  renderMembers() {
    return this.props.memberships.map(membership => {
      const person = membership.attributes.person.data;
      return <Member key={person.id} id={person.id}
        member={person.attributes}
        role={membership.attributes.role}
        onCheckboxChecked={this.addMemberEmail.bind(this)}
        onCheckboxUnChecked={this.removeMemberEmail.bind(this)}
      />
    })
  }

  addMemberEmail(email) {
    const emails = this.state.emails.concat(email);
    this.setState({ emails });
  }

  removeMemberEmail(memberEmail) {
    const emails = _.filter(this.state.emails, (email) => (email !== memberEmail));
    this.setState({ emails });
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

  render() {
    const { search } = this.props.location;
    const { filter } = queryString.parse(search);

    return (
      <div>
        <div className='row'>
          <div className='col-6'>
            <MembersFilter onSearchSubmit={this.filterMembers} filter={filter} />
          </div>
        </div>

        <br />
        <table className='table'>
          <thead>
            <tr>
              <th style={{ width: '5%'}}>{this.generateEmailsLink()}</th>
              <SortableHeader title='Name' sortBy='name' style={{ width: '25%'}} />
              <th style={{ width: '15%'}}>Phone</th>
              <th style={{ width: '30%'}}>Location</th>
              <SortableHeader title='Role' sortBy='role' style={{ width: '20%'}} />
              <th style={{ width: '5%'}}></th>
            </tr>
          </thead>
          <tbody>
            {this.renderMembers()}
          </tbody>
        </table>
        <br />
        {this.renderPagination()}
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { memberships, total_pages, page } = state.memberships;
  return { memberships, total_pages, page };
};

export default connect(mapStateToProps, { fetchMemberships })(Members);
