

# 以下是用来做daemon的
# pid_path = Dir.getwd + "/.pid"

# def start_daemon(pid)
#   Process.daemon(true)
#   write_pid
#   
#   while true
#     sleep(0.1)
#   end
# end
#   
# def status
#   puts pidfile_process_status.to_s
# end
# 
# def stop
#   pid = read_pid
#   return $stderr.puts "No running syncbox process." if pid == 0      
#   Process.kill("HUP", pid)
#   $stderr.puts "Stopped." # ? No judge
# end
# 
# def read_pid
#   return File.read(pid_path).to_i if File.exist?(pid_path)
#   0
# end
# 
# def write_pid
#   File.open(pid_path, File::CREAT | File::EXCL | File::WRONLY ){ |f| f.write("#{Process.pid}") }
#   at_exit { File.delete(pid_path) if File.exist?(pid_path) }
# rescue Errno::EEXIST
#   check_pid!
#   retry
# end
# 
# def check_pid!
#   case pidfile_process_status
#   when :running, :not_owned
#     $stderr.puts "A server is already running. Check #{pid_path}."
#     exit(1)
#   when :dead
#     File.delete(pid_path)
#   end
# end
# 
# def pidfile_process_status
#   return :exited unless File.exist?(pid_path)
# 
#   pid = File.read(pid_path).to_i
#   return :dead if pid == 0
# 
#   Process.kill(0, pid)
#   :running
# rescue Errno::ESRCH
#   :dead
# rescue Errno::EPERM
#   :not_owned
# end
  
# def self.start
# 
#   pid_file = Dir.getwd + "/.pid"
#   if File.exist?(pid_file)
#     pid = IO.read(pid_file,5).to_i
#   else
#     # File.new()
#   end
#   
#   if pid == 0
#     Process.daemon(true)
#     pid = Process.pid
#     pid_file = Dir.getwd + "/.pid"
#     File.open(pid_file, 'w') { |file| file.write(pid) }
#   
#     Signal.trap("HUP") {
#       File.open(pid_file, 'w') { |file| file.write("") }  # clear pid file when exit.
#       exit
#     }
#     Monitor.new(@opts)
#   else
#     exit
#   end
#   
#   # Listen will start a new background subprocess. 
#   # Kill the current process will also kill the background listen subprocess.
# end
# 
# 
# def self.status
#   pid_file = Dir.getwd + "/.pid"
#   pid = IO.read(pid_file,5).to_i
#   puts "Running Process id #{pid}."
# 
#   begin
#     Process.getpgid(pid)  # return process group id 
#     status = true
#   rescue Errno::ESRCH
#     status = false
#   end
#   puts "#{pid}'s existance is #{status}"
# end
# 
# 
# def self.stop
#   pid_file = Dir.getwd + "/.pid"
#   pid = IO.read(pid_file,5).to_i
#   
#   if pid == 0
#     puts "There is not running background process."
#   else
#     puts "Running Process id #{pid}."  
#     if Process.kill("HUP", pid)
#       puts "pid #{pid} stopped."
#     else
#       puts "No such process #{pid}"
#     end
#   end
# end
  
  
  # def self.file_status
  #   config_load
  #   config_check
  #   auth_config = @opts
  # 
  #   # s3 files
  #   AWS.config(:access_key_id => auth_config[:access_key_id], :secret_access_key => auth_config[:secret_access_key])
  #   s3 = AWS::S3.new
  #   bucket = s3.buckets[auth_config[:bucket_name]]
  #   s3_files = bucket.objects.map {|obj| obj.key }
  # 
  #   # local files
  #   local_files = Dir.entries(auth_config[:directory_path]).reject {|fn| [".",".."].include?(fn) }
  #   
  #   total_files = local_files + s3_files
  #   total_uniq_files = total_files.uniq
  #   longest_key = total_files.max_by {|x| x.length } 
  #   length = longest_key.length
  # 
  #   # print table
  #   printf "%-#{length}s %-10s %-4s\n", "File Name".center(length), "Local", "S3"
  #   total_uniq_files.each do |file|
  #     printf "%-#{length}s %-10s %s\n", file, local_files.include?(file), s3_files.include?(file)
  #   end    
  # end
  