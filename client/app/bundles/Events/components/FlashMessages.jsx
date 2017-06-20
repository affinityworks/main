import React, { Component, PropTypes } from 'react';
import CSSTransitionGroup from 'react-transition-group/CSSTransitionGroup';
import update from 'react-addons-update';
import { connect } from 'react-redux';

import Alert from './Alert';

class FlashMessages extends Component {

  // constructor(props) {
  //   super(props);
  //   this.state = { messages: props.messages };
  //
  //   window.flash_messages = this;
  // }
  //
  // addMessage(message) {
  //   const messages = update(this.state.messages, { $push: [message] });
  //   this.setState({ messages: messages });
  // }
  //
  // removeMessage(message) {
  //   const index = this.state.messages.indexOf(message);
  //   const messages = update(this.state.messages, { $splice: [[index, 1]] });
  //   this.setState({ messages: messages });
  // }

  render () {
    console.log('walalalalala');
    const alerts = this.props.alerts.map(alert => <Alert key={ alert.id } alert={ alert } />);

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

const mapStateToProps = ({ alerts }) => {
  return { alerts };
}

export default connect(mapStateToProps)(FlashMessages);
