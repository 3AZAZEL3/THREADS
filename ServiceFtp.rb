Module.create :ServiceFtp do
	methods :_self_send_file_on_ftp => %q{##{}
		def self.send_json_file_on_ftp dir = nil
#			puts dir
			name = dir.split('/')[-1]
			file_path = dir.split('/')[0..-2]
			require 'net/ftp'
			ftp_path = "TEMP/LOGS/History"
      #ip - current ip FTP Storage
      #login - login FTP connection
      #password - pass FTP connection
			Net::FTP.open("#{ip}".to_s,"#{login}".to_s,"#{password}".to_s){|ftp|
				ftp.mkdir(ftp_path) if ftp.dir(ftp_path).empty?
				ftp.chdir(ftp_path)
				ftp.put(dir, name)
			}
			File.delete(dir)

		end},
		:_self_create_json => %q{##{}
		def self.create_json my_hash = nil
			prefix = Time.now.to_i
			name = "#{prefix}_instructions.json"
			filepath = File.join(@directory, name)
			FileUtils.mkdir_p(File.dirname(filepath))
			File.open(filepath, 'w'){|f| JSON.dump(my_hash, f)}
			name
		end
		},
		:_self_initialize => %q{##{}
		def self.initialize
			@directory = Dir.tmpdir
			@ip = nil
			@username = nil
			@password = nil
		end},
		:_self_create_hash_for_json => %q{##{}
		def self.create_hash_for_json mass
			if mass[3] == nil
				my_hash = {"road"=>mass[0],"cluster"=>mass[1],"topology_nodes"=>mass[2],"executable_command"=>"User::ServiceHistory.send_current_archives"}
			else
				my_hash = {"road"=>mass[0],"cluster"=>mass[1],"topology_nodes"=>mass[2],"executable_command"=>mass[3]}
			end
		end},
		:_self_send_json_ftp => %q{##{}
		def self.send_json_ftp mass = nil
			my_hash = create_hash_for_json(mass)
			name = create_json my_hash
			require 'net/ftp'
			ftp_path = "TEMP/LOGS/History"
			#ip - current ip FTP Storage
      #login - login FTP connection
      #password - pass FTP connection
			Net::FTP.open("#{ip}".to_s,"#{login}".to_s,"#{password}".to_s){|ftp|
				ftp.mkdir(ftp_path) if ftp.dir(ftp_path).empty?
				ftp.chdir(ftp_path)
				ftp.put(@directory + "/#{name}", name)
			}
			File.delete(@directory + "/#{name}")

		end},
		:_get_setting_for_connection => %q{##{}
		def self.get_setting_for_connection
			return @ip, @username, @password
		end}
end
