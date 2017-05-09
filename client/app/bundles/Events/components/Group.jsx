import React from 'react';
import { Link } from 'react-router-dom';

const Group = ({ group }) => {
  const { creator } = group;
  const creatorName = creator
    ? `${creator.given_name} ${creator.family_name}`
    : '';

  return (
    <tr>
      <th>
        <Link to={`/groups/${group.id}`}>{group.name}</Link>
      </th>
      <td>Boulder CO</td>
      <td>{group.description}</td>
      <td>Dianna Rands</td>
      <td>{creatorName}</td>
      <td>This is a great group (2017-01-10 by Dianna)</td>
      <td>live</td>
    </tr>
  );
}

export default Group;
