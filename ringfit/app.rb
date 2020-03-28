require "open-uri"
require "nokogiri"
require "slack/incoming/webhooks"
#require "pp"

slack = Slack::Incoming::Webhooks.new ENV["SLACK_WEBHOOK_URL"]

html = URI.open("https://min-zaiko.com/ring-fit-adventure") { |f| f.read }

doc = Nokogiri::HTML.parse(html)

(2..4).to_a.each do |i|
  doc.xpath("//*[@id=\"__next\"]/div/main/section[" + i.to_s + "]/article/ul").children.each do |e|
    shop_name =  e.xpath("div[1]/div/a").children.text
    exist_str =  e.xpath("div[2]/div/span[1]/a").children.text.to_s
    p "#{shop_name}: #{exist_str}"
    if exist_str[0,4] != "なさそう"
      slack.post "#{shop_name}: #{exist_str}"
    end
  end
end
