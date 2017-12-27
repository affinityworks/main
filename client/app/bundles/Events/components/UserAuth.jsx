import React, { PropTypes, Component } from 'react';
import { connect } from 'react-redux';

class UserAuth extends Component {
  render() {
    const {
      currentRole,
      allowed,
      children 
    } = this.props

    return allowed.indexOf(currentRole) >= 0 ? children : null
  }
}

const mapStateToProps = ({ currentRole }) => {
  return { currentRole }
};

export default connect(mapStateToProps)(UserAuth);