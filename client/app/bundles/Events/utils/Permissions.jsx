import { groupId } from './Pathnames';

export const isNationalOrgnizer = (role) => (role === 'national_organizer')

export const managingCurrentGroup = (currentGroup) => {
  return currentGroup.id == groupId()
}
