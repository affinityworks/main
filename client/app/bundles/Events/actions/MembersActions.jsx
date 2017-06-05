import axios from 'axios';

import {
  FETCH_MEMBER,
  FETCH_MEMBERS,
  LOOK_UP_MEMBER,
  FETCH_MEMBERS_EVENTS
} from './types';

import { membersPath } from '../utils/Pathnames';

export const fetchMembers = (queryString = '') => {
  const request = axios.get(`${membersPath()}.json${queryString}`);

  return {
    type: FETCH_MEMBERS,
    payload: request
  };
};

export const fetchMember = (id) => {
  const request = axios.get(`${membersPath()}/${id}.json`);

  return {
    type: FETCH_MEMBER,
    payload: request
  };
};

export const lookUpMember = (email = '') => {
  const request = axios.get(`${membersPath()}.json?email=${email}`);

  return {
    type: LOOK_UP_MEMBER,
    payload: request
  };
};

export const fetchMembersEvents = (id) => {
  const request = axios.get(`${membersPath()}/${id}/events.json`);

  return {
    type: FETCH_MEMBERS_EVENTS,
    payload: request
  };
};
