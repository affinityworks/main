import React, { Component } from 'react';
import axios from 'axios';
import queryString from 'query-string';
import Nav from './Nav';
import { connect } from 'react-redux';

import history from '../history';
import Member from './Member';
import Pagination from './Pagination';
import { fetchMembers } from '../actions'

class Members extends Component {
  componentWillMount() {
    this.props.fetchMembers(this.props.location.search);
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchMembers(nextProps.location.search);
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

  render() {
    return (
      <div>
        <Nav activeTab='members'/>
        <table className='table'>
          <thead>
            <tr>
              <th>Name</th>
              <th>Phone</th>
              <th>Location</th>
              <th>Events</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {this.props.members.map(member => (
              <Member key={member.id} id={member.id} member={member.attributes} />
            ))}
          </tbody>
        </table>
        <br />
        {this.renderPagination()}
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { members, total_pages, page } = state.members;
  return { members, total_pages, page };
};

export default connect(mapStateToProps, { fetchMembers })(Members);
