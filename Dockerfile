FROM ruby:2.4.0

WORKDIR /app

RUN apt-get update -qq

# Spell-checking dependencies
RUN apt-get install -y \
      aspell \
      libaspell-dev

RUN gem install bundler

ADD Gemfile Gemfile.lock /app/
RUN bundle install
