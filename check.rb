#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

require 'net/http'

# ターゲットファイルの読み込み
target = 'http://www.provider-navi.jp/'

# ターゲットの数分だけ回す
uri = URI(target)
bad_uris = Array.new

Net::HTTP.start(uri.host, uri.port) do |http|
  request = Net::HTTP::Get.new uri

  response = http.request request # Net::HTTPResponse object
  bad_uris.push(uri) if response.code != "200"
end

# ダメだったファイルの出力
p bad_uris.length
