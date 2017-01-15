import React from 'react';

import style from './related.scss';

export default function Related(props) {
  return (
    <div className="related" style={style}>
      <h4>{props.title}</h4>
      {props.children}
    </div>
  );
}

Related.propTypes = {
  title: React.PropTypes.string,
  children: React.PropTypes.oneOfType([
    React.PropTypes.arrayOf(React.PropTypes.node),
    React.PropTypes.node,
  ]),
};
