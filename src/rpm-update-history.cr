require "dotenv"
require "helper"
require "option_parser"
require "transactions"

module Rpm::Update::History
  VERSION = "0.1"

  pm = Helper.package_binary
  Dotenv.load
  Helper.package_manager_installed? pm
  Helper.db_check
  used_subcommand = false

  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{PROGRAM_NAME} [subcommand]"

    opts.on("-b", "--build", "Compile history info") do
      used_subcommand = true
      Transactions.build pm
    end

    # opts.on("-g", "--graph", "Create statistic graphs") do
    #   used_subcommand = true
    # end

    # opts.on("-l", "--list", "List compiled statistics")  do
    #   used_subcommand = true
    # end

    # opts.on("-u", "--upload", "Upload data to a central repository")  do
    #   used_subcommand = true
    # end

    # opts.on("-v", "--version", "Show version number")  do
    #   used_subcommand = true
    # end

    opts.on("-h", "--help", "Prints this help") do
      used_subcommand = true
      puts opts
      exit
    end
  end

  parser.parse

  unless used_subcommand
    puts parser
    exit 1
  end
end
