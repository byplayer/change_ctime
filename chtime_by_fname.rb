# frozen_string_literal: true

require 'time'

Dir.glob(File.join(ARGV[0], '**', '*')) do |f|
  puts f
  basename = File.basename(f)
  puts basename
  next unless basename =~
              /^([0-9]{4})-?([0-9]{2})-?([0-9]{2})[-_]([0-9]{2})([0-9]{2})([0-9]{2})/

  file_time = Time.strptime(Regexp.last_match[1] +
                            Regexp.last_match[2] +
                            Regexp.last_match[3] + ' ' +
                            Regexp.last_match[4] +
                            Regexp.last_match[5] +
                            Regexp.last_match[6], 
                            '%Y%m%d %H%M%S')
  puts file_time
  File.utime(file_time,
             file_time,
             f)
  cmd = "setfile -d \"#{file_time.strftime('%m/%d/%Y %H:%M:%S')}\" '#{f}'"
  `#{cmd}`
end
