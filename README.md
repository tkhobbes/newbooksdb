# Book Collector Database

## Introduction

## Set up and configuration

Run 'bundle exec rails bookdb_prep:seed_formats' to seed a default format. Otherwise the app will
crash when starting - it expects one book format to be available.

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

Check out localhost:3000/lookbook for a preview and description of all view components.

### Application Flow

#### Service Objects

There are two main categories of service objects: Book searching and creations, and image searching and creation.

##### Book Searching and Creation

The logical flow is:

- user searches for a book - either through a form (IsbnSearchController.new) or by scanning ISBNs (ScanController.new).
- the search parameters (author, title, isbn) are passed to a controller called IsbnSearch.show which in turn calls x::BookSearch.new().search_isbn, .search_author or .search_title
  - (x is either Google:: or Amazon::) - MORE TO WRITE HERE
- the IsbnSearch.show view is responsible for rendering a view that shows all results found (with some styling if the book is already present). the results are clickable and will call IsbnCreate.create
- IsbnCreate.create will call x::BookCreate.new().create_book
- x::BookCreate.new().create_book wrap the creation of a book, its authors (if not existing) and its publisher in one ActiveRecord transaction. It will then call PictureAttacher.new().attach
- PictureAttacher.new(picture_url).attach will try to attach the picture found in picture_url. It returns a return object that contains a field for "created" (true or false), a message, and (if successful) "picture" (the picture object or nil)
- x::BookCreate.new().create_book will then return a return object that contains a field for "created" (true or false), a message and the book object that was created (if successful).

##### Controller actions

- scan_queues_controller.rb
  - index: lists a queue
  - new: shows a form to scan ISBN codes
  - create: creates an entry in the queue
  - destroy: destroys an entry in the queue
- isbn_search_controller.rb
  - new: shows search form
  - show: shows search results
- isbn_create_controller.rb
  - create: Creates a book from an ISBN code (via service object)

##### The different views and turbo_streams

- scan_queues/new.html.erb: Displays a possibility to scan isbn-codes and shows a turbo-frame to the right of the scan area with scanned isbn codes
- scan_queues/\_results.html.erb: Content of the above mentioned turbo-frame.
- scan_queues/create.turbo_stream.erb: Updates the above mentioned turbo-frame with a new ISBN code
- scan_queues/destroy.turbo_stream.erb: Updates the above mentioned turbo-frame by removing an ISBN code
- scan_queues/index.html.erb: Comes after "new" - and shows all scanned isbn codes to click on (which then searches for matches for that ISBN code)
- isbn_search/new.html.erb: Shows a form to search by manually entering an ISBN code, an author name or a book title
- isbn_search/show.html.erb: Shows the results of above form
- isbn_search/show.turbo_stream.erb: Shows results in scan_queues/index.html.erb
- isbn_search/\_resultpreview.html.erb: Partial to display the book cover or a generic SVG in above views
- isbn_create/create.turbo_stream.erb: Used to update the scan_queues/index.html.erb view - removing the ISBN list entry of the book just created

#### Params

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

- Owners: The "user" field and used for authentication
- Profiles: More details for owners
- Books: Main model. Rateable, attachments (cover) and rich text synopsis
- Publishers: Book Publishers; slug (friendly id) derived from name or combination of name and location
- Authors: Book Authors. Can contain pictures and are rateable
- Book Formats: Book Formats (hardcover, softcover, ebook etc). The boolean "fallback" value which should be present on only one format is used if a format is not defined
- Genres: Genres of books
- Tags: Free text tags to categorize books. "Per user" - users don't see tags that don't belong to them
- Shelves: The "store location" of books. "Per user" - users don't see shelves that don't belong to them; shown as tabs on the book index page, with default tabs "all books" and "my books", as well as "books in no shelf" always visible

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
- Viewcomponents (https://rubygems.org/gems/view_component) for reusable components

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
- lookbook (https://rubygems.org/gems/lookbook) for previewing view components

#### Core Rails / Application

- CSS is processed using cssbundling-rails (https://rubygems.org/gems/cssbundling-rails)
- Javascript is processed using jsbundling-rails (https://rubygems.org/gems/jsbundling-rails)
- RequestJS-rails to improve JS/Rails interaction (https://rubygems.org/gems/requestjs-rails)

### JS Packages

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
- RSpec is enhanced with Rails-controller-testing (https://rubygems.org/gems/rails-controller-testing)
  Using Simplecov to analyze code coverage (https://rubygems.org/gems/simplecov)
- The depcreciation warning logic is from here: https://blog.testdouble.com/posts/2023-04-24-stop-ignoring-your-ruby-and-rails-deprecations/

### Database creation and initialization

### Styles and HTML

This project is partially based on normalize.css (https://necolas.github.io/normalize.css/)
