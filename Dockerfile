# Use the official Alpine Ruby image
# FROM ruby:3.3.4-alpine
FROM python:3.9

# Ruby
FROM ubuntu:latest
FROM ruby:3.3.4-bookworm

ARG RUBY_VERSION=3.3.4
ARG RAILS_ENV=production
ARG BUNDLE_WITHOUT=development:test
ARG BUNDLE_PATH=vendor/bundle

ENV BUNDLE_PATH=${BUNDLE_PATH}
ENV BUNDLE_WITHOUT=${BUNDLE_WITHOUT}
ENV RAILS_ENV=production

# Set the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    git \
    python3-pip \
    tzdata

# Install Rails
RUN gem install rails
RUN gem install foreman

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

COPY lib/autoforward/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt --break-system-packages

# Install Ruby dependencies
RUN bundle install &&  rm -rf vendor/bundle/ruby/*/cache

# Copy the rest of the application code
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Expose port 3000
EXPOSE 3000

# Start the Rails server
CMD ["foreman", "start", "-f", "Procfile"]
