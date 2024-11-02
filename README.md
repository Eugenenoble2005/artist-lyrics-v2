# artist-lyrics-v2

I use this to display random lyrics from my favourite artists on my desktop using some widget library like ags or eww. If you want to use it to, you can just clone this repo and run main.rb with an artist you like. Example: 

```ruby main.rb --artist "Kendrick Lamar" ```. 

You must set the $GENIUS_API_KEY environmental variable to your genius api key which you can get for free at https://www.genius.com/api-client.

You must also install the nokogiri gem for parsing HTML:
```
gem install nokogiri
```
