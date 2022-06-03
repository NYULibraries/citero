FROM ruby:2.5.1-alpine

ENV INSTALL_PATH /app

WORKDIR $INSTALL_PATH

ENV BUILD_PACKAGES build-base
RUN apk add --no-cache $BUILD_PACKAGES

COPY Gemfile citero.gemspec ./
COPY ./lib/citero/version.rb ./lib/citero/version.rb

RUN gem install bundler -v '2.0.1' && bundle install --jobs 20 --retry 5

COPY . .
