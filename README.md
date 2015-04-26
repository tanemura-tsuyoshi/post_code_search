# post_code_search
[概要]
郵便番号を検索できます。

[使用方法]
irb

・ファイル読み込み
> require "./jzipcode"
=> true

・インスタンス作成
> jzipcode = JZipCode.new("zip.db")
=> #<JZipCode:0x007f4ac46f6038 @dbfile="zip.db">

・データ登録
> jzipcode.make_db("KEN_ALL.CSV")
=> #<SQLite3::Database:0x007f4ac46fe0a8 @tracefunc=nil, @authorizer=nil, @encoding=#<Encoding:UTF-8>, @busy_handler=nil, @collations=äå, @functions=äå, @results_as_hash=nil, @type_translation=nil, @readonly=false>

・郵便番号で検索
> puts jzipcode.find_by_code("1060031")
1060031 東京都港区西麻布
=> nil

・住所で検索
> puts jzipcode.find_by_address("東京都渋谷区神")
1500047 東京都渋谷区神山町
1500001 東京都渋谷区神宮前
1500045 東京都渋谷区神泉町
1500041 東京都渋谷区神南
=> nil


[元データ]
・郵便局の公式サイト
http://www.post.japanpost.jp/zipcode/dl/kogaki-zip.html
にて「全国一括」よりzipでダウンロード
→ken_all.zip

・KEN_ALL.CSV
はカンマ区切りで
 1.
 2.
 3.郵便番号：半角数字7桁
 4.都道府県名：半角カタカナ
 5.市区町村名：半角カタカナ
 6.町域名：半角カタカナ
 7.都道府県名：漢字
 8.市区町村名：漢字
 9.町域名：漢字
というデータ構造

[参照]
たのしいRuby第4版23章:郵便番号を検索する

