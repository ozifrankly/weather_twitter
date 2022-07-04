# WeatherTwitter

A gem to publish one's weather data on twitter.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'weather_twitter', git: 'https://github.com/ozifrankly/weather_twitter'
```

And then execute:

    $ bundle install

## Configuration

Registration at [openweathermap](https://openweathermap.org/api) and at [twitter](https://apps.twitter.com/) is required for correct operation

## Usage

To get metrological information for a city

```ruby
 app_id = "OPEN_WEATHER_MAP_APP_ID"
 weather_map = WeatherTwitter::WeatherMap.new(app_id)
 weather_infos = weather_map.take_city_weather(city_id)
```

To send a message with weather information

```ruby
publisher = WeatherTwitter::WeatherPublisher.new do |config|
  config.key          = ENV["YOUR_CONSUMER_KEY"]
  config.secret       = ENV["YOUR_CONSUMER_SECRET"]
  config.token        = ENV["TWITTER_API_TOKEN"]
  config.token_secret = ENV["YOUR_ACCESS_TOKEN"]
end
message = publisher.generate_message(weather_infos)
publisher.send(message)
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
