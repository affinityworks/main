import queryString from 'query-string';

export const addParamToQuery = (query, newParams) => {
  const params = queryString.parse(query);

  return '?' + queryString.stringify({ ...params, ...newParams })
};

export const removeParamFromQuery = (query, param) => {
  const params = queryString.parse(query);
  delete params[param];

  return '?' + queryString.stringify(params);
}
