import axios from 'axios';

import {
  FETCH_CURRENT_USER_GROUPS
} from './types';

export const fetchCurrentUserGroups = (queryString = '') => {
  const request = axios.get(`/profile/groups.json${queryString}`);

  return {
    type: FETCH_CURRENT_USER_GROUPS,
    payload: request
  };
};
