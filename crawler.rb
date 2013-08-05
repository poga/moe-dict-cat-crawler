require 'nokogiri'
require 'open-uri'
require 'pp'
require 'json'
require 'iconv'

cat_uri = "http://dict.revised.moe.edu.tw/cgi-bin/newDict/dict.sh?idx=dict.idx&cond=.&pieceLen=5000&fld=1&cat=5202&imgFont="
doc = Nokogiri::HTML(open("http://dict.revised.moe.edu.tw/"))

categories = {}
categorie_tags = doc.css("//select[@class=text]/option")

categorie_tags.to_a.each.with_index do |c,i|
  next if i == 0
  cid = c.attributes["value"].value
  _, cname, ccount = c.children.text.match(/(.+)\((.+)\)/).to_a

  next if cname.nil?
  puts [cname.gsub("　", ""), ccount].join(' ')

  categories[cid.to_i] = { :name => cname.gsub("　", ""), :entries => [], :count => ccount.to_i}
end

iconv = Iconv.new("utf-8//IGNORE", "big5")

skipped = []

categories.keys.each do |cid|
  print '.'
  cat_url = "http://dict.revised.moe.edu.tw/cgi-bin/newDict/dict.sh?idx=dict.idx&cond=.&pieceLen=5000&fld=1&cat=#{cid}&imgFont="

  page = Nokogiri::HTML(iconv.iconv(open(cat_url).read))
  page.css("//table[@width='90%']/tr/td/a").each do |x|
    if x.children[0].nil?
      skipped << [cid, x.attributes["href"].value.match(/\((.+)\)/)[1]]
      next
    end
    categories[cid][:entries] << x.children[0].text
  end
end

categories.each_pair do |cid, c|
  puts "#{c[:name]}(#{cid}): #{c[:entries].size} entries"
end

File.open(ARGV[0], 'w') do |f|
  f.puts JSON.pretty_generate(categories.each_pair.map { |k,v| { :id => k, :name => v[:name], :entries => v[:entries]} })
end

skipped.each do |cid, i|
  puts "skipped: #{cid} / #{i+1}"
end
