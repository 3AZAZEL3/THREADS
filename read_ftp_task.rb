Module.modify :Repetitive_Tasks_Poller do

	methods :read_ftp_task => %q{#{}
		def read_ftp_task ctx=nil
			# создание глобального хеша для залипших потоков
      $zalip ||= {}
      # оборачивание в поток работы драйвера
			thrd = Thread.new do
				require 'net/ftp'
				directory = NBStarter.tmp_dir
				Dir.mkdir(directory) unless File.directory?(directory)
				ftp_path = "TEMP/LOGS/History/"
				names = []
				ip, username, password = User::ServiceFtp.get_setting_for_connection
        # открытие FTP соединения
				Net::FTP.open(ip, username, password){|ftp|
					ftp.mkdir(ftp_path) if ftp.dir(ftp_path).empty?
					ftp.chdir(ftp_path)
					ftp.list.each do |path|
            # проверка наличия инструкции для выполнения
						if path.include?("instructions")
							name = path.split()
							name = name[-1]
							names << name
							ftp.get(name,directory + "/#{name}")
						end
					end
          # Перебор всех подходящих файлов
					names.compact.each do |name|
					filepath = File.join(directory, name)
					f = File.read(filepath)
					data = JSON.parse(f)
					status_busy ||= 0
					ftp_path = ftp_path + data['road'] + "/" + data['cluster'] + "/"
          # Если инструкия относится к текущему драйверу - выполнение.
					if data['road'] == User::ServiceSpb.get_base.upcase.to_s && data['cluster'] == User::ServiceSpb.get_cluster.upcase.to_s && data['topology_nodes'] == $control.this_node.name
						# Проверка на занятость потока (Инструкций может быть несколько)
            if status_busy == 0
							status_busy = 1
							eval(data['executable_command'])
							ftp.delete(name)
							File.delete(filepath) if File.exist?(filepath)
							status_busy = 0
						end
					end
				end
				}
			end
      # Проверка залипших потоков, если такие имеются
			time = Time.now.to_i
			$zalip[time] = thrd
			hash = $zalip.select{|x| x.to_i < (Time.now.to_i - 5*60)}
			hash.values.each do |v|
        # Если поток жив более 5 минут, требуется его убить
				v.kill if v.alive?
			end
      # Очищение списка потоков от мертвых потоков или потоков которые еще имеют право существовать
			$zalip = $zalip.select{|x| x.to_i >= (Time.now.to_i - 5*60)}
		end

	}
end
