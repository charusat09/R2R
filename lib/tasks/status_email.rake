namespace :email do
  desc "send email as per booking status"
  task send_email: :environment do
    time = Time.now.getlocal("+05:30").strftime "%H:%M"
    advance_time = (Time.now.getlocal("+05:30") + 5.minutes).strftime "%H:%M"
    travel_date = Time.now.getlocal("+05:30").strftime "%d/%m/%Y"
    boardings = ApiDetail.where("booking_time >=? and booking_time <= ? and travel_date = ?",time,advance_time,today_date)
    boardings.each do |boarding|
      access_token = ENV["ACCESS_TOKEN"]
      base_uri = "https://sandbox-api.uber.com/v1/requests?access_token=#{access_token}"
      query = {
	product_id: "d5c3d5fe-883f-4105-99e4-fcb9ae46a988",
	start_latitude: 19.1068,
	start_longitude: 72.8989,
	end_latitude: 19.1197,
	end_longitude: 72.9051
        }.to_json

      headers = {'Content-Type' => 'application/json'}

      response = HTTParty.post(
        base_uri,
        :body => query,
        :headers => headers
        ).body
      SEND STATUS EMAIL

    end
  end
end
