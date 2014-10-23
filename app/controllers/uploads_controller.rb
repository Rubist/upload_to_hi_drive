class UploadsController < ApplicationController
	require 'net/ftp'

	def new
	end

	def create_file
		file = params[:file][:datafile]
		File.open(Rails.root.join('app','assets', 'images', file.original_filename), 'wb') do |f|
			f.write(file.read)
			uploaded_file_path = "app/assets/images/#{file.original_filename}"
			Net::FTP.open('ftp.drivehq.com') do |ftp|
				ftp.passive = true
				ftp.login('user_name','password')
				ftp.chdir('My Documents/uploads')
				ftp.putbinaryfile(uploaded_file_path, remotefile = File.basename(uploaded_file_path))
				puts ftp.last_response
				ftp.close
			end	
		end

		redirect_to new_upload_path
	end
end
