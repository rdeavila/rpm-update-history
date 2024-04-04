require "config"
require "helper"
require "option_parser"
require "transactions"
require "integration/influxdb"

module Rpm::Update::History
  VERSION = "24.04.0"
  used_subcommand = false

  Helper.user_check
  Helper.db_check

  parser = OptionParser.new do |opts|
    opts.banner = "Usage: #{PROGRAM_NAME} [subcommand]"

    opts.on("-b", "--build", "Compile history info") do
      used_subcommand = true
      Transactions.build
    end

    # opts.on("-g", "--graph", "Create statistic graphs") do
    #   used_subcommand = true
    # end

    opts.on("-l", "--list", "List all compiled statistics") do
      used_subcommand = true
      Transactions.list
    end

    opts.on("-u", "--upload", "Upload data to a central repository") do
      used_subcommand = true

      case Config.integration
      when "influxdb"
        Integration::InfluxDB.send
      else
        STDERR.print "ERROR: ".colorize :red
        STDERR.puts "No integration configured. Run 'man rpm-update-history' to see how to configure one."
        exit 1
      end
    end

    opts.on("-v", "--version", "Show version number") do
      used_subcommand = true
      puts "RPM Update History version #{VERSION}"
    end

    opts.on("-h", "--help", "You know what this option does") do
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
