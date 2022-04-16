# frozen_string_literal: true

require 'fileutils'
require 'mini_exiftool'
require 'time'

# change file create time for Mac and atime and mtime.
#
# This command change file create time on Mac and atime
# and mtime.
# This function call setfile command.
# _path_ :: target file path
# _time_ :: time information to change
def change_ctime(path, time)
  File.utime(time, time, path)
  cmd = "setfile -d \"#{time.strftime('%m/%d/%Y %H:%M:%S')}\" '#{path}'"
  `#{cmd}`
end

# change exif date time origial information
#
# This function use exiftool so you need install it.
# _path_ :: target file path
# _time_ :: time information to change
def change_exif_date_time_original(path, time)
  photo = MiniExiftool.new(path, ignore_minor_erros: true)
  photo.date_time_original = time.localtime.strftime('%Y:%m:%d %H:%M:%S')
  # photo.gps_date_stamp = time.utc.strftime('%Y:%m:%d')
  # photo.gps_time_stamp = time.utc.strftime('%H:%M:%S')
  photo.save!
end

# rename file name basedon time prefix
def rename_date_prefix(path, base_name, time)
  if File.basename(path) =~ /^#{time.localtime.strftime('%Y%m%d%H%M%S')}/
    puts "  time prefix already set so skip:#{path}"
    return
  end

  dest_file = File.join(File.dirname(path),
                        time.localtime.strftime('%Y%m%d%H%M%S') +
                        base_name)
  unless base_name[0] == "."
    dest_file = File.join(File.dirname(path),
                          time.localtime.strftime('%Y%m%d%H%M%S') +
                          '_' + base_name)
  end

  dest_file = check_fname_overlapping(dest_file)
  puts "  move to #{dest_file}"

  FileUtils.mv(path, dest_file)
end

def check_fname_overlapping(fname)
  #String{dir, base, result, suffix, r}, m, m1

  return fname unless File.exist?(fname)
  dir  = File.dirname(fname)
  base = File.basename(fname)
  m = /(.+)(\..+)$/.match(base)
  result, suffix = m ? [m[1], m[2]] : [base, ""]

  begin
    result = if (m1 = /(.+)_(\d+)$/.match(result))
      m1[1] + "_#{format('%03d', (m1[2].to_i + 1))}"
    else
      result + "_001"
    end
  end while File.exist?(r = File.join(dir, result + suffix))
  r
end