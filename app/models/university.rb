class University < ApplicationRecord

  validates_presence_of :website
  has_many :campus
  belongs_to :university_type
  
  searchkick language: "spanish"

  def search_data
    {
      title: title,
      description: description,
      initials: initials,
      level: level,
      cities: cities,
      regions: regions
    }
  end


  # Returns array of self's city ids.
  def cities
    self.campus.map {|x| x.city.id}
  end

  # Returns array of self's region ids.
  def regions
    self.campus.map {|x| x.city.region_id}
  end

  def u_type
    self.university_type.title
  end

  # Returns string with base64 profile image for injection in html.
  def encoded_profile_picture
    "data:image/#{self.profile_extension};base64,#{File.open('public/images/universities/profile/' + self.profile_picture,'rb').read}"
  end

  # Returns string with base64 cover image for injection in html.
  def encoded_cover_picture
    "data:image/#{self.cover_extension};base64,#{File.open('public/images/universities/cover/' + self.cover_picture,'rb').read}"
  end

  def self.profile_hash(ids)
    universities = where(id:ids)
    return universities.map { |x| [x.id,x.encoded_profile_picture]}.to_h
  end

  def self.cover_hash(ids)
    universities = where(id:ids)
    return universities.map { |x| [x.id,x.encoded_cover_picture]}.to_h
  end
  # Creates file with base64 profile image data.
  def save_profile_picture(data)
    File.open('public/images/universities/profile/'+ self.profile_picture,'w') do |f|
      data.gsub!("\n",'')
      f.write data
    end
  end

  # Creates file with base64 cover image data.
  def save_cover_picture(data)
    File.open('public/images/universities/cover/'+ self.cover_picture,'w') do |f|
      data.gsub!("\n",'')
      f.write data
    end
  end

  def update_pictures(params)
    puts "SAVING PICTURES"
    if params[:cover] && params[:cover_extension]
      self.cover_picture = self.id
      self.cover_extension = params[:cover_extension]
      self.save_cover_picture(params[:cover])
    end
    if params[:profile] && params[:profile_extension]
      puts "SAVING Profile"
      self.profile_picture = self.id
      self.profile_extension = params[:profile_extension]
      self.save_profile_picture(params[:profile])
    end
    self.save()
  end 


end
