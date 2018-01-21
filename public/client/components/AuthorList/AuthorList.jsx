import React from 'react';
import AuthorPanel from '../AuthorPanel/AuthorPanel.jsx';
import LoadingPanel from '../LoadingPanel/LoadingPanel.jsx';

class AuthorList extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      authors:  [],
      hasError: false,
      isLoading: true
    }

    this.onSelectAuthor = this.onSelectAuthor.bind(this);
  }

  componentDidMount () {
    this.getAuthors().then(data => {
      if (data.error) {
        this.setState({ hasError: true });
      }
      else {
        this.setState({ authors: data, isLoading: false });
      }
    });
  }

  getAuthors () {
    return fetch('/api/authors', {
      credentials: 'same-origin'
    }).then(res => {
      return res.json()
    });
  }

  onSelectAuthor (author) {
    this.props.onSelectAuthor(author);
  }

  render () {
    let panels = this.state.authors.map(a => {
      return (
        <div className="col-md-3 col-sm-4" key={`author-${a.id}`}>
          <AuthorPanel author={a} onClick={this.onSelectAuthor} />
        </div>
      );
    });

    return (
      <LoadingPanel entity="authors" isLoading={this.state.isLoading}>
        <div className="row row-eq-height author-list-row">
          {panels}
        </div>
      </LoadingPanel>
    );
  }

}

export default AuthorList
