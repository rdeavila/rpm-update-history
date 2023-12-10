require "config"
require "sqlite3"
require "tallboy"

module Transactions
  BINARY = Config.package_binary

  def self.list_transactions
    `#{BINARY} history list | cut -d '|' -f 1 | sed -n '/^ /p'`
      .split("\n")
      .map { |item| item.strip }
      .reject { |item| item.to_s.empty? }
  end

  def self.build
    transactions = list_transactions
    count        = 0

    DB.open Config.db_path do |db|
      transactions.each do |transaction|
        if (db.scalar "select count(*) from transactions where id = ?;", transaction) == 0
          info = `#{BINARY} history info #{transaction}`
            .split("\n")
            .map { |item| item.strip }
            .reject { |item| item.to_s.empty? }

          begin_time  = Time.utc
          return_code = ""
          installed   = 0
          upgraded    = 0
          removed     = 0

          info.each do |line|
            if line.starts_with? "Begin time     :"
              begin_time = Time.parse(line.split(" : ")[1], "%c", Time::Location.local)
            end

            if line.starts_with? "Return-Code    :"
              return_code = line.split(" : ")[1]
            end

            if line.starts_with? "Install "
              installed = installed + 1
            end

            if line.starts_with? "Upgrade "
              upgraded = upgraded + 1
            end

            if line.starts_with? "Removed "
              removed = removed + 1
            end
          end

          args = [] of DB::Any
          args << transaction
          args << begin_time
          args << return_code
          args << installed
          args << upgraded
          args << removed
          args << false

          db.exec "INSERT INTO transactions values (?, ?, ?, ?, ?, ?, ?)", args: args

          puts "Compiling transaction ##{transaction}: I#{installed}/U#{upgraded}/R#{removed}"
          count = count + 1
        end
      end

      puts "Done. #{count} new transactions compiled."
    end
  end

  def self.list
    record_count = 0

    table = Tallboy.table do
      columns do
        add "ID"
        add "Date"
        add "Status"
        add "Installed"
        add "Upgraded"
        add "Removed"
      end
      header

      DB.open Config.db_path do |db|
        db.query "SELECT * FROM transactions ORDER BY id DESC;" do |rs|
          rs.each do
            record_count = record_count + 1

            row [
              "#{rs.read(Int64)}",
              "#{rs.read(String)}",
              "#{rs.read(String)}",
              "#{rs.read(Int64)}",
              "#{rs.read(Int64)}",
              "#{rs.read(Int64)}"
            ]
          end
        end
      end
    end

    puts table.render
    puts "Transactions compiled: #{record_count}"
  end
end
