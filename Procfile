web: bundle exec rails server -p $PORT
redis: redis-server
worker: bundle exec rake resque:work QUEUE=*
