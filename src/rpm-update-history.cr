require "helper"
require "option_parser"

module Rpm::Update::History
  VERSION = "0.1.0"
  options = {} of Symbol => Bool

  parser = OptionParser.new do |opts|
    opts.on("-b", "--build", "Compile history info") { options[:build] = true }
    opts.on("-g", "--graph", "Create statistic graphs") { options[:graph] = true }
    opts.on("-h", "--help", "Prints this help") do
      puts opts
      exit
    end
    opts.on("-l", "--list", "List compiled statistics") { options[:list] = true }
    opts.on("-u", "--upload", "Upload data to a central repository") { options[:upload] = true }
  end

  parser.parse

  unless Helper.binary_installed? "dnf"
    STDERR.puts "dnf is not installed. Exiting."
    exit 1
  end

  puts parser
  exit 1
end
