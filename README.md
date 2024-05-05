# PostHub

## Project Description

PostHub is a Ruby on Rails web application specifically designed as a REST API to manage posts, users, and their ratings.
It allows users to create posts, rate them, and analyze IPs that have been used by multiple different users for posting.

## Features

### Key Features

- **Post Creation**: Users can create posts by specifying a title, body, their login, and IP address. If a user with the given login does not exist, they will be created.
- **Post Rating**: Users can rate posts. Each user can rate each post only once.
- **Top Posts by Average Rating**: The application provides functionality to view a list of top-N posts sorted by average rating.
- **IP Analysis**: Outputs a list of IP addresses that have been used to publish posts by several different users.

### Technical Details

- **Ruby**: Ruby version 3.3.0.
- **Ruby on Rails**: Rails version 7.1.3.2.
- **PostgreSQL**: PostgreSQL is used as the database management system.
- **API-only Application**: No front-end components are included, as it's designed to be accessed through its REST API.

## API Endpoints

### POST /posts
- **Description**: Creates a new post.
- **Parameters**:
  - `title`: The title of the post.
  - `body`: The body of the post.
  - `login`: User login.
  - `ip`: User IP address.

### POST /ratings
- **Description**: Adds a rating to a post.
- **Parameters**:
  - `post_id`: The ID of the post.
  - `user_id`: The ID of the user.
  - `value`: The rating value (from 1 to 5).

### GET /posts/top?n=5
- **Description**: Returns the top-N posts by average rating.
- **Parameters**:
  - `n`: Number of posts to display.

### GET /ips_with_multiple_authors
- **Description**: Returns a list of IP addresses that have been used to publish posts by multiple different users.

## Setup and Launch

### Cloning the Repository

git clone git@github.com:leontraykov/posthub.git
cd posthub

### Database Setup

- rails db:create
- rails db:migrate
- rails db:seed

### Starting the Server

- rails server

## Testing

To run tests:
- rspec
