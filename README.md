# Book Collector Database

## Introduction

## Set up and configuration

## Technical Information

### Models

#### Books

Main model - encapsulates any book stored in the DB.
Fields:

- Title (not null) - the title of the book. Must be unique in the DB (i. e. no book can exist twice)
- Sort Title: Automatically generated from the title (lowercased and leading articles removed). Must also not be null
- slug: The slug to use in the books URL
- Original title: If the book was originally published in another language
- Year: The publishing year of a book (integer)
- Rating: An integer, used as an ENUM: not rated (0), hated (1), bad (2), ok (3), good (4), favourite (5)
- Condition: The physical condition of the book, used as an ENUM: not given (0), damaged (1), used_bad (2), used (3), used_ok (4), like_new (5)
- Edition: Free text string - first, second edition, etc etc.

### Ruby Version

This application is setup using Ruby v 3.1.2

### Gems

The following Gems are used in this project:

#### Application

- For active-storage, image_processing {https://rubygems.org/gems/image_processing} is used
- for easy going back to previous pages, backpedal {https://rubygems.org/gems/backpedal}
- to display URLs like /books/hobbit instead of /books/3, friendly_id {https://rubygems.org/gems/friendly_id}
- pagy to paginate big collections {https://rubygems.org/gems/pagy}

#### Development

- For formatting and linting, solargraph {https://rubygems.org/gems/solargraph}, solargraph-rails {https://rubygems.org/gems/solargraph-rails}, rubocop {https://rubygems.org/gems/rubocop}, rubocop-rails {https://rubygems.org/gems/rubocop-rails} and rubocop-performance {https://rubygems.org/gems/rubocop-performance} are included.
- Annotate {https://rubygems.org/gems/annotate} is used to auto-annotate models and routes
- Yard {https://rubygems.org/gems/yard} is used for documentation
- Rails-ERD {https://rubygems.org/gems/rails-erd} is used to draw the entity relationship diagrams as a PDF
- Bullet {https://rubygems.org/gems/bullet} is used to detect N+1 issues.
- Reek {https://github.com/troessner/reek} to detect code smells
- Database consistency checker {https://rubygems.org/gems/database_consistency} is used to validate database constraints vs validations
- Faker {https://rubygems.org/gems/faker} to quickly generate data
- Factory Bot {https://rubygems.org/search?query=factory_bot_rails} to easily generate test data
- Better_errors (and dependency binding_of_caller) for nicer error messages {https://rubygems.org/gems/better_errors}

#### Core Rails / Application

- CSS is processed using cssbundling-rails {https://rubygems.org/gems/cssbundling-rails}
- Javascript is processed using jsbundling-rails {https://rubygems.org/gems/jsbundling-rails}
- ViewComponents to replace partials {https://rubygems.org/gems/view_component}
- RequestJS-rails to improve JS/Rails interaction {https://rubygems.org/gems/requestjs-rails}

### JS Packages

The following packages have to be added via yarn:

- dropzone (for uploading images interactively) {https://www.dropzone.dev/js/}
- noty (for nice animated notifications) {https://ned.im/noty/#/}
- sweetalert2 to replace the boring browser dialogs {https://sweetalert2.github.io}

Check package.json for all dependencies that were added.

### Test Suite

RSpec is used for writing tests (using the rspec-rails gem {https://github.com/rspec/rspec-rails})
RSpec is enhanced with Rails-controller-testing {https://rubygems.org/gems/rails-controller-testing}
Using Simplecov to analyze code coverage ({https://rubygems.org/gems/simplecov})

### Database creation and initialization

### Styles and HTML

This project is partially based on normalize.css {https://necolas.github.io/normalize.css/}
