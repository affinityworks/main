import { browserHistory } from 'react-router-dom';
import createHistory from 'history/createBrowserHistory';

const history = createHistory({ basename: '/' });

export default history;
