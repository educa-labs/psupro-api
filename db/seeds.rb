require 'csv'

def read_tsv file_name
  return CSV.read(
    Rails.root.join('lib', 'seeds', file_name), { headers: true,
                                                  col_sep: "\t", })
end

def read_csv file_name
  return CSV.read(
    Rails.root.join('lib', 'seeds', file_name), { headers: true,
                                                  col_sep: ",", })
end
require 'base64'

#to seed the db with encoded pictures
def encode_picture(file,output)
  enc = Base64.encode64(File.open(file,'rb'){|io| io.read})
  File.open(Rails.public_path.to_s +  '/images/'+ output,'w') do |f|
    enc.gsub!("\n",'')
    f.write enc
  end
end

admin = User.create! do |user|
  user.email = "admin@asd.cl"
  user.password = "123123"
  user.password_confirmation = "123123"
  user.first_name = "ignacio"
  user.last_name =  "soffia"
  user.admin = true
end


if ENV['seed_pictures'] == '1'
  University.all.each do |u|
    u.profile_picture = u.id.to_s
    u.cover_picture = u.id.to_s
    u.profile_extension = "png"
    u.cover_extension = "png"
    puts "/images/seeds/cover/#{u.cover_picture}.#{u.cover_extension}"
    encode_picture(Rails.public_path.to_s + "/images/seeds/cover/#{u.cover_picture}.#{u.cover_extension}","universities/cover/#{u.id.to_s}")
    encode_picture(Rails.public_path.to_s + "/images/seeds/profile/#{u.profile_picture}.#{u.profile_extension}","universities/profile/#{u.id.to_s}")
    u.save
  end
  Area.all.each do |a|
    encode_picture(Rails.public_path.to_s + "/images/seeds/areas/#{a.id.to_s}.png","areas/#{a.id.to_s}")
  end

else
  cl = Country.create(title: 'Chile')
  s1 = Subject.create({title:"Lenguaje"})
  s2 = Subject.create({title:"Matemáticas"})
  s3 = Subject.create({title:"Historia"})
  s4 = Subject.create({title:"Ciencias Naturales"})

  # Cargar ciudades y regiones
  read_csv("ciudades_chile.csv").each do |row|
    puts "Ciudad y region #{row['ciudad']} , #{row['region']}"
    region = Region.find_or_create_by!(title: row['region'], country: cl )
    ciudad = City.create!(title: row['ciudad'] , region: region )
  end

  # Areas
  areas_hash = {}
  read_tsv('areas.tsv').each do |row|
    areas_hash[row['title']] = Area.create!(title: row['title'])
  end

  # University types
  university_types_hash = {}
  read_tsv('university_types.tsv').each do |row|
    university_types_hash[row['title']] = UniversityType.create!(title: row['title'])
  end

  # Universities
  boolean_hash = { 'Si' => true, 'No' => false }
  type_hash = { 'Profesional' => 1, 'Tecnico' => 2 }
  covers = Dir[Rails.public_path.to_s +  '/images/seeds/cover']
  profiles = Dir[Rails.public_path.to_s +  '/images/seeds/profile']

  universities_hash = {}
  read_tsv('universidades.tsv').each do |row|
    University.create! do |u|
      u.id =                row['ID']
      u.foundation =        row['Fundación'].to_datetime
      u.website =           row['Sitio web']
      u.freeness =          boolean_hash[row['Gratuidad']]
      u.motto =             row['Lema']
      u.title =             row['Nombre']
      u.initials =          row['Sigla']
      u.students =          row['Nro de Alumnos']
      u.teachers =          row['Nro de Profesores']
      u.degrees =           row['Numero de grados']
      u.postgraduates =     row['Nro de post-grados']
      u.doctorates =        row['Nro de doctorados']
      u.description =       row['Descripción']
      u.level =             row['Nivel']
      u.university_type_id =   university_types_hash[row['Tipo']].id
      u.profile_picture = row['ID']
      u.cover_picture = row['ID']
      u.profile_extension = "png"
      u.cover_extension = "png"
      puts u.initials
      puts "/images/seeds/cover/#{u.cover_picture}.#{u.cover_extension}"
      encode_picture(Rails.public_path.to_s + "/images/seeds/cover/#{u.cover_picture}.#{u.cover_extension}","universities/cover/#{row['ID']}")
      encode_picture(Rails.public_path.to_s + "/images/seeds/profile/#{u.profile_picture}.#{u.profile_extension}","universities/profile/#{row['ID']}")
    end
    puts "[DEBUG] #{row['Nombre']}"
  end

  read_tsv('descripciones.tsv').each do |row|
    u = University.find_by(id: row['id'])
    u.description = row['description']
    u.save
  end


  campus_hash = {}
  read_tsv('campuses.tsv').each do |row|
    # FIX: Se está evitando crear algunos campus ya que el tsv se encuentra inc-
    # ompleto. Puedes dar cuenta de esto añadiendo "!" a los métodos "find_or_-
    # create_by" y "create".
    if row['Ciudad'] == nil
      next
    end
    city = City.find_or_create_by(title: row['Ciudad'], region_id: row['id_region'])

    Campu.create!(
      id:            row['ID'],
      title:         row['Nombre'],
      university_id: row['ID Universidad'],
      lat:           row['Latitud'],
      long:          row['Longitud'],
      address:       row['Dirección'],
      city:          city,
    )
  end

  certification_hash = { 'Si' => true, 'No' => false }


  degrees_hash = {}
  read_tsv('carreras.tsv').each do |row|
    puts "[DEBUG] Begin #{row['Nombre']}"
    car = Carreer.create!(
      title: row['Nombre'],
      university_id: row['ID Universidad'],
      campu_id: row['ID Campus'],
      certification: certification_hash[row['Acreditación']],
      openings: row['Vacantes'],
      semesters: row['Cant. Semestres'],
      price: row['Arancel'],
      area: areas_hash[row['Área']],
      schedule: row['Horario'],
      employability: row['Empleabilidad'],
      income: row['Ingreso'],
      admission: row['Admisión'],
      degree_type: type_hash[row['Tipo']],
      #TODO importante !!! se debe agregar soporte para los dos cortes
      last_cut: row['Corte 2017'],
      description: row['Descripción']
      )
    w = Weighing.create!(
      language: row['Lenguaje'],
      math: row['Matemáticas'],
      history: row['Historia (Cs. Sociales)'],
      science: row['Ciencias'],
      NEM: row['NEM'],
      ranking: row['Ranking'],
      carreer_id: car.id
      )
    # car.save
    w.carreer_id = car.id
    w.save
  end
end
