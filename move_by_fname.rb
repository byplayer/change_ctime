# frozen_string_literal: true

require_relative 'lib/file_tools'

unless ARGV.length == 2
  puts "usage: ruby #{File.basename(__FILE__, '*.*')} target_dir dest_dir"
  exit(2)
end

dest_dir = ARGV[1]

Dir.glob(File.join(ARGV[0], '**', '*')) do |f|
  puts f
  basename = File.basename(f)
  puts basename
  next unless basename =~
              /^([0-9]{4})-?([0-9]{2})-?([0-9]{2})[-_]?([0-9]{2})([0-9]{2})([0-9]{2})/

  file_time = Time.strptime(Regexp.last_match[1] +
                            Regexp.last_match[2] +
                            Regexp.last_match[3] + ' ' +
                            Regexp.last_match[4] +
                            Regexp.last_match[5] +
                            Regexp.last_match[6],
                            '%Y%m%d %H%M%S')

  dir = File.join(dest_dir, file_time.localtime.strftime('%Y%m'),
                  file_time.localtime.strftime('%Y%m%d'))
  FileUtils.mkdir_p(dir)
  puts file_time
  FileUtils.mv(f, check_fname_overlapping(File.join(dir, File.basename(f))))
end
