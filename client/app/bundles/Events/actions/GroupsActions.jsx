import axios from 'axios';

import {
  FETCH_GROUPS
} from './types';

export const fetchGroups = (queryString = '') => {
  const request = axios.get(`/groups.json${queryString}`);

  return {
    type: FETCH_GROUPS,
    payload: request
  };
};
