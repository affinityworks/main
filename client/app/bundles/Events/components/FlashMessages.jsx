import React, { Component, PropTypes } from 'react';
import CSSTransitionGroup from 'react-transition-group/CSSTransitionGroup';
import update from 'react-addons-update';
import Alert from './Alert';

class FlashMessages extends Component {

  constructor(props) {
    super(props);
    this.state = { messages: props.messages };

    window.flash_messages = this;
  }

  addMessage(message) {
    const messages = update(this.state.messages, { $push: [message] });
    this.setState({ messages: messages });
  }

  removeMessage(message) {
    const index = this.state.messages.indexOf(message);
    const messages = update(this.state.messages, { $splice: [[index, 1]] });
    this.setState({ messages: messages });
  }

  render () {
    const alerts = this.state.messages.map(message => <Alert key={ message.id } message={ message }
      onClose={ () => this.removeMessage(message)} />);

    return(
      <CSSTransitionGroup
        transitionName='alerts'
        transitionEnter={false}
        transitionLeaveTimeout={500}>
        { alerts }
      </CSSTransitionGroup>
    );
  }
}

FlashMessages.propTypes = {
  messages: PropTypes.array.isRequired
};

export default FlashMessages;
