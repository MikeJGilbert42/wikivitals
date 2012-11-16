#!/usr/bin/env ruby
require "optparse"
THIS_FILE = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
THIS_DIR = File.dirname(File.expand_path THIS_FILE)
require THIS_DIR + "/../app/models/wiki_fetcher.rb"

HELP = 'Must specify Wikipedia article names in quotes, e.g. "Dave_Thomas_(American_businessman)" "Einstein" ...'

def get_articles(args)
  args.each do |arg|
    body = WikiFetcher.get_article_body arg
    file_name = arg
    File.delete file_name if File.exists? file_name
    File.open "#{THIS_DIR}/#{file_name}.raw", "w"  do |file|
      file << body
    end
  end
end

def error(msg)
  STDERR.puts msg
  exit 1
end

get_articles ARGV
error HELP if ARGV.empty?
