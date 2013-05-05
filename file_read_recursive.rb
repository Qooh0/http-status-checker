#!/usr/bin/env ruby
# -*- encoding : utf-8 -*-

require 'find'

module FileReadRecursive
  def getUrls
    urls = Array.new

    Find.find('target-urls') do |path|
      if FileTest.directory?(path)
        if File.basename(path)[0] == '.'
          # . ディレクトリを読み込まない
          Find.prune
        else
          next
        end
      else
        if File.basename(path)[0] != '.'
          # . ファイルを読み込まない
          # list にする
          f = open(path)
          f.each { |line| urls.push(line.rstrip!) }
          f.close
        end
      end
    end

    return urls
  end

  module_function :getUrls
end


