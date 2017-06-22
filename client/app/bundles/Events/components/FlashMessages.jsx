import React, { Component, PropTypes } from 'react';
import CSSTransitionGroup from 'react-transition-group/CSSTransitionGroup';
import { connect } from 'react-redux';
import { removeAlert } from '../actions';

import Alert from './Alert';

class FlashMessages extends Component {

  render () {
    const { removeAlert, alerts } = this.props;

    const alertsComponents = alerts.map(alert => {
      return <Alert key={alert.id} alert={alert} onClose={() => removeAlert(alert)} />
    });

    return(
      <CSSTransitionGroup
        transitionName='alerts'
        transitionEnter={false}
        transitionLeaveTimeout={500}>
        { alertsComponents }
      </CSSTransitionGroup>
    );
  }
}

const mapStateToProps = ({ alerts }) => {
  return { alerts };
}

export default connect(mapStateToProps, { removeAlert })(FlashMessages);
