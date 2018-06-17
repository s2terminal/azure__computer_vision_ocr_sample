FROM ruby:2.5.1-alpine

ENV APP_ROOT=/myapp

WORKDIR $APP_ROOT
COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT
RUN apk update &&  apk upgrade
RUN apk add --update --no-cache build-base curl-dev bash git openssh
RUN bundle install
COPY . $APP_ROOT
CMD ["ruby", "app.rb", "-o", "0.0.0.0"]
