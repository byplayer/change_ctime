# frozen_string_literal: true

require 'bundler/setup'
require 'time'
require 'mini_exiftool'

def update_utime(dir)
  # puts "-----------"
  list = Dir.glob(File.join(dir, '*')).sort
  i = 0
  list.each do |f|
    puts f
    if File.directory?(f)
      update_utime(f)
      next
    end
    
    dirname = File.dirname(f)
    # puts dirname
    parent_name = File.basename(dirname)
    # puts parent_name
    next unless parent_name =~
                /.*([0-9]{4})\.*([0-9]{2})\.*([0-9]{2})/

    file_time = Time.strptime(Regexp.last_match[1] +
                              Regexp.last_match[2] +
                              Regexp.last_match[3],
                              '%Y%m%d') + i

    exif_data = MiniExiftool.new(f)
    if exif_data && exif_data['CreateDate']    
      file_time = exif_data['CreateDate']
    end
    puts file_time
    i += 1
    File.utime(file_time,
               file_time,
               f)
    cmd = "setfile -d \"#{file_time.strftime('%m/%d/%Y %H:%M:%S')}\" \"#{f}\""
    puts cmd
    `#{cmd}`
  end
end

update_utime(ARGV[0])

