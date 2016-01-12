require 'net/http'
require 'nokogiri'
require 'uri'


class BuzzfeedParser
  attr_reader :page
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
    p @headlines
  end
end


class Headline
  def initialize(args={})
    @text = args[:text]
  end

end

# parse = BuzzfeedParser.new('buzzfeed_sample.html')
parse = BuzzfeedParser.new('http://www.buzzfeed.com/celebrity')