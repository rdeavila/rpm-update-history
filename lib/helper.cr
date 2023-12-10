require "colorize"
require "config"
require "time"

module Helper
  def self.user_check
    unless Config.running_via_shards?
      unless `whoami` == "root\n"
        STDERR.print "ERROR: ".colorize :red
        STDERR.puts "you must be root to run this command. Exiting."
        exit 1
      end
    end
  end

  def self.db_check
    DB.open Config.db_path do |db|
      test = db.exec "CREATE TABLE IF NOT EXISTS transactions (
        id INTEGER PRIMARY KEY,
        created_at TIMESTAMP,
        return_code TEXT,
        installed INTEGER,
        upgraded INTEGER,
        removed INTEGER,
        sent BOOLEAN
      );"
    end
  end

  def self.date_to_epoch(date : String) : String
    time = Time.parse(date, "%F %T.%L", Time::Location.local)
    time.to_s "%s"
  end

  def self.string_to_time(date : String) : Time
    Time.parse(date, "%F %T.%L", Time::Location.local)
  end
end
