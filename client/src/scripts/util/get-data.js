export default function getData(url) {
  return fetch(url)
    .then(response => response.json())
    .then(responseJson => responseJson)
    .catch(error => (error));
}
