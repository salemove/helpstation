# Helpstation

Helps to unify SaleMove services

## Installation

Add this line to your application's Gemfile:

    gem 'helpstation'

And then execute:

    $ bundle

## Usage

TODO: Write proper usage instructions here

Example:
```ruby
require 'helpstation'

class PersonFinder < Helpstation::Process
  def call
    person = env.db.find_person(input.fetch(:person_id))
    success(input.merge(person: person))
  end
end

class ExportReadinessChecker < Helpstation::Process
  def call
    person = input.fetch(:person)
    if SomeClassThatChecksPersonExportReadiness.check?(person)
      success(input)
    else
      error('not ready')
    end
  end
end

class PersonExporter < Helpstation::Action
  def call
    # ... export ...
    success
  end
end

class ExportEmailNotifier < Helpstation::Observer
  def call
    mailer.deliver('...') if success?
  end
end

substation = Helpstation.build_substation(env)
substation.register(:export) do
  process PersonFinder
  process ExportReadinessChecker
  call PersonExporter, Substation::Chain::EMPTY, ExportEmailNotifier
end

response = substation.call(:export, {person_id: 5})
if response.success?
  puts 'Everything went fine'
  do_something_with response.output
else
  puts 'Got error'
end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
