require_relative 'lib/file_tools'

unless ARGV.length == 3
  puts "usage: ruby #{File.basename(__FILE__, '*.*')} YYYYMMDD HH target_dir"
  exit(2)
end

ymd = ARGV[0]
hour = ARGV[1].to_i

min = 0
sec = 0
Dir.glob(File.join(ARGV[2], '**', '*')) do |f|
  puts f

  file_time = Time.strptime("#{ymd}#{format('%02d%02d%02d', hour, min, sec)}",
                            '%Y%m%d%H%M%S')
  new_fname = "#{file_time.strftime('%Y%m%d%H%M%S')}_#{File.basename(f)}"
  new_path = check_fname_overlapping(File.join(File.dirname(f), new_fname))
  puts "  move to:#{new_path}"
  FileUtils.mv(f, new_path)
  change_ctime(new_path, file_time)

  min += 1
  if min >= 60
    min = 0
    hour += 1
  end
end