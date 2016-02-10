# Draft Builder 2015

A Fantasy Football Draft Rails App

# Setup

Install

  1. ruby version 2.1.5+. I used rvm.
  2. rails
  3. postgresql

Then install gem dependencies:

```
$ bundle install
```

Next, setup the database:
```
rake db:create db:migrate db:seed
```

Finally, start the rails server:
```
$ rails s
```