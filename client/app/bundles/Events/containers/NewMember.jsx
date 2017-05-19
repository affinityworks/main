import React, { Component } from 'react';
import { connect} from 'react-redux';

import MemberForm from './MemberForm';
import Event from '../components/Event';
import { fetchEvent, createMember } from '../actions';

class NewMember extends Component {
  componentWillMount() {
    this.props.fetchEvent(this.props.match.params.id);
  }

  handleSubmit(e) {
    e.preventDefault();

    const { newMember, createMember } = this.props;

    const attributes = { //NOTE: ROAR MAKES THIS OVER COMPLICATED
      family_name: newMember['family-name'],
      given_name: newMember['given-name'],
      email: newMember['primary-email-address'],
      primary_phone_number: newMember['primary-phone-number'],
    }

    createMember(attributes);
  }

  renderEvent() {
    if (this.props.event.attributes)
      return <Event event={this.props.event} />
  }

  render() {
    return (
      <div>
        {this.renderEvent()}
        <br/>
        <h3> Add New Event Attendee </h3>
        <br/>
        <MemberForm onSubmit={this.handleSubmit.bind(this)} />
        <br/>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { event, newMember } = state;
  return { event, newMember }
}

export default connect(mapStateToProps, { fetchEvent, createMember })(NewMember);
