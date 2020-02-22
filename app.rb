require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

# enter your Dark Sky API key here
ForecastIO.api_key = "7674a916e740cae79dc3b348f2651d94"

# enter News API
url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=5ebd5dd24b394e6198e8a350205f6be1"

# news is now a Hash you can pretty print (pp) and parse for your output

get "/" do
  # show a view that asks for the location
  view "ask"
end

get "/news" do
  # do everything else
    @location = params["location"]
    @results = Geocoder.search(@location)
    @lat_long = @results.first.coordinates
    @forecast = ForecastIO.forecast(@lat_long[0],@lat_long[1]).to_hash
    @current_temp = @forecast["currently"]["temperature"]
    @current_summary = @forecast["currently"]["summary"]
    @count = 0
    @news_articles = HTTParty.get(url).parsed_response.to_hash
    view "news"
end