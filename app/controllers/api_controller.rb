class ApiController < ApplicationController

 include HTTParty

	def process_ride
       	scode=get_pnr_status()
        puts scode 
        get_station_coordinates(scode)
	end

        def uber_ride
		 s = Net::HTTP.get_response(URI.parse("https://sandbox-api.uber.com/v1/products?latitude=19.0728300&longitude=72.8826100&access_token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZXMiOlsicHJvZmlsZSIsImhpc3RvcnkiLCJyZXF1ZXN0Il0sInN1YiI6ImZiOGUwYTlkLTg5ZmMtNGEwMi1hOTlmLWNjZGQ2MjNkZWRiNCIsImlzcyI6InViZXItdXMxIiwianRpIjoiYzVlYThiZjktNzYyYy00YTQ0LTllYmMtNDgzOGFhYTc3ODY4IiwiZXhwIjoxNDcwMjE1Njg5LCJpYXQiOjE0Njc2MjM2ODgsInVhY3QiOiJoaVVWVWg2NWZ2NzMwUHFFYnl1b0ltRUR1cmNoVEYiLCJuYmYiOjE0Njc2MjM1OTgsImF1ZCI6Ik5sckFncWRMT0dkZUJ1X0o5aE5ETmQ4UEQ5Q3Vkc2dDIn0.Cc2Mp8sIvN09_p8HsXFnbg6ebOwO5djO5JudlaAGbdbpRAu0DVLdCWw10NIyAg0Z-qgyySRl5YcU_2q_CMPOFYEjp6ttDyIL0ZAAc1borB2ocg-xjBTsr-px9WXW9MfGxtCpvTUTbzEhvg1HTHn9tTKadZ2Z7G0lyUCeyLzZ1OrqhUgDpeF9mevUjbob22YHk4-92OKnoqDqunG4khDYV8G_EnmdScxkjWm5Ut46M4o84bbW_Q2FpYXXEUXdtQ6GuQg0KvvvOEAdn4dft7-hyltRiB1khHjkmWxGwdJfj3c2EkENX50cQ1bd9uZ3L7wH7P6HiEsuMFO2P-ivmFVQPg")).body
     q = JSON.parse(s)
     @var=q["products"][0]["product_id"]
     puts "#{@var}"
p q


        base_uri = 'https://sandbox-api.uber.com/v1/requests'
         options ={ query: {product_id: @var, start_latitude: 19.1068, start_longitude: 72.8989, end_latitude: 19.1197, end_longitude: 72.9051}}


	response = HTTParty.get(base_uri, options)
          puts "--------uber request------------"
	puts response.body, response.code, response.message, response.headers.inspect
       end

#Replace hardcoded PNR by pnr provided in request
	def get_pnr_status(pnr="4220338987")
	 s = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/pnr_status/pnr/#{pnr}/apikey/cbgmi8296/")).body
     q = JSON.parse(s)
     @scode=q["from_station"]["code"]	
     return "#{@scode}"
p q
	end

#Replcae hardcoded ADH staion with source staion code from get_pnr_status
	def get_station_coordinates(scode)
		s = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/code_to_name/code/#{scode}/apikey/cbgmi8296/")).body
          @q = JSON.parse(s)["stations"]
          @q.each do |stncode|
    		if stncode["code"] .eql? "#{scode}"
    			puts stncode["lat"]
    			puts stncode["lng"]
                	return stncode["lat"],stncode["lng"]
    		end
	  end
	end

	def get_user_cordinates
	end

	def get_distance_and_time
	end

	def db_store
	end
end
