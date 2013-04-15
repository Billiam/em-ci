# Test

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'em-ci'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install em-ci

## Usage

### Basic usage
```ruby

require 'eventmachine'
require 'em-ci'

ci = EmCi.new 'http://jenkins.site/cc.xml'

# Add a callback
ci.on_run do |server|
  if server.building?
    puts 'Currently building'
  elsif server.failure?
    puts 'Last build failed'
  elsif server.success?
    puts 'All builds successful'
  end
end

EventMachine.run {
  # run every 15 seconds
  ci.start 15
}
```

### Multiple projects

```ruby
#...
ci.on_run do |server|
  if server['CustomProject'].sleeping?
    puts 'Custom Project is sleeping'
  end

  server.projects.each do |project|
    # do something with individual project
  end
end
```

### Filtering projects

```ruby
# Filter projects by name
ci = EmCi.new 'http://jenkins.site/cc.xml', { filter: ['ProjectA', 'ProjectB'] }

ci.on_run do |server|
  # only ProjectA and ProjectB will be included in sleeping check
  server.sleeping?
end
```

### Authentication

```ruby
ci = EmCi.new 'http://jenkins.site/cc.xml', { auth: ['my-username', 'my-password-or-auth-token'] }
```

