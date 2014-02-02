# -*- encoding: utf-8 -*-
require 'tweetstream'
require 'twitter'
require 'natto'
require 'levenshtein'
require 'shellwords'
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


def extractNoun(str)
  nouns=[]
  nm = Natto::MeCab.new
  nm.parse(str) do |n|
    type = n.feature.split(",")[0]
    nouns.push(n.surface) if type == "名詞"
  end
  return nouns[0]
end

def similar(s1, s2, threshold = 2)
  d = Levenshtein.distance(toKatakana(s1), toKatakana(s2))
  d <= threshold
end

def toKatakana(str)
  safe_str = str.gsub(/[!-\/:-@\[-`{-~] /, '').strip.shellescape
  `echo #{safe_str} | nkf -e | kakasi.dSYM -JK -HK | nkf -w`
end

def searchforTweets(str)
  c = []
  Twitter.search("#{str}", :count => 50, :result_type => "latest").results.map do |status|
    next if status.text.include?("RT") or status.text.include?("http") or status.text.include?(".co") or status.text.include?("@")
    c.push("#{status.text.gsub("\n","")}")
  end
  p c.max
end

input = gets.to_s

subject = extractNoun(input)

content = searchforTweets(subject)#.slice!(rand(subject.length)))
p content
content.slice!(0..content.index("#{subject}")-1)

puts "#{subject} #{content}"


