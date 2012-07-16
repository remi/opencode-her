## Her

These are the files I used to present [Her](http://remiprev.github.com/her) at the 5th [OpenCode](http://opencode.ca) on July 17th 2012.

### API

    $ cd api-grape
    $ touch bluth.db
    $ bundle install && bundle exec thin start --port 4002
    …
    >> Listening on 0.0.0.0:4002, CTRL+C to stop

### Client

    $ cd client-her
    $ bundle install && bundle exec ruby app.rb
    >> 