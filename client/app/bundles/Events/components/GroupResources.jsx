import React from 'react';
import UserAuth from '../components/UserAuth';

const GroupResources = ({resources}) => (
  <div>
    <h4>Resources</h4>
    {
      EmptyListOf(resources) ||
      <ul>
        {resources.map(GroupResource)}
      </ul>
    }
  </div>
);

// return placeholder if all resources have no links
const EmptyListOf = (resources) => (
  resources.every(r => !Boolean(r.link)) ?
    <div style={{color: 'lightgray'}}>
      This group has no resources
    </div> :
    null
);

const GroupResource = (r) => {
  if(r.auth_link){
    return <UserAuth allowed={['organizer']}><li> {r.description}: <a href={r.link}>{r.link}</a> </li></UserAuth>
  } 
  else if(r.link) {
    return <li> {r.description}: <a href={r.link}>{r.link}</a> </li>
  }
  else if(r.mailto) {
    return <li> {r.description}: <a href={`mailto:${r.mailto}`} target="_blank">{r.mailto}</a> </li>
  }
};

export default GroupResources;
