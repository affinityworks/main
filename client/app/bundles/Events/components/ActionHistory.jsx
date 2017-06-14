import React from 'react';

import ActionHistoryItem from './ActionHistoryItem';

const ActionHistory = ({ attendances }) => {
  if (!attendances)
    return (
      <div>
        <h4>Action History</h4>
        <div> Hasn't rvsp'd any events recently. </div>
      </div>
    )

  return (
    <div>
      <h4>Action History</h4>
      <div
        className='list-group'
        style={{ display: 'block', overflow: 'scroll', maxHeight: '621px'}}>
        {attendances.map(attendance => <ActionHistoryItem key={attendance.id} attendance={attendance}/>)}
      </div>
    </div>
  )
}

export default ActionHistory;
