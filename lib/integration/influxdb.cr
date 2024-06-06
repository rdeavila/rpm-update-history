require "colorize"
require "config"
require "http/client"
require "json"
require "sqlite3"

module Integration::InfluxDB
  def self.send
    sent_transactions = [] of Int64

    begin
      DB.open Config.db_path do |db|
        db.query "SELECT * FROM transactions WHERE sent = 0 ORDER BY id DESC;" do |rs|
          rs.each do
            transaction_id     = rs.read(Int64)
            transaction_date   = rs.read(String)
            transaction_time   = Helper.date_to_epoch(transaction_date)
            status             = rs.read(String)
            installed_packages = rs.read(Int64)
            updated_packages   = rs.read(Int64)
            removed_packages   = rs.read(Int64)

            puts "Uploading data for transaction #{transaction_id}..."

            metric = "#{Config.influxdb_measurement},host=#{System.hostname},transaction_id=#{transaction_id} installed=#{installed_packages},updated=#{updated_packages},removed=#{removed_packages} #{transaction_time}"

            headers = HTTP::Headers.new
            headers["Authorization"] = "Token #{Config.influxdb_api_token}"
            headers["Content-Type"]  = "text/plain; charset=utf-8"
            headers["Accept"]        = "application/json"

            begin
              response = HTTP::Client.post(Config.influxdb_host_url, headers: headers, body: metric)

              case response.status_code
              when 204
                sent_transactions << transaction_id
              when 401
                STDERR.print "ERROR: ".colorize :red
                STDERR.puts "Connection to InfluxDB was not authorized. Exiting."
                exit 1
              when 404
                STDERR.print "ERROR: ".colorize :red
                STDERR.puts "The InfluxDB server don't have the configured bucket. Exiting."
                exit 1
              else
                STDERR.print "ERROR: ".colorize :red
                STDERR.puts response.body
                exit 1
              end
            rescue e
              STDERR.print "ERROR: ".colorize :red
              STDERR.puts e.message
              exit 1
            end
          end
        end

        puts "Updating local data..."

        DB.open Config.db_path do |db|
          sent_transactions.each do |id|
            db.exec "UPDATE transactions SET sent = ? WHERE id = ?;", true, id
          end
        end

        puts "Done."
      end
    rescue r
      STDERR.print "ERROR: ".colorize :red
      STDERR.puts r.message
      exit 1
    end
  end
end
