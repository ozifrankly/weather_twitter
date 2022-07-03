# frozen_string_literal: true
require "twitter"

module WeatherTwitter
  class WeatherPublisher
    attr_accessor :key, :secret, :token, :token_secret
      
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def generate_message(weather_infos)
      weathers = uniq_weathers(weather_infos)
      return "" if weathers.empty?
      message = "#{weathers[0][:temp]}°C e #{weathers[0][:description]} em #{weather_infos[:city]} em #{format_date(weathers[0][:day])}."
      message.concat " Média para os próximos dias: "
      message.concat  weathers[1..].map{|w| "#{w[:temp]}°C em #{format_date(w[:day])}"}.join(", ")
      message
    end

    def send(message)
      begin
      tweet = client.update(message)
      rescue => e
        return {
          success: false,
          message: e.message
        }
      end
      return {
        success: true,
        message: tweet.text
      }
    end

    private

    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key        = key
        config.consumer_secret     = secret
        config.access_token        = token
        config.access_token_secret = token_secret
      end
    end
  
    def format_date(date)
      list = date.split("-")
      return "#{list[2]}/#{list[1]}"
    end

    def uniq_weathers(weather_infos)
      weathers = {}
      weather_infos[:weathers].each do |weather|
        day = weather[:time].split(" ").first
        if weathers[day] == nil
          weathers[day] = {
            description: weather[:description],
            temp: weather[:temp],
            day: day,
          }
        end
      end
      weathers.values
    end
  end
end
