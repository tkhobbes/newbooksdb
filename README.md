# Book Collector Database

## Introduction

## Set up and configuration

## Technical Information

### Programming ideas

#### Quick Search and Search

Quick search code is adapted from the Drifting Ruby Episode 369 https://youtu.be/cVKRSF2Td7E
and then augmented from https://thoughtbot.com/blog/hotwire-typeahead-searching
(especially the styling and the form invalidations)

Quick search and search use search_cop. Search is scoped for book titles, book
original titles.

#### Flash Messages

Moving away from noty and used turbo - as described in this video: https://youtu.be/gk_qDsKMIrM

#### View Components

...

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

#### Stimulus controller for Tab Navigation

There is a stimulus controller to switch between tabs (in tags view), code taken
from this youtube video: https://youtu.be/I8Np9GHNMDk

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

#### Publishers

Model to encapsulate a book publisher in the DB.
Fields:

- name: The name of the publisher. Must be unique
- location: The location of the publisher ("London, New York")

The slug for friendly ID is derived from either the name or the combination of name and location.

#### Shelves

Model that holds the "storage place" for books. This is per user - other users
cannot filter by shelves that don't belong to them (but everybody can see all books).
Shelves can reference to something like "Office Fred" or "left bookshelf".
The first two shelves are shown on the books index page; the rest are hidden behind a "more" tab with a drop down.

#### Book Format

Model that holds the format of a book (hardcover, softcover, paperback etc). Every book belongs to a book_format and every format has many books.
Fields:

- name: Free text string, the name of the format ("hardcover")
- fallback: boolean. This defines the "default" (or "fallback") format that is used if there is no format given, but also that is used for any books of a format if that format is deleted

#### Genre

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

#### Owners and Profiles

Owners are used to store owners of books and the model serves as the authentication
model for Devise. Profiles are used to store more info about a owner (name, picture etc).

### Ruby Version

This application is setup using Ruby v 3.1.2

### Gems

The following Gems are used in this project:

#### Application

- For active-storage, image_processing (https://rubygems.org/gems/image_processing) is used
- for easy going back to previous pages, backpedal (https://rubygems.org/gems/backpedal)
- to display URLs like /books/hobbit instead of /books/3, friendly_id (https://rubygems.org/gems/friendly_id)
- pagy to paginate big collections (https://rubygems.org/gems/pagy). The "load more" concept is coming from here: https://dev.to/davidcolbyatx/pagination-and-infinite-scrolling-with-rails-and-the-hotwire-stack-34om
- inline_svg to display SVGs (https://rubygems.org/gems/inline_svg)
- has_scope for scoped routes and similar (https://rubygems.org/gems/has_scope)
- country_select for book country selection (https://rubygems.org/gems/country_select)
- search_cop for searching (https://rubygems.org/gems/search_cop)
- devise for user authentication (https://rubygems.org/gems/devise)
- metainspector for webcralwing (https://rubygems.org/gems/metainspector)

#### Development

- For formatting and linting, solargraph (https://rubygems.org/gems/solargraph), solargraph-rails (https://rubygems.org/gems/solargraph-rails), rubocop (https://rubygems.org/gems/rubocop), rubocop-rails (https://rubygems.org/gems/rubocop-rails) and rubocop-performance (https://rubygems.org/gems/rubocop-performance) are included.
- Annotate (https://rubygems.org/gems/annotate) is used to auto-annotate models and routes
- Rails-ERD (https://rubygems.org/gems/rails-erd) is used to draw the entity relationship diagrams as a PDF
- Bullet (https://rubygems.org/gems/bullet) is used to detect N+1 issues.
- Prosopite (https://rubygems.org/gems/prosopite) for more N+1 detection
- Reek (https://github.com/troessner/reek) to detect code smells
- Brakeman (https://rubygems.org/gems/brakeman) to detect security issues
- Database consistency checker (https://rubygems.org/gems/database_consistency) is used to validate database constraints vs validations
- Faker (https://rubygems.org/gems/faker) to quickly generate data
- Factory Bot (https://rubygems.org/search?query=factory_bot_rails) to easily generate test data
- Better_errors (and dependency binding_of_caller) for nicer error messages (https://rubygems.org/gems/better_errors)
- letter_opener to to test e-mails (https://rubygems.org/gems/letter_opener)
- pry-rails (https://rubygems.org/gems/pry-rails) for debugging / console

#### Core Rails / Application

- CSS is processed using cssbundling-rails (https://rubygems.org/gems/cssbundling-rails)
- Javascript is processed using jsbundling-rails (https://rubygems.org/gems/jsbundling-rails)
- RequestJS-rails to improve JS/Rails interaction (https://rubygems.org/gems/requestjs-rails)

### JS Packages

The following packages have to be added via yarn:

- dropzone (for uploading images interactively) (https://www.dropzone.dev/js/)
- sweetalert2 to replace the boring browser dialogs (https://sweetalert2.github.io)
- tom-select (https://tom-select.js.org) for the nice tag-like selection in form select fields - I used this guide: (https://blog.corsego.com/select-or-create-with-tom-select)
- html5-qrcode (https://github.com/mebjas/html5-qrcode) for the barcode scanning functionality - see also https://blog.minhazav.dev/QR-and-barcode-scanner-using-html-and-javascript/

Check package.json for all dependencies that were added.

#### Stimulus Controllers

The controller to add author subforms (another_sub_form) is based on this guide:
https://ndrean.medium.com/dynamic-nested-forms-with-rails-aa537a3ee758

### Test Suite

- RSpec is used for writing tests (using the rspec-rails gem https://github.com/rspec/rspec-rails)
- - RSpec is enhanced with Rails-controller-testing (https://rubygems.org/gems/rails-controller-testing)
    Using Simplecov to analyze code coverage (https://rubygems.org/gems/simplecov)

### Database creation and initialization

### Styles and HTML

This project is partially based on normalize.css (https://necolas.github.io/normalize.css/)
