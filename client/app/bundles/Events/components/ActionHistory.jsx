import React from 'react';

import ActionHistoryItem from './ActionHistoryItem';

const ActionHistory = ({ attendances }) => {
  if (!attendances)
    return (
      <div>
        <h4> Action History </h4>
        <div> Hasn't rvsp'd any events recently. </div>
      </div>
    )

  let attendedCount = 0;
  let missedCount = 0;

  attendances.forEach(attendance => {
    const { attended } = attendance.attributes;

    if (attended === false)
      missedCount += 1;

    if (attended)
      attendedCount += 1;
  });

  return (
    <div>
      <h4>Action History</h4>
      <div className='row container' style={{ justifyContent: 'center' }}>
        <div className='action-history-circle action-history-circle--attended'>
          <div style={{ fontSize: '22px' }}>{attendedCount}</div>
          <div>Attended</div>
        </div>

        <div className='action-history-circle action-history-circle--missed'>
          <div style={{ fontSize: '22px' }}>{missedCount}</div>
          <div>Missed</div>
        </div>
      </div>
      <div
        className='list-group'
        style={{ display: 'block', overflow: 'scroll', maxHeight: '621px'}}>
        {attendances.map(attendance => <ActionHistoryItem key={attendance.id} attendance={attendance}/>)}
      </div>
    </div>
  )
}

export default ActionHistory;
