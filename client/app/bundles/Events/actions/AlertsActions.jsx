import { ADD_ALERT, REMOVE_ALERT } from './types';

export const addAlert = (alert) => {
  console.error(alert);
  return {
    type: ADD_ALERT,
    payload: alert
  };
}

export const removeAlert = (alert) => {
  return {
    type: REMOVE_ALERT,
    payload: alert
  };
}
