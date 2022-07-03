# frozen_string_literal: true

RSpec.describe WeatherTwitter::WeatherPublisher do

  describe  '#send' do
    context "success" do
      before do
        reponse = OpenStruct.new
        reponse.text = "Olá"
        twitter = instance_double(Twitter::REST::Client)
        @publisher = WeatherTwitter::WeatherPublisher.new
        allow(twitter).to receive(:update).and_return(reponse)
        allow(@publisher).to receive(:client).and_return(twitter)
      end

      it "returns tweet with correct's text" do
        tweet = @publisher.send("Olá")
        expect(tweet[:message]).to eq "Olá"
      end

      it "returns tweet success true" do
        tweet = @publisher.send("Olá")
        expect(tweet[:success]).to be_truthy
      end
    end

    context "fail" do
      before do
        error = Twitter::Error::BadRequest.new("Bad Authentication data.")
        twitter = instance_double(Twitter::REST::Client)
        @publisher = WeatherTwitter::WeatherPublisher.new
        allow(twitter).to receive(:update).and_raise(error)
        allow(@publisher).to receive(:client).and_return(twitter)
      end

      it "returns tweet with correct1s text" do
        tweet = @publisher.send("Olá")
        expect(tweet[:message]).to eq "Bad Authentication data."
      end

      it "returns tweet success true" do
        tweet = @publisher.send("Olá")
        expect(tweet[:success]).to be_falsey
      end
    end
  end

  describe  '#generate_message' do
    context 'when has weathers' do

      let (:weather_infos) {
        {
          city: "Natal",
          weathers:[
            {description: "chuva forte", temp: 23.12, time: "2022-07-03 15:00:00"},
            {description: "chuva moderada", temp: 23.2, time: "2022-07-04 00:00:00"},
            {description: "chuva moderada", temp: 23.17, time: "2022-07-04 03:00:00"},
            {description: "chuva forte", temp: 23.68, time: "2022-07-04 12:00:00"},
            {description: "chuva moderada", temp: 22.63, time: "2022-07-05 03:00:00"},
            {description: "chuva fraca", temp: 22.58, time: "2022-07-05 06:00:00"},
            {description: "chuva fraca", temp: 22.55, time: "2022-07-05 09:00:00"},
            {description: "chuva fraca", temp: 23.99, time: "2022-07-06 21:00:00"},
            {description: "chuva moderada", temp: 23.58, time: "2022-07-07 00:00:00"},
            {description: "chuva fraca", temp: 23.22, time: "2022-07-08 03:00:00"},
          ]
        }
      }
      it "correct message" do
        publisher = WeatherTwitter::WeatherPublisher.new
        message = publisher.generate_message(weather_infos)
        expect(message).to eq "23.12°C e chuva forte em Natal em 03/07. Média para os próximos dias: 23.2°C em 04/07, 22.63°C em 05/07, 23.99°C em 06/07, 23.58°C em 07/07, 23.22°C em 08/07"
      end
    end

    context 'when  no have weathers' do

      let (:weather_infos) {
        {
          city: "",
          weathers:[]
        }
      }
      it "correct message" do
        publisher = WeatherTwitter::WeatherPublisher.new
        message = publisher.generate_message(weather_infos)
        expect(message).to eq ""
      end
    end
  end
end
