#moe-dict-cat-crawler

針對http://dict.revised.moe.edu.tw/分類詞典的crawler實作

##Usage

`ruby crawler.rb OUTPUT_FILE_NAME`

範例輸出：dict-cat.json

##Todo

* 罕見字的處理：missing資料夾下是所有罕見字的圖檔，檔名是按照 categoryId_entryId.jpg 這樣命名
	* 可能需要工人智慧查詢對應的unicode之類的？
	
##Note
* 該網站上的詞典分類上加註的數量是錯的，與實際entry數量不同 
