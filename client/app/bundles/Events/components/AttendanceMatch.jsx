import React, { Component } from 'react';

class AttendanceMatch extends Component {
  constructor(props) {
    super(props);
    this.state = { checked: false };
  }

  handleClick() {
    this.setState({ checked: !this.state.checked });
  }

  render() {
    const { checked } = this.state;

    return (
      <tr>
        <td>Julie Smith</td>

        <td style={{ width: '20%' }}>
          <i className='fa fa-facebook-official fa-2x' style={{ color: '#3b5998' }} />
        </td>

        <td>
          <i
            onClick={this.handleClick.bind(this)}
            className={`fa fa-check fa-2x check ${checked ? 'check--active' : ''}`}
          />
        </td>

        <td>Julie Smith</td>

        <td>jsmit@gmail.com</td>
      </tr>
    );
  }
}

export default AttendanceMatch;
