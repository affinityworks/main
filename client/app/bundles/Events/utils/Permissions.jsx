import { groupId } from './Pathnames';

export const managingCurrentGroupWithAffiliates = (currentGroup) => {
  return currentGroup.id == groupId() && currentGroup.has_affiliates;
}

export const isAllowed = (role, currentRole) => {
  return role.indexOf(currentRole) >= 0;
}
