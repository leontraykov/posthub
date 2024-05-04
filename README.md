# PostHub

## Project Description

PostHub is a Ruby on Rails web application designed to manage posts, users, and their ratings. It allows users to create posts, rate them, and analyze IPs that have been used by multiple different users for posting.

## Features

### Key Features

- **Post Creation**: Users can create posts by specifying a title, body, their login, and IP address. If a user with the given login does not exist, they will be created.
- **Post Rating**: Users can rate posts. Each user can rate each post only once.
- **Top Posts by Average Rating**: The application provides functionality to view a list of top-N posts sorted by average rating.
- **IP Analysis**: Outputs a list of IP addresses that have been used to publish posts by several different users.

### Technical Details

- **Ruby on Rails**: Uses the latest stable version of Ruby on Rails.
- **PostgreSQL**: PostgreSQL is used as the database management system.
- **Frontend**: Interactions with the application are handled via REST API.

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

git clone https://github.com/yourusername/posthub.git
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

## Contributing

This project is open to contributions. If you would like to improve it or fix issues, please feel free to create a pull request.
