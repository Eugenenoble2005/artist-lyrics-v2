require_relative "genius.rb"
if ARGV[0] != "--artist" 
 puts "No artist provided. Exiting..."
 return;
end

artist = ARGV[1];

genius = Genius.new(ENV["GENIUS_API_KEY"]);
cache_file_path = "cache.txt"


#create cache file if it does not exist
unless File.exist?(cache_file_path)
  File.write(cache_file_path,"")
end

begin
   #get lyric and add it to the cache file
   lyric = genius.get_random_lyric_by_artist(artist)
   puts lyric
   File.open(cache_file_path,"a") {
    |file|
    file.puts(lyric + "\r\n")
   }
rescue 
   #could not get lyric for whatever reason. Read from cache instead
   lines = File.readlines(cache_file_path)
   random_line = lines.sample
   puts "[CACHE]:" + random_line
end 

 
