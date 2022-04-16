# frozen_string_literal: true

require_relative 'lib/file_tools'

unless ARGV.length == 1
  puts "usage: ruby #{File.basename(__FILE__, '*.*')} target_dir"
  exit(2)
end

files = []

Dir.glob(File.join(ARGV[0], '**', '*')) do |f|
  files << f
end

files.each do |f|
  exif = MiniExiftool.new(f, ignore_minor_erros: true)
  file_time = exif.date_time_original
  puts f
  puts "  org time:#{file_time.strftime('%Y%m%d %H%M%S')}"
  # plus 1 year
  new_time = Time.strptime(file_time.strftime('2007%m%d %H%M%S'),
  '%Y%m%d %H%M%S')
  puts "  new time:#{new_time.strftime('%Y%m%d %H%M%S')}"

  if file_time == new_time
    puts '  skip due to already updated'
    next
  end

  change_exif_date_time_original(f, new_time)

  dir_name = File.dirname(f)

  basename = File.basename(f)

  if basename =~ /^[0-9]{14}_(.*)/
    new_fname = new_time.strftime('%Y%m%d%H%M%S') + '_' +
      Regexp.last_match[1]
    new_path = File.join(dir_name, new_fname)
    puts "  new path:#{new_path}"
    FileUtils.mv(f, new_path)
  else
    puts 'file name error!!!!'
    exit(1)
  end
end
