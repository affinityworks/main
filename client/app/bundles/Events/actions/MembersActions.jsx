import axios from 'axios';

import {
  FETCH_MEMBER,
  FETCH_MEMBERS,
  CREATE_MEMBER,
  LOOK_UP_MEMBER,
  SET_MEMBER_ATTRIBUTE
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

export const createMember = (attributes) => {
  const request = axios.post('/members.json', { member: attributes });

  return {
    type: CREATE_MEMBER,
    payload: request
  };
};

export const lookUpMember = (email = '') => {
  const request = axios.get(`/members.json?email=${email}`);

  return {
    type: LOOK_UP_MEMBER,
    payload: request
  };
};

export const setMemberAttribute = (prop, value) => (
  {
    type: SET_MEMBER_ATTRIBUTE,
    payload: { prop, value }
  }
);
