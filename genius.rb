require 'net/http'
require 'uri'
require 'json'
require "nokogiri"
require "open-uri"
class Genius
  def initialize(api_key)
    @api_key = api_key
  end
   
 private def get_artist_id(artist)
    response_body = get_request("https://api.genius.com/search?q=#{artist}")
    artist_id = response_body["response"]["hits"][0]["result"]["primary_artist"]["id"]
   artist_id
  end

  def get_random_lyric_by_artist(artist)
    artist_id = get_artist_id(artist)

    #just check the first 15 pages for a song, can be increased for more songs
    random_page = rand(1..5)
    response_body  = get_request("https://api.genius.com/artists/#{artist_id}/songs?sort=popularity&page=#{random_page}")
    songs_count = response_body["response"]["songs"].length()

    random_song_index = rand(0..songs_count-1)

    random_song = response_body["response"]["songs"][random_song_index]
    random_song_url = random_song["url"]

    #web scrape
    doc = Nokogiri::HTML(URI.open(random_song_url))
    # puts random_song_url
    lyrics = [];
    doc.xpath("//div[@id='lyrics-root']//a").each {
      |a|
      # Replace <br> tags with spaces in the inner HTML
      cleaned_content = a.inner_html.gsub(/<br\s*\/?>/, ' ')
      # Parse it again to get the plain text,
      lyrics.push(Nokogiri::HTML.fragment(cleaned_content).text)
      #lyrics.push(a.content)
    }
    random_lyric_index = rand(0..lyrics.length()-1)

    #return this string
    lyrics[random_lyric_index] + " - " +  random_song["full_title"];
  end

   private   
   def get_request(url)
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.to_s)
    req["Authorization"] = "Bearer #{@api_key}"
    res = Net::HTTP.start(uri.host,uri.port,use_ssl:true) {
      |http| http.request(req)
    }
    response_body = JSON.parse(res.body)
    response_body
  end
end
