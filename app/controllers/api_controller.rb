class ApiController < ApplicationController

	def uber_ride
	client = Uber::Client.new do |config|
		config.client_id     = "fV8iuY8XKX7yEFFQcBiyGiz2V6S7aurj"
		config.client_secret = "UJOd_m9qWmNYMbtkWYV0__OAMjqPcMaqA1Regggn"
		config.bearer_token  = "9dpffwlPqe6odv07YEiYzfBUvMC7DYyUWH6xfsMu"
	end

	client.trip_request(product_id: product_id, start_latitude: start_lat, start_longitude: start_lng, end_latitude: end_lat, end_longitude: end_lng)
	end

end
