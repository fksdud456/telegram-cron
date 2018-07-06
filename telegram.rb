require 'rest-client'
require 'json'
require 'nokogiri'

token = ENV["telegram_token"]
url = "https://api.telegram.org/bot#{token}"
puts url
updates = "#{url}/getUpdates"

response = RestClient.get(updates)
res = JSON.parse(response)
user_id = res['result'][0]['message']['from']['id']
user_name = res['result'][0]['message']['from']['first_name']

msg = "안녕 #{user_name}"

# 삼각대
# response = RestClient.get("http://prod.danawa.com/info/?pcode=3547016")

# op.gg
# opgg = "http://www.op.gg/summoner/spectator/userName=%EC%9A%B0%EB%A6%AC%20%EB%A7%8C%EB%82%A8%EC%9D%80&"
# http://www.op.gg/summoner/userName=%EB%96%A1%EC%83%81%EC%A1%B4%EB%B2%84%EA%B0%80%EC%A6%88%EC%95%84
# http://www.op.gg/summoner/userName=wantgoodlucky
opggurl = "http://www.op.gg/summoner/spectator/userName="
opgg = URI.encode("#{opggurl}우리만남은}")

response =  RestClient.get(opgg, headers={"Accept-Language": "ko-KR,ko"})

# response = RestClient::Request.execute(
#     method: :get,
#     url: opgg,
#     headers: {"Accept-Language": "ko-KR,ko"}
# )

opgg_doc = Nokogiri::HTML(response)
summoner = opgg_doc.css(".SpectateSummoner")
title = summoner.css(".Title").text
mapName = summoner.css(".MapName").text

unless summoner.empty?
   msg =  "#{msg} \n #{title} #{mapName}에 있습니다. \n"
end


# .은 class / #은 id 로 
test = summoner.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-spectator > div.SpectateSummoner > div > div.Content > table.Table.Team-100 > tbody")
test = summoner.css(".Content").css(".SummonerName.Cell")
test = summoner.css(".Content").css(".TierRank")

# team1 = summoner.css("table.Table.Team-100 > tbody")
# team1.each do |body|
#     body.css(".Row").each do |row|
#     puts row.css(".SummonerName.Cell").text.strip 
#     puts row.css(".TierRank").text.strip
#   end
# end

# team2 = summoner.css("table.Table.Team-200 > tbody")
# team2.each do |body|
#     body.css(".Row").each do |row|
#     puts row.css(".SummonerName.Cell").text.strip 
#     puts row.css(".TierRank").text.strip
#   end
# end

table = summoner.css("div.Box table.Table")
table.each do |table|
    table.css("tbody").each do |body|
        body.css(".Row").each do |row|
        msg << row.css(".SummonerName.Cell").text.strip << " "
        msg << row.css(".TierRank").text.strip << "\n"
    end
  end
end

msg = "#{msg}\n "
msg_url = URI.encode("#{url}/sendmessage?chat_id=#{user_id}&text=#{msg}")
RestClient.get(msg_url)

# opggurl = "http://www.op.gg/summoner/spectator/userName="
# opgg ="#{opggurl}#{URI.encode("wantgoodlucky")}"
