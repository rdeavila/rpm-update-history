require "colorize"
require "ini"
require "time"

module Config
  CONFIG = load_config

  def self.load_config : Hash
    begin
      INI.parse(File.new("/etc/rpm-update-history.conf"))
    rescue File::NotFoundError
      STDERR.print "ERROR: ".colorize :red
      STDERR.puts "config file not found: /etc/rpm-update-history.conf"
      exit 1
    end
  end

  def self.package_binary : String
    binary = "dnf"

    File.each_line("/etc/os-release") do |line|
      binary = "yum" if line == "NAME=\"CentOS Linux\""
      break
    end

    unless binary_installed? binary
      STDERR.print "ERROR: ".colorize :red
      STDERR.puts "#{binary} is not installed. Exiting."
      exit 1
    end

    return binary
  end

  def self.binary_installed?(binary_name : String) : Bool
    `which #{binary_name} 2>/dev/null`.to_s.chomp.size > 0
  end

  def self.db_path
    begin
      CONFIG["database"]["file"]
    rescue KeyError
      "sqlite3:///var/lib/rpm-update-history/ruh.db"
    end
  end

  def self.integration : String
    integration = "none"

    begin
      CONFIG["influxdb"]["host-url"]
      CONFIG["influxdb"]["measurement"]
      CONFIG["influxdb"]["api-token"]
      integration = "influxdb"
    rescue KeyError
      # Nothing to see here. Move along!
    end

    return integration
  end

  def self.influxdb_host_url : String
    begin
      CONFIG["influxdb"]["host-url"]
    rescue KeyError
      STDERR.print "ERROR: ".colorize :red
      STDERR.puts "config not found: [\"influxdb\"][\"host-url\"]"
      exit 1
    end
  end

  def self.influxdb_measurement : String
    begin
      CONFIG["influxdb"]["measurement"]
    rescue KeyError
      STDERR.print "ERROR: ".colorize :red
      STDERR.puts "config not found: [\"influxdb\"][\"measurement\"]"
      exit 1
    end
  end

  def self.influxdb_api_token : String
    begin
      CONFIG["influxdb"]["api-token"]
    rescue KeyError
      STDERR.print "ERROR: ".colorize :red
      STDERR.puts "config not found: [\"influxdb\"][\"api-token\"]"
      exit 1
    end
  end

  def self.running_via_shards? : Bool
    begin
      puts CONFIG["shards-execution"]
      return true
    rescue KeyError
      return false
    end
  end
end
