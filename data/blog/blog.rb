#! /usr/bin/env ruby
require 'fileutils'

posts = Dir.glob('posts/*.md').map {|f|
  File.open(f)
}.sort {|a, b|
  b.ctime <=> a.ctime
}

FileUtils.cp(posts.first.path, 'last')

File.open('index', 'w') {|f|
  f.write posts.map {|p|
    title = p.read.lines.first

    next if !title || title.strip.empty?

    "* [#{title.strip}](#page=blog/posts/#{File.basename(p.path)}&type=blog) posted on #{p.ctime}#{" modified on #{p.mtime}" if p.ctime.to_i != p.mtime.to_i}"
  }.compact.join("\n")
}

File.open('last', 'a') {|f|
  f.write %{<div class="older"><a href="#page=blog/index&#{rand}&type=blog">Older posts</a></div>}
}
