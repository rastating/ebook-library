import React from 'react';
import LoadingPanel from '../LoadingPanel/LoadingPanel.jsx';
import BookPanel from '../BookPanel/BookPanel.jsx';
import BookPopup from '../BookPopup/BookPopup.jsx';

class AuthorProfile extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      authorID:        props.match.params.author_id,
      isLoading:       true,
      authorName:      '',
      books:           [],
      selectedBook:    {},
      hasSelectedBook: false
    }

    this.onBookSelected = this.onBookSelected.bind(this);
    this.onBookPopupClose = this.onBookPopupClose.bind(this);
  }

  componentDidMount () {
    this.ensureLoggedIn();

    this.getAuthor().then(data => {
      this.setState({ authorName: data.name });

      this.getBooks().then(data => {
        this.setState({ books: data, isLoading: false });
      });
    });
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

  getAuthor () {
    return fetch(`/api/authors/${this.state.authorID}`, {
      credentials: 'same-origin'
    }).then(res => {
      return res.json()
    });
  }

  getBooks () {
    return fetch(`/api/authors/${this.state.authorID}/books`, {
      credentials: 'same-origin'
    }).then(res => {
      return res.json()
    });
  }

  onBookSelected (book) {
    this.ensureLoggedIn();
    this.setState({
      selectedBook:    book,
      hasSelectedBook: true
    })
  }

  onBookPopupClose () {
    this.setState({
      selectedBook:    {},
      hasSelectedBook: false
    })
  }

  render () {
    let panels = this.state.books.map(book => {
      return (
        <div className="col-md-3 col-sm-4" key={`book-${book.id}`}>
          <BookPanel book={book} onBookSelected={this.onBookSelected} />
        </div>
      );
    });

    let bookListStyle = {
      overflow: this.state.hasSelectedBook ? 'hidden' : 'visible'
    }

    return (
      <LoadingPanel entity="books" isLoading={this.state.isLoading}>
        <div className="h-100" style={bookListStyle}>
          <h1>Books by {this.state.authorName}</h1>
          <hr />
          <div className="row row-eq-height author-list-row">
            {panels}
          </div>
        </div>

        <BookPopup book={this.state.selectedBook}
          closed={!this.state.hasSelectedBook}
          onClose={this.onBookPopupClose} />
      </LoadingPanel>
    );
  }

}

export default AuthorProfile
