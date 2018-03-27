import React, { Component } from 'react';
import { Link } from 'react-router-dom';

import Tags from './Tags';
import { groupPath } from '../utils';
import UserAuth from '../components/UserAuth';

class Group extends Component {
  showAddress() {
    const { location } = this.props.group.attributes;
    if (location) {
      return ['locality', 'region', 'postal_code']
        .map(attr => location[attr])
        .filter(Boolean) // filter falsey values
        .join(", ");
    }
  }

  showTags() {
    const { tags } = this.props.group.attributes;
    const { id } = this.props.group;

    return (
      <td>
        <UserAuth allowed={['organizer']}>
          { tags ? <Tags tags={tags} groupId={id} /> : '' }
        </UserAuth>
      </td>
    )
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
        {this.showTags()}
        <td>{this.showOwner()}</td>
      </tr>
    );
  }
}

export default Group;
