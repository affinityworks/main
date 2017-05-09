import axios from 'axios';

import {
  FETCH_GROUPS
} from './types';

export const fetchGroups = () => {
  const request = axios.get(`/groups.json`);

  return {
    type: FETCH_GROUPS,
    payload: request
  };
};
