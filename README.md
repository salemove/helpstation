# ApplicationService

Helps to unify SaleMove application services

## Installation

Add this line to your application's Gemfile:

    gem 'application_service', git: 'https://github.com/salemove/application_service.git'

And then execute:

    $ bundle

## Usage

TODO: Write proper usage instructions here

Example:
```ruby
require 'application_service'

class PersonFinder < ApplicationService::Process
  def call
    person = env.db.find_person(input.fetch(:person_id))
    success(input.merge(person: person))
  end
end

class ExportReadinessChecker < ApplicationService::Process
  def call
    person = input.fetch(:person)
    if SomeClassThatChecksPersonExportReadiness.check?(person)
      success(input)
    else
      error('not ready')
    end
  end
end

class PersonExporter < ApplicationService::Action
  def call
    # ... export ...
    success
  end
end

class ExportEmailNotifier < ApplicationService::Observer
  def call
    mailer.deliver('...') if success?
  end
end

substation = ApplicationService.build_substation(env)
substation.register(:export) do
  process PersonFinder
  process ExportReadinessChecker
  call PersonExporter, Substation::Chain::EMPTY, ExportEmailNotifier
end
substation.call(:export, {person_id: 5})
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
