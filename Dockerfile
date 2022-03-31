FROM ruby:3.1

# Install the required packages and remove the apt cache.
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    default-mysql-client \
    nodejs \
  && rm -rf /var/lib/apt/lists

# Set your work directory
WORKDIR /app

# Set the default Yarn version to install
ARG YARN_VERSION=1.22.18

# Copy Gemfile to the container
COPY Gemfile* ./

# Install dependencies
RUN bundle install

# Copy everything in current directory (blog/) to the WORKDIR
COPY . .

# Install Yarn. This is needed for webpacker.
RUN curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version ${YARN_VERSION}
ENV PATH="/root/.yarn/bin:/root/.config/yarn/global/node_modules/.bin:$PATH"

# Expose port 3000 to allow us to access the site in our broser with localhost:3000
EXPOSE 3000

# Start rails server
CMD ["rails", "s", "-b", "0.0.0.0"]