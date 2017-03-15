import React, { PropTypes } from 'react';

export default class Event extends React.Component {
  constructor(props, _railsContext) {
    super(props);
    this.state = {...props};
  }

  render() {
    return (
    <tr>
      <td><a href="" data-toggle="modal" data-target="#event_add-modal">{this.state.title}</a></td>
      <td>group</td>
      <td>formatDate date "%m/%d/%Y" start_time </td>
      <td>status</td>
      <td>stats.invited_count</td>
      <td>stats.rsvp_count</td>
      <td>stats.attended_count</td>
      <td><a href="" className="event_list-toggle"> <i className="fa fa-users"></i> View Participants</a></td>
    </tr>
    );
  }
}
