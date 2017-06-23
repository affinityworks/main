import axios from 'axios';

import { groupPath} from '.';
import history from '../history';

const client = axios.create();

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
