# frozen_string_literal: true

namespace :picklists do
  desc 'This will send all outstanding orders to be packed'
  task :process_outstanding do
    OrderPicklists.process_outstanding!
  end
end
