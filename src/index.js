import './main.css';
import './style.css';
import { Elm } from './Main.elm';
import * as serviceWorker from './serviceWorker';

let app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: Date.now()
});

app.ports.record.subscribe(
  (data) => {
    localStorage.setItem(`${data.title}.log`, JSON.stringify(data.body));
  }
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
