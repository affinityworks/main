import React, { Component } from 'react';
import { connect } from 'react-redux';
import queryString from 'query-string';

import GroupsList from '../components/Groups';
import Nav from '../components/Nav';
import Breadcrumbs from '../components/Breadcrumbs';
import { fetchAffiliates } from '../actions';

class Groups extends Component {
  componentWillMount() {
    this.props.fetchAffiliates(this.buildQuery(this.props));
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchAffiliates(this.buildQuery(nextProps));
  }

  buildQuery(props) {
    const { page, sort, direction, tag } = queryString.parse(props.location.search);
    const query = { page, sort, direction, tag };

    return `?${queryString.stringify(query)}`;
  }

  render() {
    const { currentGroup, affiliates, total_pages, page } = this.props;

    return (
      <div>
        <Breadcrumbs active='All Groups' location={this.props.location} />

        <br/>

        <Nav activeTab='groups' />

        <GroupsList
          location={this.props.location}
          groups={affiliates}
          total_pages={total_pages}
          page={page} />

      <div>
        <a href="edit">
          <button className='btn btn-primary'>Edit</button>
        </a>
      </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { affiliates, total_pages, page } = state.affiliates;

  return { affiliates, total_pages, page }
};

export default connect(mapStateToProps, { fetchAffiliates })(Groups);
