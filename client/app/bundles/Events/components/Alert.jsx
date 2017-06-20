  import React, { Component, PropTypes } from 'react';

class Alert extends Component {

  // componentDidMount() {
  //   this.timer = setTimeout(
  //     this.props.onClose,
  //     // this.props.timeout
  //   );
  // }

  // componentWillUnmount() {
  //   clearTimeout(this.timer);
  // }

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
    const message = this.props.message;
    const alertClassName = `alert ${ this.alertClass(message.type) } fade in`;
    console.log('message', message)

    return(
      <div className={ alertClassName }>
        <button className='close'
          onClick={ this.props.onClose }>
          &times;
        </button>
        { message.text }
      </div>
    );
  }
}

Alert.propTypes = {
  onClose: PropTypes.func,
  // timeout: PropTypes.number,
  message: PropTypes.object.isRequired
};

// Alert.defaultProps = {
//   timeout: 3000
// };

export default Alert;
