# Book Collector Database

## Introduction

## Set up and configuration

## Technical Information

### Programming ideas

#### Presenter Pattern

Moving away from helpers and use the patterns described in this article.
{ https://pawelurbanek.com/rails-presenter-pattern }

##### Book Presenter;

Implements presenter methods:

- show_original_title(wrapper, wrapper_styles): Displays original title in brackets and wrapped into optional tag with styles
- author_link(styles='', wrapper=nil, wrapper_styles=''): Displays link to author page with styles on the link, as well as optional wrapper tag with its own styles
- publisher_link(styles='', wrapper=nil, wrapper_styles=''): Displays link to publisher page with styles on the link as well as optional wrapper tag with its own styles
- show_synopsis(wrapper=nil, wrapper_styles='', title=false): Displays the rich text synopsis of the book, wrapped in optional tag with styles, and with optional title; if title=true, displays a h3 tag with <wrapper_styles>-title class and the text "Synopsis"
- show_trunc_synopsis(characters = 100): Shows a truncated synopsis of the book with a number of characters (default: 100)

### Params

A lot of views have the possibility to display different things or switch between
different modes. This is done by passing parameters to the view. The following
parameters are commonly used:
:show - This specifies "how to display" something. Three typical values are possible:

- 'grid': This renders cards with thumbnails and details
- 'list': This renders items as lists
- 'settings': This is used for admin views - rendering shorter lists

:list - This specifies WHAT to list out: Mainly used for "tags" which are polymorphic. Examples:

- 'books': lists books
- 'authors': lists authors

### Models

#### Books

Main model - encapsulates any book stored in the DB.
Fields:

- Title (not null) - the title of the book. Must be unique in the DB (i. e. no book can exist twice)
- Sort Title: Automatically generated from the title (lowercased and leading articles removed). Must also not be null
- slug: The slug to use in the books URL
- Original title: If the book was originally published in another language
- Year: The publishing year of a book (integer)
- country: country of origin
- Rating: An integer, used as an ENUM: not rated (0), hated (1), bad (2), ok (3), good (4), favourite (5)
- Condition: The physical condition of the book, used as an ENUM: not given (0), damaged (1), used_bad (2), used (3), used_ok (4), like_new (5)
- Edition: Free text string - first, second edition, etc etc.

#### Publishers
Model to encapsulate a book publisher in the DB.
Fields:

- name: The name of the publisher. Must be unique
- location: The location of the publisher ("London, New York")

The slug for friendly ID is derived from either the name or the combination of name and location.

#### Shelves

Model that holds the "storage place" for books. This is per user - other users
cannot filter by shelves that don't belong to them (but everybody can see all books).
Shelves can reference to something like "Office Fred" or "left bookshelf".
The first two shelves are shown on the books index page; the rest are hidden behind a "more" tab with a drop down.

#### Book Format

Model that holds the format of a book (hardcover, softcover, paperback etc). Every book belongs to a book_format and every format has many books.
Fields:

- name: Free text string, the name of the format ("hardcover")
- fallback: boolean. This defines the "default" (or "fallback") format that is used if there is no format given, but also that is used for any books of a format if that format is deleted

#### Genre

Model that holds book genres (fantasy, adventure, non-fiction etc). Every book can have
many genres and every genre can have many books.
Fields:

- name: Free text string, the name of the genre ("fantasy")
- slug: The slug to use in the genre URL

#### Users

Model to store user data. Fields:

- name: The username of a user (must be unique)
- email: The email of a user (must be unique)
- password_digest (for the has_secure_password method)

### Ruby Version

This application is setup using Ruby v 3.1.2

### Gems

The following Gems are used in this project:

#### Application

- For active-storage, image_processing { https://rubygems.org/gems/image_processing } is used
- for easy going back to previous pages, backpedal { https://rubygems.org/gems/backpedal }
- to display URLs like /books/hobbit instead of /books/3, friendly_id { https://rubygems.org/gems/friendly_id }
- pagy to paginate big collections { https://rubygems.org/gems/pagy }. The "load more" concept is coming from here: { https://dev.to/davidcolbyatx/pagination-and-infinite-scrolling-with-rails-and-the-hotwire-stack-34om }
- inline_svg to display SVGs { https://rubygems.org/gems/inline_svg }
- has_scope for scoped routes and similar { https://rubygems.org/gems/has_scope }
- country_select for book country selection (https://rubygems.org/gems/country_select)

#### Development

- For formatting and linting, solargraph { https://rubygems.org/gems/solargraph }, solargraph-rails { https://rubygems.org/gems/solargraph-rails }, rubocop { https://rubygems.org/gems/rubocop }, rubocop-rails { https://rubygems.org/gems/rubocop-rails } and rubocop-performance { https://rubygems.org/gems/rubocop-performance } are included.
- Annotate { https://rubygems.org/gems/annotate } is used to auto-annotate models and routes
- Rails-ERD { https://rubygems.org/gems/rails-erd } is used to draw the entity relationship diagrams as a PDF
- Bullet { https://rubygems.org/gems/bullet } is used to detect N+1 issues.
- Reek { https://github.com/troessner/reek } to detect code smells
- Database consistency checker { https://rubygems.org/gems/database_consistency } is used to validate database constraints vs validations
- Faker { https://rubygems.org/gems/faker } to quickly generate data
- Factory Bot { https://rubygems.org/search?query=factory_bot_rails } to easily generate test data
- Better_errors (and dependency binding_of_caller) for nicer error messages { https://rubygems.org/gems/better_errors }

#### Core Rails / Application

- CSS is processed using cssbundling-rails { https://rubygems.org/gems/cssbundling-rails }
- Javascript is processed using jsbundling-rails { https://rubygems.org/gems/jsbundling-rails }
- RequestJS-rails to improve JS/Rails interaction { https://rubygems.org/gems/requestjs-rails }

### JS Packages

The following packages have to be added via yarn:

- dropzone (for uploading images interactively) { https://www.dropzone.dev/js/ }
- noty (for nice animated notifications) { https://ned.im/noty/#/ }
- sweetalert2 to replace the boring browser dialogs { https://sweetalert2.github.io }
- tom-select { https://tom-select.js.org } for the nice tag-like selection in form select fields - I used this guide: { https://blog.corsego.com/select-or-create-with-tom-select }

Check package.json for all dependencies that were added.

### Test Suite

- RSpec is used for writing tests (using the rspec-rails gem { https://github.com/rspec/rspec-rails })
- - RSpec is enhanced with Rails-controller-testing { https://rubygems.org/gems/rails-controller-testing }
    Using Simplecov to analyze code coverage ({ https://rubygems.org/gems/simplecov })

### Database creation and initialization

### Styles and HTML

This project is partially based on normalize.css { https://necolas.github.io/normalize.css/ }
