require 'bundler'
require 'sitemap_treemaker'
require "net/https"
require "uri"

sitemap_tree = SitemapTreemaker::Sitemap.new('http://artsy.net/sitemap.xml')
puts "There're #{sitemap_tree.tree.children.count} entries in this map."

http = Net::HTTP.new('m.artsy.net', 443)
http.use_ssl = true

sitemap_tree.tree.breadth_each do |node|

  parts = []
  parent = node
  while parent
    parts.insert 0, parent.name if parent.parent
    parent = parent.parent
  end

  url = '/' + parts.join('/')

  STDOUT.write url

  request = Net::HTTP::Head.new(url)
  request.initialize_http_header({ "User-agent" => "Safari/Mobile" })
  response = http.request(request)
  puts (response.code == '200' ? ' [ok]' : " [#{response.code}] <--- ERROR")
end




