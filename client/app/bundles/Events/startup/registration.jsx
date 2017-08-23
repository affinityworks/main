import ReactOnRails from 'react-on-rails';

import App from '../components/App';
import FlashMessages from '../components/FlashMessages';
import ReactGA from 'react-ga';
ReactGA.initialize('UA-104927056-1'); //Unique Google Analytics tracking number

ReactOnRails.register({
  App,
  FlashMessages
});
