import React from 'react';
import AuthorList from '../AuthorList/AuthorList.jsx';

class Application extends React.Component {

  constructor (props) {
    super(props);

    this.onSelectAuthor = this.onSelectAuthor.bind(this);
  }

  componentDidMount () {
    this.ensureLoggedIn();
  }

  ensureLoggedIn () {
    this.getSessionState().then(data => {
      if (data.error) {
        this.props.history.push('/login');
      }
    });
  }

  getSessionState () {
    return fetch('/api/session', {
      credentials: 'same-origin'
    }).then(res => {
      return res.json()
    });
  }

  onSelectAuthor (author) {
    this.props.history.push(`/author/${author.id}`);
  }

  render () {
    return (
      <AuthorList onSelectAuthor={this.onSelectAuthor} />
    );
  }
}

export default Application
