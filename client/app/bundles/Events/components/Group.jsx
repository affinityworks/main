import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import Tags from './Tags';
import { groupPath } from '../utils/Pathnames';

class Group extends Component {
  showAddress() {
    const { location } = this.props.group.attributes;
    if (location) {
      const {locality, region, postal_code} = location;
      return `${locality}, ${region} ${postal_code}`
    }
  }

  showTags() {
    const { tags } = this.props.group.attributes;
    const { id } = this.props.group;

    if (tags)
      return <Tags tags={tags} groupId={id} />
  }

  showOwner() {
    const { creator } = this.props.group.attributes
    if (creator)
      return creator.data.attributes.name;
  }

  render() {
    const { attributes, id } = this.props.group;
    const linkTo = this.props.linkToDashboard ? (groupPath(id) + '/dashboard') : groupPath(id);

    if (!attributes) { return null }

    return (
      <tr>
        <th>
          <Link to={linkTo}>{attributes.name}</Link>
        </th>
        <td>{this.showAddress()}</td>
        <td>{this.showTags()}</td>
        <td>{this.showOwner()}</td>
      </tr>
    );
  }
}

export default Group;
