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
  basename = File.basename(f)
  puts basename

  next unless basename =~
              /^(9[0-9])_([0-9]{2})_([0-9]{2})[-_](.*)([-_][0-9]+)/

  if old_date == Regexp.last_match[1] + Regexp.last_match[2] + Regexp.last_match[3]
    sec += 1
    if sec >= 60
      sec = 0
      min += 1
    end
  else
    old_date = Regexp.last_match[1] + Regexp.last_match[2] + Regexp.last_match[3]
    sec = 0
    min = 0
  end
  file_time = Time.strptime('19' + Regexp.last_match[1] +
    Regexp.last_match[2] +
    Regexp.last_match[3] + ' ' +
    '00' + format('%02d', min) + format('%02d', sec),
                            '%Y%m%d %H%M%S')

  puts file_time
  change_ctime(f, file_time)
  change_exif_date_time_original(f, file_time) if '.jpg' == File.extname(f).downcase
  rename_date_prefix(f, Regexp.last_match[4] + File.extname(f),
                     file_time)
end
