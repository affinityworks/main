import React from 'react';

export default function Update(props) {
  const {
    title,
    content,
    date,
  } = props.update;

  const updateDate = (!props.sticky) ? (
    <div className="update-date">{date}</div>
  ) : null;

  return (
    <div className="update">
      {updateDate}
      <span className="update-title">{title}</span>
      <div className="update-content">
        {content}
      </div>
    </div>
  );
}

Update.propTypes = {
  update: React.PropTypes.shape({
    title: React.PropTypes.string,
    content: React.PropTypes.string,
  }),
  sticky: React.PropTypes.bool,
};
