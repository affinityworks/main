import axios from 'axios';

import {
  FETCH_MEMBERSHIPS
} from './types';

import { membershipPath } from '../utils/Pathnames';

export const fetchMemberships = (queryString = '') => {
  const request = axios.get(`${membershipPath()}.json${queryString}`);

  return {
    type: FETCH_MEMBERSHIPS,
    payload: request
  };
};
