import React, { Component } from 'react';
import _ from 'lodash';

class CustomFields extends Component {
  displayFields () {
    const fields = this.props.customFields
    return _.map(fields, (value, key) => {
      return (
        <li key={key} style={{ listStyle: 'none' }}>{key}: {value}</li>
      )
    })
  }

  render () {
    return (
      <ul style={{ padding: '0' }}>{this.displayFields()}</ul>
    );
  }
}

export default CustomFields;


