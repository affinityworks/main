import React, { Component } from 'react';
import { connect } from 'react-redux';
import queryString from 'query-string';

import Groups from '../components/Groups';
import { fetchCurrentUserGroups } from '../actions';

class Profile extends Component {
  componentWillMount() {
    this.props.fetchCurrentUserGroups(this.buildQuery(this.props));
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchCurrentUserGroups(this.buildQuery(nextProps));
  }

  buildQuery(props) {
    const { page, sort, direction, tag } = queryString.parse(props.location.search);
    const query = { page, sort, direction, tag };

    return `?${queryString.stringify(query)}`;
  }

  render() {
    const { currentUser, groups, total_pages, page } = this.props;
    return (
      <div>
        <div className='row'>
          <div className='col-md-6'>
            <h1>Welcome {currentUser.given_name} {currentUser.family_name}</h1>
          </div>
        </div>
        <br/>
        <div className='list-group-item'>
          <h3>Your Groups</h3>
          <Groups
            location={this.props.location}
            groups={groups}
            total_pages={total_pages}
            page={page} />
            <br/>
          <button className='btn btn-primary'>Edit</button>
        </div>
      </div>
    )
  }
}



const mapStateToProps = (state) => {
  const { currentUser } = state;
  const { groups, total_pages, page } = state.profile;

  return { currentUser, groups, total_pages, page }
};

export default connect(mapStateToProps, { fetchCurrentUserGroups })(Profile);
