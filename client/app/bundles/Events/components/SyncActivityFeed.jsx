import React, { Component } from 'react';

import { formatDay, formatTime } from '../utils';

class SyncActivityFeed extends Component {

  renderItem(type) {
    const { created, updated, errors } = this.props.sync.data[type];

    return (
      <div className='list-group-item list-group-item-action' key={type}>
        <h5 style={{marginRight: '10px', textTransform: 'capitalize'}}>{type}</h5>
        <div className='badge badge-success' style={{marginRight: '10px', marginBottom: '6px'}}>{`${created} Created`}</div>
        <div className='badge badge-warning' style={{marginRight: '10px', marginBottom: '6px'}}>{`${updated} Updated`}</div>
        <div className='badge badge-danger' style={{marginRight: '10px', marginBottom: '6px'}}>{`${errors} Errors`}</div>
      </div>
    )
  }

  render() {
    const { created_at, data } = this.props.sync;

    return (
      <div>
        <h3>Last Synchronization (<small>{formatDay(created_at)} {formatTime(created_at)}</small>)</h3>
        <br />
        <div className='list-group'>
          {Object.keys(data).map(this.renderItem.bind(this))}
        </div>
        <br />
      </div>
    );
  }
}

export default SyncActivityFeed;
