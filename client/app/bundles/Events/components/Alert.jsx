  import React, { Component, PropTypes } from 'react';

class Alert extends Component {

  componentDidMount() {
    this.timer = setTimeout(
      this.props.onClose,
      this.props.timeout
    );
  }

  componentWillUnmount() {
    clearTimeout(this.timer);
  }

  alertClass (type) {
    let classes = {
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info',
      success: 'alert-success'
    };
    return classes[type] || classes.success;
  }

  render() {
    const alert = this.props.alert;
    const alertClassName = `alert ${ this.alertClass(alert.type) } fade-in`;

    return(
      <div className={ alertClassName }>
        <button className='close'
          onClick={ this.props.onClose }>
          &times;
        </button>
        { alert.text }
      </div>
    );
  }
}

Alert.defaultProps = {
  timeout: 3000
};

export default Alert;
