import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import { formatDay, formatTime, membersPath } from '../utils';

class PersonActivityFeed extends Component {
  renderPerson(person) {
    const { type } = this.props;
    const { timestamp, whodunnit } = person;

    return (
      <div href="#" key={person.version_id} className="list-group-item list-group-item-action flex-column align-items-start">
        <div className="d-flex w-100 justify-content-between">
          <h5 className="mb-1">{person.name}</h5>
          <small>{formatDay(timestamp)} {formatTime(timestamp)}</small>
        </div>
        <div>{person.changed_fields.join(', ')}</div>
        { whodunnit && <small> by {whodunnit} </small>}
        <small>{type}</small>
      </div>
    )
  }

  render() {
    const { people } = this.props;
    return (
      <div style={{marginBottom: '-1px' }}>
        {people.map(this.renderPerson.bind(this))}
      </div>
    );
  }
}

export default PersonActivityFeed;
