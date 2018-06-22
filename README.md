E-book Library
==============
[![Build Status](https://travis-ci.org/rastating/ebook-library.svg?branch=master)](https://travis-ci.org/rastating/ebook-library) [![Maintainability](https://api.codeclimate.com/v1/badges/0b4517bea3dc3e388450/maintainability)](https://codeclimate.com/github/rastating/ebook-library/maintainability) [![Coverage Status](https://coveralls.io/repos/github/rastating/ebook-library/badge.svg?branch=master)](https://coveralls.io/github/rastating/ebook-library?branch=master)

E-book Library is a small web application powered by Sinatra and React, which will organise and provide access to a library of ePub and PDF documents.

Quick Start
-----------
To get E-book Library setup, clone the repository and install the required dependencies.

```bash
git clone https://github.com/rastating/ebook-library.git
cd ebook-Library
gem install bundler
bundle install
```

After the dependencies have been installed, `rake` can be used to create the database and run through the library setup wizard.

```bash
rake db:migrate
rake library:setup
```

The last step before launching, is to create at least one user. To do this, launch the user creation wizard by running:

```bash
rake user:create
```

Once a user has been created, the application can be launched by running `rackup config.ru`. By default, this will bind the server to `localhost`. If you wish to bind to all interfaces, you can change the binding with the `-o` option, for example:

```bash
rackup -o 0.0.0.0 config.ru
```

For more information on using `rackup`, run `rackup --help`.

Refreshing The Library
----------------------
A rake task is provided to initiate a scan of the watch folder. This is not used by the application itself, and any library refresh schedules should be created externally by invoking the rake task.

```bash
rake library:scan
```

Merging Authors
--------------------
In some instances, an author's name may be categorised differently in the metadata of different books. For example, one book may list the author in the format of `{Name} {Surname}`, another may use `{Surname}, {Name}`. When this happens, the `author:merge` task can be used to merge all books from one author, to another.

In order to perform a merge, the IDs of the authors must be known. To identify this, list the authors:

```bash
rake author:search
```

Alternatively, to find all authors with a name like "rastating", run:

```bash
rake author:search[rastating]
```

Once the IDs have been identified, use the source author ID as the first parameter to `author:merge`, and the destination author ID as the second parameter. For example, if we wanted to merge all the books from author 10 to author 3, the command to run would be:

```bash
rake author:merge[10,3]
```

Other Tasks
-----------
In addition to the rake tasks documented above, there are a number of other tasks to carry out miscellaneous operations; all of which are quite self explanatory. A list of tasks can be viewed from the terminal by running `rake -T` within the `ebook-library` directory. Alternatively, the list can also be found below:

Task                           | Description
-------------------------------|-------------------------------------
`author:delete[id]`            | Delete an author by their ID number
`author:merge[src_id,dest_id]` | Merge all books from [src_id] to [dest_id]
`author:search[name]`          | Search authors by name
`db:migrate[version]`          | Run database migrations
`library:refresh[book_id]`     | Refresh a book's metadata
`library:scan`                 | Scan the watch folder for new books
`library:setup`                | Run the setup wizard
`user:create`                  | Run the new user wizard
`user:delete[id]`              | Delete a user by their ID number
`user:search[username]`        | Search users by username
