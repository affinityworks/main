import React, { Component } from 'react';
import axios from 'axios';
import Member from './Member';
import queryString from 'query-string';
import Pagination from './Pagination';
import history from '../history';

class Members extends Component {
  constructor(props, _railsContext) {
    super(props);

    const { page } = queryString.parse(props.location.search);

    this.state = { members: [], page: page };
  }

  componentDidMount() {
    this.getMembers(this.state.page);
  }

  componentWillReceiveProps(nextProps) {
    const { page } = queryString.parse(nextProps.location.search);
    this.getMembers(page);
  }

  getMembers(page) {
    const query = { page };
    const uri = `/members.json?${queryString.stringify(query)}`;

    axios.get(uri)
      .then(res => {
        const members = res.data.members.data;
        const { total_pages, page } = res.data;
        this.setState({ members, total_pages, page });
      });
  }

  renderPagination() {
    if (this.state.total_pages) {
      return <Pagination
        page={this.state.page}
        totalPages={this.state.total_pages}
        currentSearch={this.props.location.search} />
    }
  }

  render() {
    return (
      <div>
        <table className='table'>
          <thead>
            <tr>
              <th>Name</th>
              <th>Phone</th>
              <th>Email</th>
              <th>Events</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {this.state.members.map(member => <Member key={member.id} member={member.attributes} />)}
          </tbody>
        </table>
        <br />
        {this.renderPagination()}
      </div>
    );
  }
}

export default Members;
