import React, { Component } from 'react';
import axios from 'axios';

import { eventsPath } from '../utils/Pathnames';
import FacebookLink from './FacebookLink';

class AttendanceMatch extends Component {
  constructor(props) {
    super(props);

    const { identifiers } = this.props.match.person.data.attributes;
    const fb_identifier = _.find(identifiers, (identifier) => {
      return identifier.indexOf('facebook') >= 0;
    });

    this.state = { checked: !!fb_identifier };
  }

  handleClick() {
    const { remote_event_id } = this.props;
    const { person, fb_rsvp } = this.props.match;
    const { attributes } = person.data;
    const person_id = person.data.id

    if (this.state.checked) {
      axios.delete(
        `${eventsPath()}/imports/${remote_event_id}/attendances`,
        { params: { person_id } });
    } else {
      const facebook_id = fb_rsvp.id;

      axios.post(`${eventsPath()}/imports/${remote_event_id}/attendances`, { facebook_id, person_id })
    }

    this.setState({ checked: !this.state.checked });
  }

  render() {
    const { checked } = this.state;
    const { fb_rsvp, person } = this.props.match;
    const { attributes } = person.data;

    return (
      <tr>
        <td>{fb_rsvp.name}</td>

        <td style={{ width: '20%' }}>
          <FacebookLink id={fb_rsvp.id} />
        </td>

        <td>
          <i
            onClick={this.handleClick.bind(this)}
            className={`fa fa-check fa-2x check ${checked ? 'check--active' : ''}`}
          />
        </td>

        <td>{`${attributes['name']}`}</td>

        <td>{attributes['primary-email-address']}</td>
      </tr>
    );
  }
}

export default AttendanceMatch;
