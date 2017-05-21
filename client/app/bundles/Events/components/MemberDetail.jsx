import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import { fetchMember } from '../actions';

class MemberDetail extends Component {
  componentWillMount() {
    const { id } = this.props.match.params;
    this.props.fetchMember(id)
  }

  render() {
    const { member } = this.props;

    if (!member.attributes)
      return null;

    const { attributes } = member;
    return (
      <div>
        <h1>{`${attributes['given-name']} ${attributes['family-name']} `}</h1>
        <br/>
        <h2> Events attended </h2>
        <br/>
        <Link to='/members'>
          <button className='btn btn-primary'>Back to Members</button>
        </Link>
      </div>
    );
  }
}

const mapStateToProps = ({ member }) => {
  return { member }
};

export default connect(mapStateToProps, { fetchMember })(MemberDetail);
