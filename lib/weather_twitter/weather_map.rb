# frozen_string_literal: true

require "rest_client"
require 'json'

module WeatherTwitter
  class WeatherMap
    BASE_URL = "https://api.openweathermap.org".freeze

    def initialize(app_id = nil)
      @app_id = app_id || ENV["OPEN_WEATHER_MAP_APP_ID"]
    end

    def take_city_weather(city_id)
      url = "#{BASE_URL}/data/2.5/forecast?id=#{city_id}&units=metric&lang=pt&appid=#{@app_id}"
      begin
        result = RestClient.get(url)
        infos = JSON.parse(result.body)
      rescue => e
        infos = {
          "cod" => "404"
        }
      end
      if infos["cod"] == "200"
        {
          code: 200,
          city: city_name(infos),
          weathers: filter_weather_infos(infos),
        }
      else
        {
          code: infos["cod"].to_i,
          city: "",
          weathers: [],
        }
      end
    end

    private

    def city_name(infos)
      infos["city"]["name"]
    end

    def filter_weather_infos(infos)
      infos["list"].map do |info|
        {
          temp: info["main"]["temp"],
          description: info["weather"][0]["description"],
          time: info["dt_txt"]
        }
      end
    end
  end
end
