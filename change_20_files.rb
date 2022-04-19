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

files.sort!

sec = 0
min = 0
old_date = ''
files.each do |f|
  next unless File.file?(f)
  basename = File.basename(f)
  puts f
  if File.size(f) == 0
    puts "  error:file size is 0!!!!!!"
    exit(1)
  end

  file_time = nil

  exif = nil
  begin
    exif = MiniExiftool.new(f, ignore_minor_erros: true)
    puts '  exif exists'
  rescue => _e
  end
  if exif && exif.date_time_original
    file_time = exif.date_time_original
    puts "  exif date_time_original:#{file_time}"
    base = File.basename(f, '.*') + File.extname(f).downcase
  elsif exif && exif.MediaCreateDate
    file_time = exif.MediaCreateDate
    puts "  exif MediaCreateDate:#{file_time}"
    base = File.basename(f, '.*') + File.extname(f).downcase
  elsif basename =~
    /^(2[0-9]{3})[-_]?([0-9]{2})[-_]?([0-9]{2})[-_\.]?([0-9]{6})/
    file_time = nil
    year = Regexp.last_match[1]

    file_time = Time.strptime(year +
      Regexp.last_match[2] +
      Regexp.last_match[3] + ' ' +
      Regexp.last_match[4], '%Y%m%d %H%M%S')

    puts "  #{file_time}"
    base = File.extname(f).downcase
    puts "  base: #{base}"

    puts '  change ctime and exif'
    # change_exif_date_time_original(f, file_time) if '.jpg' == File.extname(f).downcase
  elsif basename =~  /^Screenshot[ _]([0-9]{4})-([0-9]{2})-([0-9]{2})[ -]([0-9]{2})-([0-9]{2})-([0-9]{2})/
    file_time = Time.strptime(Regexp.last_match[1]+
                              Regexp.last_match[2]+
                              Regexp.last_match[3]+
                              Regexp.last_match[4]+
                              Regexp.last_match[5]+
                              Regexp.last_match[6],
                              '%Y%m%d%H%M%S')
    puts 'Screenshot'
    puts "  #{file_time}"
    base = File.extname(f).downcase
    puts "  base: #{base}"
  elsif basename =~
              /^(2[0-9]{3})[-_]?([0-9]{2})[-_]?([0-9]{2})[-_]?(.*)([-_]?[0-9]*)?/

    file_time = nil
    year = Regexp.last_match[1]
    # year ||= '2001'

    if old_date == year + Regexp.last_match[2] + Regexp.last_match[3]
      sec += 1
      if sec >= 60
        sec = 0
        min += 1
      end
    else
      old_date = year + Regexp.last_match[2] + Regexp.last_match[3]
      sec = 0
      min = 0
    end

    file_time = Time.strptime(year +
      Regexp.last_match[2] +
      Regexp.last_match[3] + ' ' +
      '00' + format('%02d', min) + format('%02d', sec),
                              '%Y%m%d %H%M%S')

    puts "  #{file_time}"
    base = File.extname(f).downcase
    fbase = Regexp.last_match[4]
    unless /^\.[a-zA-Z]+$/ =~ fbase
      base = File.basename(fbase, '.*') + File.extname(f).downcase
    end
    puts "  base: #{base}"

    puts '  change ctime and exif'
    # change_exif_date_time_original(f, file_time) if '.jpg' == File.extname(f).downcase
  else
    puts "!!!!!! error !!!!!!"
    exit(1)
  end
  change_ctime(f, file_time)
  rename_date_prefix(f, base, file_time) if file_time
end