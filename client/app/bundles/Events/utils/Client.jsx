import axios from 'axios';

import { groupPath} from '.';
import history from '../history';

const client = axios.create();

// TODO (aguestuser|Thu 24 May 2018):
// - we are currently exposed to CSRF attacks on members and memberhips routes (maybe more?)
// - fix:  in *every* requrest retrieve CSRF tokenand include it in a custom header w/ something like:
//   'X-CSRF-Token': $("meta[name='csrf-token']").attr("content")

client.interceptors.response.use(response => {
  return response;
}, function(error) {
  const { response } = error;
  const type = 'error';
  let text;

  switch (response.status) {
  case 401:
    window.location.replace('/admin/login')
    break;
  case 403:
    text = 'You didn\'t have permissions to access that page.';

    history.push(groupPath());
    break;
  case 500:
    text = 'An error ocurred, please try again later.';
    break;
  default:
    text = response.data.join(', ');
  }

  return Promise.reject({ type, text });
});

export { client };
