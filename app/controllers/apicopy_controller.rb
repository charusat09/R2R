class ApicopyController < ApplicationController
	include HTTParty


	def process_ride
       	 scode=get_pnr_status()
         puts scode 
         stn_cord=get_station_coordinates(scode)
         user_cord=get_user_cordinates()
         dist=get_duration(user_cord[0],user_cord[1],stn_cord[0],stn_cord[1])
         puts "Dist : #{dist}"
         journey_details=get_train_boarding_time()        
         puts journey_details[0],journey_details[1],journey_details[2],journey_details[3],journey_details[4]
         dist=Time.at(dist).utc.strftime("%H:%M")
         #chedular_time=journey_details[4].to_time-{(dist.to_time)*2}
         puts dist
	end

        def uber_ride
         access_token = get_access_token
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
         puts "--------uber request------------"
	 puts response.inspect

        end

#Replace hardcoded PNR by pnr provided in request
	def get_pnr_status(pnr="4220338987")
	 s = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/pnr_status/pnr/#{pnr}/apikey/cbgmi8296/")).body
         q = JSON.parse(s)
         @scode=q["boarding_point"]["code"] 	
         return "#{@scode}"
         p q
	end
	
	def get_train_boarding_time(pnr="4220338987")
        	br_code=get_pnr_status(pnr)
		s = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/pnr_status/pnr/#{pnr}/apikey/cbgmi8296/")).body
		q = JSON.parse(s)
		trn_no=q["train_num"]
                doj=q["doj"]
                current_status=q["passengers"][0]["current_status"]
		total_passengers=q["total_passengers"]
                r=Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/arrivals/station/#{br_code}/hours/4/apikey/cbgmi8296/")).body
		qs = JSON.parse(r)["train"]
		qs.each do |trn_num|
			if trn_num["number"] == trn_no
			$trn_time=trn_num["schdep"]
			end
		end
                return trn_no,doj,current_status,total_passengers,$trn_time
 end

#Replcae hardcoded ADH staion with source staion code from get_pnr_status
	def get_station_coordinates(scode)
		s = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/code_to_name/code/#{scode}/apikey/cbgmi8296/")).body
          @q = JSON.parse(s)["stations"]
          @q.each do |stncode|
    		if stncode["code"] .eql? "#{scode}"
                	return stncode["lat"],stncode["lng"]
    		end
	  end
	end

	def get_user_cordinates(user_lat="19.0728300",user_lng="72.8826100")
        	return "#{user_lat}","#{user_lng}"
	end

	def get_duration(user_lat,user_lng,stn_lat,stn_lng)
        	 s = Net::HTTP.get_response(URI.parse("https://api.mapmyindia.com/v3?fun=star_dists&lic_key=5h9mbi7h2jvdszbvzcir1c4llwohp9rt&center=#{user_lat},#{user_lng}&pts=#{stn_lat},#{stn_lng}&rtype=0&vtype=1&avoids=0110")).body

        	q = JSON.parse(s)
		return q[0]["duration"]
	end

	def db_store
	end
	private
	def get_access_token
			 "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZXMiOlsicHJvZmlsZSIsImhpc3RvcnkiLCJyZXF1ZXN0Il0sInN1YiI6ImZiOGUwYTlkLTg5ZmMtNGEwMi1hOTlmLWNjZGQ2MjNkZWRiNCIsImlzcyI6InViZXItdXMxIiwianRpIjoiMWI0MGM2ZjMtNjQzYi00MDY1LWI5MGUtNjRiNmNiYmMzNTk2IiwiZXhwIjoxNDcwMzA2OTY1LCJpYXQiOjE0Njc3MTQ5NjUsInVhY3QiOiJIUUZMTEVTNjhZQzVkcG9vTEZkVW9MbkJIQUZTc1oiLCJuYmYiOjE0Njc3MTQ4NzUsImF1ZCI6Ik5sckFncWRMT0dkZUJ1X0o5aE5ETmQ4UEQ5Q3Vkc2dDIn0.gxzHZbZvhLmeDl0_jnSQ_FVwAZl9-QY7srjNNZdxvnRK5VWNuJu91T3ayNRqW14jlkSXbgM0apH5yfVyQxfLTOoIwsh8zpYXrHs2NGW89tOd7SMmHU8xxo3cHfZjppS5kegVT0BiOam4aj9yY3b_oWN6FgoxSg9kyzaqJViRAo9fKpiyhAHTIif_Pxc0iq0mM3j2CqEwWezbqroacBWG86ovgLiF5jMKkAZCnHcBJ1q8Qk4iQMBSe6Mjo93y-THLhTdu5TFu0kgLJ1bpzZ6GdQmY71eVc59i98R4Sfue4vnclmt75hvfLu2opaI7nfAast85ZDN_G-gx6air1pyzJw"
	end	
end
