import React, { PropTypes } from 'react';

export default class Event extends React.Component {
  constructor(props, _railsContext) {
    super(props);
    this.state = {...props};
  }

  render() {
    return (
      <div>
        Event {this.state.title}
      </div>
    );
  }
}
