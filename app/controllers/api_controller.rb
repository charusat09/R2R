class ApiController < ApplicationController

 def get_pnr_status
        if request.post?
         s = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/pnr_status/pnr/#{params[:pnr]}/apikey/cbgmi8296/")).body
         q = JSON.parse(s)
    	  p "trueeeeeeeeeeeeeeeee #{q}"
	 if q["error"] != true
	  @pnr = params[:pnr]
          @scode=q["from_station"]["code"]
          @status = q["passengers"][0]["current_status"]
	 end
        end
        #
 end


 def address
      if params[:address].present?
	p = params[:address].gsub!(' ', '%20')
      end
	#Get user coordinates
  address = Net::HTTP.get_response(URI.parse("https://api.mapmyindia.com/v3?fun=geocode&lic_key=5h9mbi7h2jvdszbvzcir1c4llwohp9rt&q=#{p}")).body
	#Get Station coordinates
  	stn = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/code_to_name/code/#{params[:scode]}/apikey/cbgmi8296/")).body
	@stn_coord = JSON.parse(stn)["stations"]
          @stn_coord.each do |stncode|
                if stncode["code"] .eql? "#{scode}"
                        return stncode["lat"],stncode["lng"]
                end
          end

	#Get Duration
	dur = Net::HTTP.get_response(URI.parse("https://api.mapmyindia.com/v3?fun=star_dists&lic_key=5h9mbi7h2jvdszbvzcir1c4llwohp9rt&center=#{user_lat},#{user_lng}&pts=#{stn_lat},#{stn_lng}&rtype=0&vtype=1&avoids=0110")).body

                duration = JSON.parse(dur)
                return duration[0]["duration"]
  address_get = JSON.parse(address) 
     @user = User.create(:user_name => params[:user_name], :email => params[:email])
     if @user
	@api = ApiDetail.create(:user_id => @user.id, :pnr_number => params[:pnr_number], :travel_date => params[:travel_date], :address => params[:address]) 
     end
   p "choooooooooooooooooooooo #{address_get}"  

 end

end
