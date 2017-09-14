export const affiliatesPath = (id = null) => (`/groups/${id || groupId()}/affiliates`);
export const eventsPath = () => (`/groups/${groupId()}/events`);
export const eventPath = (eventId) => (`/groups/${groupId()}/events/${eventId}`);
export const attendancesPath = (eventId) => (`/groups/${groupId()}/events/${eventId}/attendances`);
export const groupsPath = () => (`/groups/${groupId()}/dashboard`)
export const dashboardPath = (id = null) => (`/groups/${id || groupId()}/dashboard`)
export const groupPath = (id = null) => (`/groups/${id || groupId()}`)
export const eventWithoutGroupPath = (id) => (`/events/${id}`)
export const membershipWithoutGroupPath = (id) => (`/memberships/${id}`);

export const membersPath = (id = null) => {
  if (id == null) {
    return (`/groups/${groupId()}/members`);
  }
  else  {
   return (`/groups/${id}/members`);
  }
}

export const groupId = () => {
  //if (window.location.href.match(/groups\/(\d+)/)) {
    return window.location.href.match(/groups\/(\d+)/)[1];
  //}
  //else {
  //  return null;
  //}
  
}


export const membershipPath = () => {

  if (groupId() != null ) {
    return (`/groups/${groupId()}/memberships`);
  }
  else {
   return (`/memberships`);
  }
}



