export const affiliatesPath = () => (`/groups/${groupId()}/affiliates`);
export const membersPath = () => (`/groups/${groupId()}/members`);
export const eventsPath = () => (`/groups/${groupId()}/events`);
export const attendancesPath = (eventId) => (`/groups/${groupId()}/events/${eventId}/attendances`);
export const groupsPath = () => (`/groups/${groupId()}/dashboard`)

export const groupId = () => {
  return window.location.href.match(/groups\/(\d+)/)[1];
}
