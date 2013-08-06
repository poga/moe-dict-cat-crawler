require 'nokogiri'
require 'open-uri'
require 'pp'
require 'json'
require 'iconv'

doc = Nokogiri::HTML(open("http://dict.revised.moe.edu.tw/"))

categories = {}
categorie_tags = doc.css("//select[@class=text]/option")

categorie_tags.to_a.each.with_index do |c,i|
  next if i == 0

  cid = c.attributes["value"].value
  _, cname, ccount = c.children.text.match(/(.+)\((.+)\)/).to_a
  next if cname.nil?

  categories[cid.to_i] = { :name => cname.gsub("　", ""), :entries => [], :count => ccount.to_i}
end

iconv = Iconv.new("utf-8//IGNORE", "big5")

categories.keys.each do |cid|
  cat_url = "http://dict.revised.moe.edu.tw/cgi-bin/newDict/dict.sh?idx=dict.idx&cond=.&pieceLen=5000&fld=1&cat=#{cid}&imgFont=1"

  page = Nokogiri::HTML(iconv.iconv(open(cat_url).read))
  page.css("//table[@width='90%']/tr/td/a").each do |x|
    entry = x.children.map do |c|
      if c.name == "img"
        "{[#{c.attributes["src"].value.match(/images\/(.+)\.jpg/)[1]}]}"
      else
        c.text.gsub(' ','')
      end
    end.join

    categories[cid][:entries] << entry
  end
end

puts JSON.pretty_generate(categories.each_pair.map { |k,v| { :id => k, :name => v[:name], :entries => v[:entries]} })
