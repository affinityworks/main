import React, { Component } from 'react';
import { connect} from 'react-redux';

import MemberForm from './MemberForm';
import Event from '../components/Event';
import { fetchEvent } from '../actions';

class NewMember extends Component {
  componentWillMount() {
    this.props.fetchEvent(this.props.match.params.id);
  }

  handleSubmit(e) {
    e.preventDefault();

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
        <MemberForm onSubmit={this.handleSubmit} />
        <br/>
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { event } = state;
  return { event }
}

export default connect(mapStateToProps, { fetchEvent })(NewMember);
