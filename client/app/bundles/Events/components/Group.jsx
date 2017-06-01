import React, { Component } from 'react';
import { Link } from 'react-router-dom';

class Group extends Component {

  showAddress() {
    const { location } = this.props.group.attributes;
    if (location) {
      const {locality, region, postal_code} = location;
      return `${locality}, ${region} ${postal_code}`
    }
  }

  showTags() {
    const tags = this.props.group.attributes['tag-list'];
    if (tags)
      return tags.join(', ');
  }

  showOwner() {
    const { creator } = this.props.group.attributes
    if (creator)
      return creator.data.attributes.name;
  }

  render() {
    const { attributes, id } = this.props.group;

    if (!attributes) { return null }

    return (
      <tr>
        <th>
          <Link to={`/groups/${id}`}>{attributes.name}</Link>
        </th>
        <td>{this.showAddress()}</td>
        <td>{this.showTags()}</td>
        <td>{this.showOwner()}</td>
      </tr>
    );
  }
}

export default Group;
