# frozen_string_literal: true

RSpec.describe WeatherTwitter::WeatherMap do
  let (:app_id) {"fakeid"}

  context 'when found city' do
    let (:city_id) {3394023}
    before do
      stub_get('/data/2.5/forecast').with(query: {id: city_id, units: "metric", lang: "pt", appid: app_id}).to_return(body: fixture('natal.json'))
    end

    it "call correct url" do
      weather_map = WeatherTwitter::WeatherMap.new(app_id)
      result = weather_map.take_city_weather(city_id)
      expect(a_get('/data/2.5/forecast').with(query: {id: city_id, units: "metric", lang: "pt", appid: app_id})).to have_been_made
      expect(result[:code]).to be 200
    end

    it "get correct informations" do
      weather_map = WeatherTwitter::WeatherMap.new(app_id)
      result = weather_map.take_city_weather(city_id)
      expect(result[:weathers]).to include(
        {description: "chuva forte", temp: 23.12, time: "2022-07-03 15:00:00"},
        {description: "chuva forte", temp: 23.19, time: "2022-07-03 18:00:00"},
        {description: "chuva forte", temp: 23.26, time: "2022-07-03 21:00:00"},
        {description: "chuva moderada", temp: 23.2, time: "2022-07-04 00:00:00"},
        {description: "chuva moderada", temp: 23.17, time: "2022-07-04 03:00:00"},
        {description: "chuva forte", temp: 22.88, time: "2022-07-04 06:00:00"},
        {description: "chuva forte", temp: 22.86, time: "2022-07-04 09:00:00"},
        {description: "chuva forte", temp: 23.68, time: "2022-07-04 12:00:00"},
        {description: "chuva fraca", temp: 26.03, time: "2022-07-04 15:00:00"},
        {description: "chuva fraca", temp: 25.83, time: "2022-07-04 18:00:00"},
        {description: "chuva fraca", temp: 23.71, time: "2022-07-04 21:00:00"},
        {description: "chuva fraca", temp: 23.04, time: "2022-07-05 00:00:00"},
        {description: "chuva moderada", temp: 22.63, time: "2022-07-05 03:00:00"},
        {description: "chuva fraca", temp: 22.58, time: "2022-07-05 06:00:00"},
        {description: "chuva fraca", temp: 22.55, time: "2022-07-05 09:00:00"},
        {description: "chuva fraca", temp: 26.75, time: "2022-07-05 12:00:00"},
        {description: "céu limpo", temp: 27.73, time: "2022-07-05 15:00:00"},
        {description: "céu limpo", temp: 26.94, time: "2022-07-05 18:00:00"},
        {description: "céu limpo", temp: 24.78, time: "2022-07-05 21:00:00"},
        {description: "céu pouco nublado", temp: 24.39, time: "2022-07-06 00:00:00"},
        {description: "céu limpo", temp: 23.43, time: "2022-07-06 03:00:00"},
        {description: "céu limpo", temp: 22.8, time: "2022-07-06 06:00:00"},
        {description: "céu limpo", temp: 22.91, time: "2022-07-06 09:00:00"},
        {description: "céu limpo", temp: 27.13, time: "2022-07-06 12:00:00"},
        {description: "chuva fraca", temp: 27.96, time: "2022-07-06 15:00:00"},
        {description: "chuva fraca", temp: 26.72, time: "2022-07-06 18:00:00"},
        {description: "chuva fraca", temp: 23.99, time: "2022-07-06 21:00:00"},
        {description: "chuva moderada", temp: 23.58, time: "2022-07-07 00:00:00"},
        {description: "chuva moderada", temp: 23.4, time: "2022-07-07 03:00:00"},
        {description: "chuva moderada", temp: 23.42, time: "2022-07-07 06:00:00"},
        {description: "chuva moderada", temp: 22.98, time: "2022-07-07 09:00:00"},
        {description: "chuva moderada", temp: 25.83, time: "2022-07-07 12:00:00"},
        {description: "chuva moderada", temp: 26.48, time: "2022-07-07 15:00:00"},
        {description: "chuva fraca", temp: 26.07, time: "2022-07-07 18:00:00"},
        {description: "chuva fraca", temp: 23.89, time: "2022-07-07 21:00:00"},
        {description: "chuva moderada", temp: 23.46, time: "2022-07-08 00:00:00"},
        {description: "chuva fraca", temp: 23.22, time: "2022-07-08 03:00:00"},
        {description: "chuva fraca", temp: 22.63, time: "2022-07-08 06:00:00"},
        {description: "chuva fraca", temp: 22.75, time: "2022-07-08 09:00:00"},
        {description: "chuva fraca", temp: 25.8, time: "2022-07-08 12:00:00"}
      )
    end
  end

  context "when not found city" do
    let (:city_id) {222222223394023}
    before do
      stub_get('/data/2.5/forecast').with(query: {id: city_id, units: "metric", lang: "pt", appid: app_id}).to_return(body: fixture('not_found.json'))
    end

    it "call correct url" do
      weather_map = WeatherTwitter::WeatherMap.new(app_id)
      result = weather_map.take_city_weather(city_id)
      expect(a_get('/data/2.5/forecast').with(query: {id: city_id, units: "metric", lang: "pt", appid: app_id})).to have_been_made
      expect(result[:code]).to be 404
    end

    it "get empyt informations" do
      weather_map = WeatherTwitter::WeatherMap.new(app_id)
      result = weather_map.take_city_weather(city_id)
      expect(result[:weathers]).to be_empty
    end
  end
end
