namespace :news do

  def encode_picture(file,output)
    enc = Base64.encode64(File.open(file,'rb'){|io| io.read})
    File.open(output,'w') do |f|
      enc.gsub!("\n",'')
      f.write enc
    end
  end
  #news_path= path to directory of news files
  #json_name = name of json file.
  #should run as rails news:add[news_path,file_name]
  desc "task to add a new new to the db"
  task :add, [:news_path,:json_name] => :environment do |task, args|
    require 'json'
    require 'base64'
    data = JSON.parse(File.read(args[:news_path] + args[:json_name]))
    New.create do |new|
      new.title = data['title']
      new.body = data['body']
      new.lowering = data['lowering']
      new.author = data['author']
      new.picture = data['picture']
      new.extension = data['extension']
      encode_picture("#{args[:news_path]}#{new.picture}.#{new.extension}",Rails.public_path.to_s + "/images/news/#{new.picture}")
    end
  end
end
