class ApiController < ApplicationController

 def get_pnr_status
        if request.post?
         s = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/pnr_status/pnr/#{params[:pnr]}/apikey/cbgmi8296/")).body
         q = JSON.parse(s)
	 if q["error"] != true
          @scode=q["from_station"]["code"]
          @status = q["passengers"][0]["current_status"]
	 end
        end
        #
 end

end
