import React from 'react';
import ReactDOM from 'react-dom';

import { BrowserRouter, Route } from 'react-router-dom'

import Application from './components/Application/Application.jsx';
import LoginPanel from './components/LoginPanel/LoginPanel.jsx';
import AuthorProfile from './components/AuthorProfile/AuthorProfile.jsx';

import Promise from 'promise-polyfill';
import 'whatwg-fetch'

ReactDOM.render((
  <BrowserRouter>
    <div className="container h-100">
      <Route path="/" exact component={Application} />
      <Route path="/login" component={LoginPanel} />
      <Route path="/author/:author_id" component={AuthorProfile} />
    </div>
  </BrowserRouter>
), document.getElementById('app'));
