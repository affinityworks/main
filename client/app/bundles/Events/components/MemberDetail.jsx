import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import Nav from './Nav';
import axios from 'axios';
import Event from './Event';
import { fetchMember, fetchMembersEvents } from '../actions';
import { membersPath } from '../utils/Pathnames';

class MemberDetail extends Component {
  componentWillMount() {
    const { id } = this.props.match.params;
    this.props.fetchMember(id)
    this.props.fetchMembersEvents(id)
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
    const { member } = this.props;

    if (!member.attributes)
      return null;

    const { attributes } = member;
    return (
      <div>
        <Nav activeTab='members'/>
        <h1>{`${attributes['given-name']} ${attributes['family-name']} `}</h1>
        <br/>
        <h2> Events attended </h2>
        <br/>
        <div className='list-group'>
        </div>
        <br />
        {this.renderPagination()}
        <br />
        <Link to={membersPath()}>
          <button className='btn btn-primary'>Back to Members</button>
        </Link>
      </div>
    );
  }
}

const mapStateToProps = ({ member }) => {
  return { member }
};


export default connect(mapStateToProps, { fetchMember, fetchMembersEvents })(MemberDetail);
