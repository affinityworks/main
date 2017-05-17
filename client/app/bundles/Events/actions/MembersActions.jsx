import axios from 'axios';

import {
  FETCH_MEMBER,
  FETCH_MEMBERS
} from './types';

export const fetchMembers = (queryString = '') => {
  const request = axios.get(`/members.json${queryString}`);

  return {
    type: FETCH_MEMBERS,
    payload: request
  };
};

export const fetchMember = (id) => {
  const request = axios.get(`/members/${id}.json`);

  return {
    type: FETCH_MEMBER,
    payload: request
  };
};
