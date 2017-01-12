import React from 'react';
import Update from './update';
import style from './updates.scss';

export default function UpdateList(props) {
  const {
    updates,
    sticky,
  } = props;

  const updateItems = (updates) ? updates.map((update, index) => (
    <Update
      key={index}
      update={update}
      sticky={sticky}
    />
  )) : null;

  return (
    <div className="update-list" style={style}>
      {updateItems}
    </div>
  );
}

UpdateList.propTypes = {
  updates: React.PropTypes.arrayOf(React.PropTypes.object),
  sticky: React.PropTypes.bool,
};
