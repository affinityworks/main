import React from 'react';

export default function Update(props) {
  const {
    title,
    content,
  } = props.update;

  return (
    <div className="update">
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
};
