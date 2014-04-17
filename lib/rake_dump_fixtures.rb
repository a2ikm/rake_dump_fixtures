require "rake_dump_fixtures/version"
require "rails"

module RakeDumpFixtures
  class Railtie < Rails::Railtie
    railtie_name :rake_dump_fixtures

    rake_tasks do
      load "rake_dump_fixtures/dump_fixtures.rake"
    end
  end
end
