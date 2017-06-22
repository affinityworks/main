import {
  FETCH_MEMBER,
  FETCH_MEMBERS,
  LOOK_UP_MEMBER,
  LOOK_UP_MEMBER_START,
  FETCH_MEMBERS_EVENTS
} from './types';

import { membersPath, client } from '../utils';
import { addAlert } from '../actions';

export const fetchMembers = (queryString = '') => {
  return (dispatch) => {
    client.get(`${membersPath()}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_MEMBERS,
          payload: response
        });
      }).catch(alert => {
        dispatch(addAlert(alert));
      });
  }
};

export const fetchMember = (id) => {
  return (dispatch) => {
    client.get(`${membersPath()}/${id}.json`)
      .then(response => {
        dispatch({
          type: FETCH_MEMBER,
          payload: response
        });
      }).catch(alert => {
        dispatch(addAlert(alert));
      });
  }
};

export const lookUpMember = (email = '') => {
  return (dispatch) => {
    dispatch({ type: LOOK_UP_MEMBER_START })
    client.get(`${membersPath()}.json?email=${email}`)
      .then(response => {
        dispatch({ type: LOOK_UP_MEMBER, payload: response });
      });
  }

};

export const fetchMembersEvents = (id) => {
  return (dispatch) => {
    client.get(`${membersPath()}/${id}/events.json`)
      .then(response => {
        dispatch({
          type: FETCH_MEMBERS_EVENTS,
          payload: response
        });
      }).catch(alert => {
        dispatch(addAlert(alert));
      });
  }
};
