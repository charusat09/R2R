class SendEmail < ApplicationMailer
	default from: "mpatel@gmail.com"
	def send_uber_confirmation user,status, pnr
		email = user.emal
		@status = status
		@pnr = pnr

		mail to: email, subject: "Uber status for PNR #{pnr} : #{@status}"
	end
end
