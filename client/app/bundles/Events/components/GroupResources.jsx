import React from 'react';
import UserAuth from '../components/UserAuth';
import FeatureToggle from '../components/FeatureToggle';

const GroupResources = ({toggles, resources}) => (
  <div>
    <h4>Resources</h4>
    {
      EmptyListOf(resources) ||
      <ul>
        {resources.map((resource, i) => GroupResource({key: i, resource, toggles}))}
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

const GroupResource = ({key, resource, toggles}) => {
  if(resource.auth_link && resource.link){
    return <UserAuth {...{key, allowed: ['organizer']}}>
            <li {...{key}}>
              {resource.description}: <a href={resource.link}>{resource.link}</a> 
            </li>
          </UserAuth>
  } 
  else if(resource.link) {
    return <li {...{key}}> {resource.description}: <a href={resource.link}>{resource.link}</a> </li>
  }
  else if(resource.mailto) {
    return <FeatureToggle {...{key, on: toggles.email_google_group}}>
            <li {...{key}}> {resource.description}: <a href={`mailto:${resource.mailto}`} target="_blank">{resource.mailto}</a> </li>
           </FeatureToggle>
  }
};

export default GroupResources;
