##############################################################################
###
### Revolution R Enterprise 大數據匯入
### 李秉鴻
### 採智科技
### 
### 0.前言
### 1.辨認欄位長度
### 2.欄位數5000以下
### 3.欄位數5000至10000
### 4.欄位數10000以上
###
### 參考資料
### http://www.rdocumentation.org/packages/RevoScaleR/functions/rxImport
### http://www.rdocumentation.org/packages/RevoScaleR/functions/RxTextData
###
##############################################################################
#
# 0.前言
#
# 不經一事，不長一智，果然人類世界還是要需要經驗的。
# 難怪很多人不喜歡用非開源軟體，要找錯誤，網路上又沒有什麼資訊時，詢問窗口又很麻煩時
# 只好往原始碼動腦筋了，但找不到原始碼的時候，就會很幹了。
#
# rxImport在未定義type的情況下，只能轉10000個欄位的xdf檔
# 如果沒有定義type時, 又想匯入超過10000個欄位的檔案時
# 會出現ERROR : Line length is too long
# 會出現Error : rxCall("Rx_ImportDataSource",params)
#
##############################################################################
#
# 1.辨認欄位長度
#
# 建議匯入檔案前，先確認欄位個數，我們可以先僅讀一行，再透過切割，來確認欄位的多寡
# 
# varNamesTemp<-readLines("stage531_Indicator.csv",n=1)
# varName<-strSplit(VarNamesTemp,",")[[1]]
#
# 秉鴻哥預寫了一個函數，僅需載入,即可用來判斷檔案的欄位個數,只要設定檔案路徑及切割字串的符號，
# 即可判斷檔案的欄位數及回傳欄位名稱，不過第一個變數名與最後一個變數名會沒有切割乾淨。
specifyColumnNums<-function(fileName,delimiter="\",\""){
	varNamesTemp<-readLines(fileName,n=1)
	varName<-strsplit(varNamesTemp,delimiter)[[1]]
	return(list(nums=length(varName),varName=varName))	
}
#
##############################################################################
# 
# 2.欄位數5000以下
# 
# 直接使用rxImport(inData,outFile)
# 若覺得讀取速度過慢，可參考3.欄位數5000至10000的操作方法
#
##############################################################################
#
# 3.欄位數5000至10000
#
# 仍可以直接使用rxImport(inData,outFile) 
# 但應該會明顯感到速度上的差異，此刻我們可以改採用先讀取小部分的欄位至一個dataFrame,
# 再把dataFrame內的資料附加到xdf檔案，避免每次讀取所有欄位造成的時間浪費
# 
#varNamesTemp<-readLines("stage504_Indicator.csv",n=1)
#varNames<-strsplit(varNamesTemp,",")[[1]]
#colsPerRead<-1000
#numReadsFromFile<-ceiling(length(varNames)/colsPerRead)
#file.remove("stage504_Indicator.xdf")
#for(i in 1:numReadsFromFile){
#	tempDF<-rxImport(
#		inData="stage504_Indicator.csv",
#		varsToKeep=paste(varNames[(((i-1)*colsPerRead)+1):((((i-1)*colsPerRead)+1)+colsPerRead)],sep=","),
#		rowsPerRead=50)
#	
#	#targetXdf<-RxXdfData("stage504_Indicator.xdf")
#	if(!file.exists("stage504_Indicator.xdf")){
#		rxDataFrameToXdf(data=tempDF,outFile="stage504_Indicator.xdf")
#	}else{
#		rxDataFrameToXdf(data=tempDF,outFile="stage504_Indicator.xdf",append="cols",overwrite=T)
#	}
#}

rxImportCutColumn<-function(inData,outFile,colsPerRead=1000,sep=","){
	
	varNamesTemp<-readLines(inData,n=1)
	varNames<-strsplit(varNamesTemp,",")[[1]]	
	colsPerRead<-colsPerRead
	numReadsFromFile<-ceiling(length(varNames)/colsPerRead)
	file.remove(inData)			
	for(i in 1:numReadsFromFile){
	
		tempDF<-rxImport(
			inData=inData,
			varsToKeep=paste(varNames[(((i-1)*colsPerRead)+1):((((i-1)*colsPerRead)+1)+colsPerRead)],sep=sep),
			rowsPerRead=50)
	
		if(!file.exists(inData)){
			rxDataFrameToXdf(data=tempDF,outFile=inData)
		}else{
			rxDataFrameToXdf(data=tempDF,outFile=inData,append="cols",overwrite=T)
		}
	}
}





