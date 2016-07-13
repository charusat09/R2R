class ApiController < ApplicationController

 def get_pnr_status
        if request.post?
         s = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/pnr_status/pnr/#{params[:pnr]}/apikey/zcjpr6611/")).body
         q = JSON.parse(s)
    	  p "trueeeeeeeeeeeeeeeee #{q}"
	 if q["error"] != true
	  @pnr = params[:pnr]
          @scode=q["from_station"]["code"]
          @status = q["passengers"][0]["current_status"]
	  @doj=q["doj"]
	  @train_no=q["train_num"]
	 end
        end
        #
 end


 def address
     if request.post?
	if params[:address].present?
        	p = params[:address].gsub!(' ', '%20')
      	end
        #Get user coordinates
         address = Net::HTTP.get_response(URI.parse("https://api.mapmyindia.com/v3?fun=geocode&lic_key=5h9mbi7h2jvdszbvzcir1c4llwohp9rt&q=#{p}")).body
	addr = JSON.parse(address)
	@user_lat = addr[0]["lat"]
	@user_long = addr[0]["lng"]
	#Get Station coordinates
  	stn = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/code_to_name/code/#{params[:scode]}/apikey/zcjpr6611/")).body
	@stn_coord = JSON.parse(stn)["stations"]
	@stncord = @stn_coord.select {|a| a["code"].eql? params[:scode]}
	@stn_lat = @stncord[0]["lat"]
	@stn_long = @stncord[0]["lng"]

	#Get Duration
	dur = Net::HTTP.get_response(URI.parse("https://api.mapmyindia.com/v3?fun=star_dists&lic_key=5h9mbi7h2jvdszbvzcir1c4llwohp9rt&center=#{@user_lat},#{@user_long}&pts=#{@stn_lat},#{@stn_long}&rtype=0&vtype=1&avoids=0110")).body
	dura = JSON.parse(dur)
	@duration = dura[0]["duration"]
	@booking_time = (@duration.to_i+3600)/60
	puts "booookkkk #{@booking_time}"

	#get train boarding time
	#board = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/pnr_status/pnr/#{params[:pnr]}/apikey/cbgmi8296/")).body
	board = Net::HTTP.get_response(URI.parse("http://api.railwayapi.com/route/train/#{params[:train_no]}/apikey/zcjpr6611/")).body
       	boarding = JSON.parse(board)
	puts "44444444444444444444444444--------- #{boarding}----------------- #{boarding.class}"
	board_stn = boarding["route"].select{|brd| brd["code"].eql? params[:scode]}
	@trn_time = board_stn[0]["schdep"]
	puts "yeeeeeeeeeeeeeeee-------------- #{ params[:train_no]}"
	@booking_time = @trn_time.to_time - 1.hour
	puts "finallllllllllllllllllll #{@booking_time}"
	@user = User.create(:user_name => params[:name], :email => params[:email])
        if @user
        	@api = ApiDetail.create(:user_id => @user.id, :pnr_number => params[:pnr], :travel_date => params[:doj], :station_lat => @stn_lat, :station_long => @stn_long, :address => params[:address], :location_lat => @user_lat, :location_long => @user_long, :booking_time => @booking_time)
     	end

    end
 end

end
