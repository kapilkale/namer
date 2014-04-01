require "whois"

threads = []

f = File.open("names.txt")
body = f.read
body.downcase.split(" ").uniq.map{|l| l.gsub(/[^0-9a-z ]/i, '')}.each do |b|
  t = Thread.new do
    begin
      c = Whois::Client.new
      name = "#{b}.com"
      r = c.lookup(name)
      puts "#{name} - available\n" if r.available?
    rescue Exception => e
      puts "#{name} - exception\n"
    end
  end
  threads << t
end

threads.each do |t|
  t.join
end
