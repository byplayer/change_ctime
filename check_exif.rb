require 'mini_exiftool'

photo = MiniExiftool.new(ARGV[0], ignore_minor_erros: true)

puts photo.date_time_original

if photo && photo.date_time_original
  puts "OK"
end

if photo && photo.MediaCreateDate
  puts "media create date:#{photo.MediaCreateDate}"
end

puts photo.inspect
