code = ARGV[0]
# 処理の開始時刻を取得する
start_time = Time.now
File.open("KEN_ALL.CSV", "r:shift_jis").each_line do |line|
	line.chomp!
	rows = line.split(/,/)
	zipcode = rows[2].gsub(/"/, '')
	if zipcode == code
		puts line.encode('utf-8')
	end
end
# 処理が終了した時刻との差を表示する
p Time.now - start_time