#moe-dict-cat-crawler

針對http://dict.revised.moe.edu.tw/分類詞典的crawler實作

##Usage

###砍資料
`ruby moe-dict-cat-crawler.rb > dict-revised.json`

###處理罕見字
`perl json2unicode.pl sym-pua.txt > dict-cat-revised.pua.json`

json2unicode.pl來自於 [https://github.com/g0v/moedict-epub/blob/master/json2unicode.pl](http://)

sym-pua.txt來自於 [https://github.com/g0v/moedict-epub/blob/master/sym-pua.txt](http://)

##Todo

* ~~罕見字的處理：missing資料夾下是所有罕見字的圖檔，檔名是按照 categoryId_entryId.jpg 這樣命名~~
	
##Note

* 該網站上的詞典分類上加註的數量是錯的，與實際entry數量不同 
