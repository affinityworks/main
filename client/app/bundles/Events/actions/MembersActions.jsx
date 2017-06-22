import axios from 'axios';

import {
  FETCH_MEMBER,
  FETCH_MEMBERS,
  LOOK_UP_MEMBER,
  LOOK_UP_MEMBER_START,
  FETCH_MEMBERS_EVENTS
} from './types';

import { membersPath } from '../utils/Pathnames';
import { addAlert } from '../actions';

export const fetchMembers = (queryString = '') => {
  return (dispatch) => {
    axios.get(`${membersPath()}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_MEMBERS,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};

export const fetchMember = (id) => {
  return (dispatch) => {
    axios.get(`${membersPath()}/${id}.json`)
      .then(response => {
        dispatch({
          type: FETCH_MEMBER,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};

export const lookUpMember = (email = '') => {
  return (dispatch) => {
    dispatch({ type: LOOK_UP_MEMBER_START })
    axios.get(`${membersPath()}.json?email=${email}`)
      .then(response => {
        dispatch({ type: LOOK_UP_MEMBER, payload: response });
      });
  }

};

export const fetchMembersEvents = (id) => {
  return (dispatch) => {
    axios.get(`${membersPath()}/${id}/events.json`)
      .then(response => {
        dispatch({
          type: FETCH_MEMBERS_EVENTS,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};
