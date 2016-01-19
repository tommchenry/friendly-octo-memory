require 'net/http'
require 'nokogiri'
require 'uri'
require_relative 'common_words'

class BuzzfeedParser
  attr_reader :page, :headlines
  def initialize(url)
    uri = URI(url)
    url_string = Net::HTTP.get(uri) #returns a string
    # url_string = File.read(url) #work from sample html
    nokogiri_document = Nokogiri.parse(url_string)
    @headlines = []
    nokogiri_document.css('.lede__link').text.split("\n").each do |headline|
      if headline.strip != ""
        @headlines << Headline.new(text: headline.strip)
      end
    end
    @headlines
  end
end


class USWeeklyParser
  attr_reader :page, :headlines
  def initialize(url)
    uri = URI(url)
    url_string = Net::HTTP.get(uri) #returns a string
    # url_string = File.read(url) #work from sample html
    nokogiri_document = Nokogiri.parse(url_string)
    @headlines = []
    nokogiri_document.css('h2').each do |headline|
      @headlines << Headline.new(text: headline.text)
    end
    @headlines
  end
end

class Headline
  attr_reader :text
  def initialize(args={})
    @text = args[:text]
  end

end

class HeadlineEater
  def initialize(headline)
    @headline = headline
  end

  def eat
    @headline.split.delete_if{|word| $common_words.include?(word.downcase)}.join(' ')
  end
end


# parse = BuzzfeedParser.new('buzzfeed_sample.html')
# parse = BuzzfeedParser.new('http://www.buzzfeed.com/celebrity')
# parse = USWeeklyParser.new('us_weekly_sample.html')
# parse = USWeeklyParser.new('https://www.usmagazine.com/celebrity-news')
finished_headlines = []
parse.headlines.each do |headline|
  headline_eater = HeadlineEater.new(headline.text)
  if headline_eater.eat != ""
    finished_headlines << headline_eater.eat
  end
end
p finished_headlines