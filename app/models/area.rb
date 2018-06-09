class Area < ApplicationRecord


  # Returns string for base64 image injection on html.
  def encoded_picture
    "data:image/png;base64,#{File.open('public/images/areas/' + self.id.to_s,'rb').read}"
  end

  # Creates file with base64 image data.
  def save_picture(data)
    File.open('public/images/areas/'+ self.profile_picture,'w') do |f|
      f.write data
    end
  end

end
