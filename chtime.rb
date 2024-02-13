# frozen_string_literal: true

require 'bundler/setup'
require 'time'
require 'mini_exiftool'
require_relative 'lib/file_tools'

def update_utime(dir)
  # puts "-----------"
  old_date = ''

  list = Dir.glob(File.join(dir, '*')).sort
  i = 0
  list.each do |f|
    puts f
    if File.directory?(f)
      update_utime(f)
      next
    end

    bname = File.basename(f)
    next unless bname =~
                /.*([0-9]{4})\.*([0-9]{2})\.*([0-9]{2})/

    if old_date == "#{Regexp.last_match[1]}#{Regexp.last_match[2]}#{Regexp.last_match[3]}"
      i += 1
    else
      old_date = "#{Regexp.last_match[1]}#{Regexp.last_match[2]}#{Regexp.last_match[3]}"
      i = 0
    end

    file_time = Time.strptime(Regexp.last_match[1] +
                              Regexp.last_match[2] +
                              Regexp.last_match[3],
                              '%Y%m%d') + i

    puts file_time

    change_exif_date_time_original(f, file_time)
    change_ctime(f, file_time)
  end
end

if ARGV.size != 1
  puts 'usage: bundle exec ruby chtime TARGET_DIR'
  exit 1
end

update_utime(ARGV[0])
