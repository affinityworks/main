import React from 'react';
import Update from './update';
import style from './updates.scss';

export default function UpdateList(props) {
  let updates = null;

  updates = props.updates.map((update, index) => (
    <Update key={index} update={update} />
  ));

  return (
    <div className="update-list" style={style}>
      {updates}
    </div>
  );
}

UpdateList.propTypes = {
  updates: React.PropTypes.arrayOf(React.PropTypes.object),
};
