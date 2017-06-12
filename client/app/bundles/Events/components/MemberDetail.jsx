import axios from 'axios';
import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import Nav from './Nav';
import Event from './Event';
import { fetchMember, fetchMembersEvents } from '../actions';
import { membersPath } from '../utils/Pathnames';
import EmailLink from './EmailLink';
import UpcomingEvent from './UpcomingEvent';

class MemberDetail extends Component {
  state = { attendances: [] }

  componentWillMount() {
    const { id } = this.props.match.params;
    this.props.fetchMember(id)
    this.props.fetchMembersEvents(id)
    this.fetchAttendances(id);
  }

  fetchAttendances(id) {
    axios.get(`${id}/attendances.json`)
      .then(response => this.setState({ attendances: response.data.data }));
  }

  showAttendances() {
    const { attendances } = this.state;

    if (!attendances.length) {
      return (
        <div> Hasn't rvsp'd any events recently. </div>
      );
    }

    return (
      attendances.map(attendance => {
        return (
          <UpcomingEvent key={attendance.id} event={attendance.attributes.event.data} />
        );
      })
    );
  }

  render() {
    console.log(this.state.attendances);
    const { member } = this.props;

    if (!member.attributes)
      return null;

    const { attributes } = member;
    return (
      <div>
        <Nav activeTab='members'/>

        <br />

        <div className='row container'>
          <h1>{`${attributes['given-name']} ${attributes['family-name']} `}</h1>
          <EmailLink
            email={attributes['primary-email-address']}
            style={{ marginLeft: '14px', alignSelf: 'center' }}
          />
        </div>

        <div> {attributes['primary-phone-number']} </div>

        <br/>

        <h4> RVSP'd events </h4>
        {this.showAttendances()}

        <br/>

        <Link to={membersPath()}>
          <button className='btn btn-primary'>Back to Members</button>
        </Link>

        <br/>
      </div>
    );
  }
}

const mapStateToProps = ({ member }) => {
  return { member }
};


export default connect(mapStateToProps, { fetchMember, fetchMembersEvents })(MemberDetail);
