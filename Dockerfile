FROM ruby:2.4.0

WORKDIR /app

RUN gem install bundler

ADD Gemfile Gemfile.lock /app/
RUN bundle install
