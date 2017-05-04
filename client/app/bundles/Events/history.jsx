import { browserHistory } from 'react-router-dom';
import createHistory from 'history/createBrowserHistory';

const history = createHistory({ basename: '/events' });

export default history;
