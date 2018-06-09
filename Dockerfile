FROM ruby:2.4.1

# Install dependencies
RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN gem install bundler
RUN bundle install


# Prepare app
RUN mkdir /app
WORKDIR /app

# Move gemfile and run
#COPY Gemfile /app/Gemfile
#COPY Gemfile.lock /app/Gemfile.lock


# Move folders
COPY . .

#Config Puma
COPY config/puma.rb config/puma.rb

# Expose and setup start command
ENV RAILS_ENV=development
ENV RAILS_ROOT=/app
EXPOSE 3000
WORKDIR /app/api/tuniversidad
COPY docker-entrypoint.sh .
# Run app
ENTRYPOINT ["/app/api/tuniversidad/docker-entrypoint.sh"]
CMD bundle exec puma -C config/puma.rb
