import React, { Component } from 'react';

import { formatDateTime } from '../utils';

class PersonActivityFeed extends Component {
  render() {
    const { people, type } = this.props;
    return (
      <div>
        {people.map(person => {
          return (<div key={person.version_id}>
            <div>{`Change type: ${type}`}</div>
            <div>{`Date: ${formatDateTime(person.timestamp)}`}</div>
            <div>{`Name: ${person.name}`}</div>
            <div>{`Fields: ${person.changed_fields.join(', ')}`}</div>
            {person.whodunnit && <div>{`Author: ${person.whodunnit}`}</div>}
          </div>);
        })}
      </div>
    );
  }
}

export default PersonActivityFeed;
