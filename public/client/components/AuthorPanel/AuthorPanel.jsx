import React from 'react';
import './styles.css';

class AuthorPanel extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      author: props.author,
      covers: []
    }

    this.onClick = this.onClick.bind(this);
  }

  componentDidMount () {
    this.getBookCovers().then(data => {
      this.setState({ covers: data });
    });
  }

  getBookCovers () {
    return fetch(`/api/authors/${this.state.author.id}/books/covers`, {
      credentials: 'same-origin'
    }).then(res => {
      return res.json()
    });
  }

  onClick () {
    this.props.onClick(this.state.author);
  }

  render() {
    let caption = '1 book';
    if (this.state.author.book_count != 1) {
      caption = `${this.state.author.book_count} books`
    }

    let coverURL = this.state.covers[0] || '/assets/images/missing-sm.jpg';

    return (
      <div className="author-panel" onClick={this.onClick}>
        <div className="overlay centered-flex-box"><i className="fas fa-search-plus"></i></div>
        <div className="card author-panel-card">
          <img className="card-img-top author-panel-cover" src={coverURL} alt="Card image cap" />
          <div className="card-body">
            <p className="card-text text-center">
              {this.state.author.name}<br />
              <span className="text-muted">{caption}</span>
            </p>
          </div>
        </div>
      </div>
    );
  }

}

export default AuthorPanel
