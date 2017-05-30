import React, { Component } from 'react';

import Nav from '../components/Nav';
import AttendanceMatch from '../components/AttendanceMatch';

class AttendanceMatching extends Component {
  renderRows() {
    return [...Array(10)].map((_, i) => (
      <AttendanceMatch key={i} />
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
              <th colSpan='2'>Affinity RSVPS</th>
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
