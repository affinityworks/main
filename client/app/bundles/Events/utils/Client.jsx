import axios from 'axios';

const client = axios.create()

client.interceptors.response.use(response => {
  return response;
}, function(error) {
  const { response } = error;

  if (response.status === 401)
    window.location.replace('/admin/login')

  const text = response.status != 500 ? response.data.join(', ') : null;
  const type = 'error';

  return Promise.reject(error, { text, type });
});

export { client };
