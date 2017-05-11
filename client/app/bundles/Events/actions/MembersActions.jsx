import axios from 'axios';

import {
  FETCH_MEMBERS
} from './types';

export const fetchMembers = (queryString = '') => {
  const request = axios.get(`/members.json${queryString}`);

  return {
    type: FETCH_MEMBERS,
    payload: request
  };
};
