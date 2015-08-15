
# Enlighten

Ruby Gem for use with the Enphase "Elighten" API version 2

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'enlighten'
```

And then execute:

    $ bundle install


## Usage

### Rails
#### Configuraton

Add the following line to an initializer at `config/initializers/enlighten.rb`:

```ruby
Enlighten::System.config(
    key: '<your key>', user_id: '<your user ID>'
)
```

#### Controller

From the Example App: `https://github.com/datadude/enlighten-example`

```ruby
  def home
    @system = Enlighten::System.new(params[:id])
    @summary = @system.summary
    @inventory = @system.inventory
    @envoys = @system.envoys
    @production = @system.monthly_production(:start_date=>1.month.ago - 1.day)
    @stats = @system.stats(:start_at=>DateTime.new(Time.now.year,Time.now.month,Time.now.day,7,0), :end_at=>Time.now)
  end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/enlighten_system/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

