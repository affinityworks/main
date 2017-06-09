export const affiliatesPath = (id = null) => (`/groups/${id || groupId()}/affiliates`);
export const membersPath = () => (`/groups/${groupId()}/members`);
export const membershipPath = () => (`/groups/${groupId()}/memberships`);
export const eventsPath = () => (`/groups/${groupId()}/events`);
export const attendancesPath = (eventId) => (`/groups/${groupId()}/events/${eventId}/attendances`);
export const groupsPath = () => (`/groups/${groupId()}/dashboard`)
export const dashboardPath = (id = null) => (`/groups/${id || groupId()}/dashboard`)
export const groupPath = (id) => (`/groups/${id}`)
export const eventWithoutGroupPath = (id) => (`/events/${id}`)
export const membershipWithoutGroupPath = (id) => (`/memberships/${id}`);

export const groupId = () => {
  return window.location.href.match(/groups\/(\d+)/)[1];
}
