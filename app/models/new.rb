class New < ApplicationRecord

  # Returns well formatted date.
  def date
    self.created_at.strftime("%d-%m-%Y")
  end

  # Returns string with base64 image for injection in html.
  def encoded_picture
    "data:image/#{self.extension};base64,#{File.open('public/images/news/' + self.picture,'rb').read}"
  end


  def save_picture(data)
    File.open('public/images/news/'+ self.picture,'w') do |f|
      data.gsub!("\n",'')
      f.write data
    end
  end


  def update_picture(params)
    puts "SAVING PICTURES"
    if params[:picture] && params[:extension]
      self.picture = self.id
      self.extension = params[:extension]
      self.save_picture(params[:picture])
      self.save
    end
  end
end
