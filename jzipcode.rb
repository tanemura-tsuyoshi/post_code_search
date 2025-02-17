require 'sqlite3'

class JZipCode
  # ダウンロードしたCSVファイルの何列目が何のデータであるか
  COL_ZIP = 2
  COL_PREF = 6
  COL_CITY = 7
  COL_ADDR = 8

  # インスタンスの作成時にデータベースファイルを指定
  def initialize(dbfile)
    @dbfile = dbfile
  end

  # CSVファイルのデータからテーブルを作成する
  def make_db(zipfile)
    return if File.exists?(@dbfile)
    SQLite3::Database.open(@dbfile) do |db|
      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS zips
          (code TEXT, pref TEXT, city TEXT, addr TEXT, alladdr TEXT)
      SQL

      File.open(zipfile, 'r:shift_jis') do |zip|
        db.execute "BEGIN TRANSACTION"
        zip.each_line do |line|
          colums = line.split(/,/).map{|col| col.delete('"')}
          code = colums[COL_ZIP]
          pref = colums[COL_PREF]
          city = colums[COL_CITY]
          addr = colums[COL_ADDR]
          all_addr = pref + city + addr
          db.execute "INSERT INTO zips VALUES (?,?,?,?,?)",
            [code, pref, city, addr, all_addr]
        end
        db.execute "COMMIT TRANSACTION"
      end
    end
  end

  # 郵便番号で完全一致検索して
  # 郵便番号 住所を出力する
  def find_by_code(code)
    sql = "SELECT * FROM zips WHERE code = ?"
    str = ""
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(sql, code) do |row|
        str << sprintf("%s %s", row[0], row[4]) << "\n"
      end
    end
    str
  end

  # 住所で部分一致検索して
  # 郵便番号 住所を出力する
  def find_by_address(addr)
    sql = "SELECT * FROM zips WHERE alladdr LIKE ?"
    str = ""
    SQLite3::Database.open(@dbfile) do |db|
      db.execute(sql, "%#{addr}%") do |row|
        str << sprintf("%s %s", row[0], row[4]) << "\n"
      end
    end
    str
  end
end



