import React, { Component } from 'react';

import Nav from '../components/Nav';

class AttendanceMatching extends Component {
  renderRows() {
    return [...Array(10)].map((_, i) => (
      <tr key={i}>
        <td>Julie Smith</td>
        <td style={{ width: '20%' }}>
          <i className='fa fa-facebook-official fa-2x' style={{ color: '#3b5998' }} />
        </td>
        <td>
          <i className='fa fa-check fa-2x' style={{ cursor: 'pointer', textShadow: '0 0 1px black', color: 'white' }}/>
        </td>
        <td>Julie Smith</td>
        <td>jsmit@gmail.com</td>
        <td style={{ width: '50px' }}>Y</td>
      </tr>
    ));
  }

  render() {
    return (
      <div>
        <Nav activeTab='events'/>

        <h2>Match Event Participants</h2>

        <br/>

        <table className='table'>
          <thead>
            <tr>
              <th colSpan='3'>Facebook Event RSVPS</th>
              <th colSpan='3'>Affinity RSVPS</th>
            </tr>
          </thead>

          <tbody>
            {this.renderRows()}
          </tbody>
        </table>
      </div>
    );
  }
}

export default AttendanceMatching;
