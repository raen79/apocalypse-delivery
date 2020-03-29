# frozen_string_literal: true

desc 'This formats all files using prettier'
task :format do
  exec "bundle exec rbprettier --write '**/*.rb'"
end

namespace :format do
  desc 'This task checks if all files are formatted using prettier'
  task :check do
    exec "bundle exec rbprettier --check '*!(vendor|node_modules)/**/*.rb'"
  end
end
