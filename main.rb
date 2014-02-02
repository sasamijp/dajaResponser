# -*- encoding: utf-8 -*-
require 'tweetstream'
require 'twitter'
require 'bimyou_segmenter'
require 'natto'
require './key.rb'

Twitter.configure do |config|
   config.consumer_key        = Const::CONSUMER_KEY
   config.consumer_secret     = Const::CONSUMER_SECRET
   config.oauth_token            = Const::ACCESS_TOKEN
   config.oauth_token_secret  = Const::ACCESS_TOKEN_SECRET
end
TweetStream.configure do |config|
   config.consumer_key        = Const::CONSUMER_KEY
   config.consumer_secret     = Const::CONSUMER_SECRET
   config.oauth_token            = Const::ACCESS_TOKEN
   config.oauth_token_secret  = Const::ACCESS_TOKEN_SECRET
   config.auth_method            = :oauth
end
client = TweetStream::Client.new

client.userstream do |status|
  if status.text.include?("@sa2mi") && !status.text.include?("RT") then
def extractNoun(str)
  nouns=[]
  nm = Natto::MeCab.new
  nm.parse(str) do |n|
    type = n.feature.split(",")[0]
    nouns.push(n.surface) if type == "名詞"
  end
  return nouns[0]
end

def searchforTweets(str)
  c = []
  Twitter.search("#{str}", :count => 50, :result_type => "latest").results.map do |status|
    next if status.text.include?("RT") or status.text.include?("http") or status.text.include?(".co") or status.text.include?("@")
    c.push("#{status.text.gsub("\n","")}")
  end
  p c.max
end

input = status.text.gsub("@sa2mi ","")

subject = extractNoun(input)

content = searchforTweets(subject)#.slice!(rand(subject.length)))
p content
content.slice!(0..content.index("#{subject}")-1)

puts "#{subject} #{content}"
Twitter.update("@#{status.user.screen_name} #{subject}「#{content}」")

end
end
