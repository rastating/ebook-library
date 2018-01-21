import React from 'react';

class BookPanel extends React.Component {

  constructor(props) {
    super(props);
    this.state = { book: props.book }

    this.onClick = this.onClick.bind(this);
  }

  onClick () {
    this.props.onBookSelected(this.state.book);
  }

  render() {
    let coverURL = '';
    if (this.state.book.cover) {
      coverURL = `/api/books/${this.state.book.id}/cover/${this.state.book.cover}`;
    }
    else {
      coverURL = '/assets/images/missing-sm.jpg';
    }

    return (
      <div className="author-panel" onClick={this.onClick}>
        <div className="overlay centered-flex-box"><i className="fas fa-search-plus"></i></div>
        <div className="card author-panel-card">
          <img className="card-img-top author-panel-cover" src={coverURL} />
          <div className="card-body">
            <p className="card-text text-center">
              {this.state.book.title}
            </p>
          </div>
        </div>
      </div>
    );
  }

}

export default BookPanel
