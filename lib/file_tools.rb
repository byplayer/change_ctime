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
  photo.date_time_original = time
  photo.save!
end

# rename file name basedon time prefix
def rename_date_prefix(path, base_name, time)
  dest_file = File.join(File.dirname(path),
                        time.strftime('%Y%m%d%H%M%S') +
                        '_' + base_name)
  puts base_name
  puts dest_file
  # FileUtils.mv(path, dest_file)
end
