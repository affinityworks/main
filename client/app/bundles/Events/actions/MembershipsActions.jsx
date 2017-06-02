import axios from 'axios';

import {
  FETCH_MEMBERSHIPS
} from './types';

export const fetchMemberships = (queryString = '') => {
  const request = axios.get(`/memberships.json${queryString}`);

  return {
    type: FETCH_MEMBERSHIPS,
    payload: request
  };
};
