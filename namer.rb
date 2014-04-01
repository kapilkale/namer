require "whois"

threads = []

f = File.open("names.txt")
body = f.read

# Filter words to check. Modify character length as you please.
words_to_check = body.downcase.split(" ").uniq
    .map{|l| l.gsub(/[^0-9a-z ]/i, '')}
    .select{|l| l.length < 5}
    

words_to_check.each_with_index do |b, index|
  t = Thread.new do
    begin
      c = Whois::Client.new

      # Run checks with specific characters attached.
      prepend = ""
      append = ""
      name = "#{prepend}#{b}#{append}.com"

      # Actually do lookup.
      r = c.lookup(name)
      puts "#{name} - available\n" if r.available?
    rescue Exception => e
      #puts "#{name} - #{e}\n" unless e.is_a? Errno::ECONNRESET
    end
  end
  threads << t

  # Never more than 100 threads at once.
  if index > 0 && index % 100 == 0
    threads.each do |t|
      t.join
    end
    threads = []
  end
end

# Close out the threads.
threads.each do |t|
  t.join
end
