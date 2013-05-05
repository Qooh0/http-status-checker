#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

require 'net/http'
require_relative 'file_read_recursive'

bad_404_uris = Array.new
bad_4xx_uris = Array.new
bad_5xx_uris = Array.new
bad_else_uris = Array.new

# ターゲットファイルの読み込み
FileReadRecursive.getUrls().each do |target|

  # ターゲットの数分だけ回す
  uri = URI(target)

  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Get.new uri

    response = http.request request # Net::HTTPResponse object

    case response
    when Net::HTTPSuccess # 200
      next
    when Net::HTTPNotFound # 404
      bad_404_uris.push(uri)
    when Net::HTTPClientError # 4xx
      bad_4xx_uris.push(uri)
    when Net::HTTPServerError # 5xx
      bad_5xx_uris.push(uri)
    else
      bad_else_uris.push(uri) 
    end
  end

end

# ファイルの出力
open('results.txt', 'w') do |f|
  f.write "-- 404 -- \n"
  bad_404_uris.each do |uri|
    f.write uri + "\n"
  end
  f.write "-- 4xx -- \n"
  bad_4xx_uris.each do |uri|
    f.write uri + "\n"
  end
  f.write "-- 5xx -- \n"
  bad_5xx_uris.each do |uri|
    f.write uri + "\n"
  end
  f.write "-- else -- \n"
  bad_else_uris.each do |uri|
    f.write uri + "\n"
  end
end
