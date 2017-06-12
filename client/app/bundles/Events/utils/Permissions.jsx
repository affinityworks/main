import { groupId } from './Pathnames';

export const managingCurrentGroupWithAffiliates = (currentGroup) => {
  return currentGroup.id == groupId() && currentGroup.has_affiliates;
}
