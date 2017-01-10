import React from 'react';
import UpdateList from '../components/updates/update-list';

import style from './group.scss';

export default function Group(props) {
  const {
      name,
      updates,
      // members,
      // events,
      // tags,
      // nearby,
      // loading,
  } = props.group;

  return (
    <div style={style}>
      <div className="group-title">{name}</div>
      <UpdateList updates={updates.sticky} />
    </div>
  );
}

Group.propTypes = {
  group: React.PropTypes.object,
  name: React.PropTypes.string,
  updates: React.PropTypes.object,
};
