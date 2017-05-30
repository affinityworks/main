import React, { Component } from 'react';
import axios from 'axios';

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
    let identifiers;

    const { person, fb_rsvp } = this.props.match;
    const { attributes } = person.data;
    const facebook_id = fb_rsvp.id;

    if (this.state.checked) {
      identifiers = _.reject(attributes.identifiers, (identifier) => {
        return identifier.indexOf('facebook') >= 0;
      });
    } else {
      identifiers = attributes.identifiers.concat(`facebook:${facebook_id}`);
    }

    this.setState({ checked: !this.state.checked });
    axios.put(`/members/${attributes.id}.json`, { member: { identifiers }});
  }

  render() {
    const { checked } = this.state;
    const { fb_rsvp, person } = this.props.match;
    const { attributes } = person.data;

    return (
      <tr>
        <td>{fb_rsvp.name}</td>

        <td style={{ width: '20%' }}>
          <a href={`https://facebook.com/${fb_rsvp.id}`} target='_blank'>
            <i className='fa fa-facebook-official fa-2x' style={{ color: '#3b5998' }} />
          </a>
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
