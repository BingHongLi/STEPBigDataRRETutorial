##########################################################################
#
# Revolution R Enterprise ─ 生成迴歸建模所使用的formula
# 李秉鴻
# 採智科技
#   
#
# 過去開源R，建模可使用 . (dot) 代表全部變數
# 在使用rxFunction時，則無法以.(dot)代表全部變數
# 故使用此方法抓取所有變數及設計刪除變數與新增變數
#
##########################################################################

# dataSource  為資料來源
# depVar      為依變數
# rmIndepVar  為要刪除的自變數
# addIndepVar 為要新增的自變數及新格式(次方:交互項)
generateFormula<-function(dataSource,depVar,rmIndepVar="",addIndepVar=NULL){
	
	# 取得資料的所有欄位名稱
	tempNames<-names(dataSource)
	
	# 刪除依變數及不想觀察的自變數，新增想要觀察的變數及新格式
	tempIndepVar<-c(tempNames[(tempNames!=rmIndepVar)&(tempNames!=depVar)],addIndepVar)
	
	# 先設定格式中的依變數
	resultFormula<-paste(depVar,"~",sep="")
	
	# 黏貼
	for(i in tempIndepVar){
		resultFormula<-paste(resultFormula,i,"+",sep="")	
	}
	
	# 除去formula最後方之+號，並設為函數傳回值
	return(substr(resultFormula,start=1,stop=nchar(resultFormula)-1))
}

# generateFormula(mortDS,names(mortDS)[6],names(mortDS)[3:4])
# generateFormula(mortDS,names(mortDS)[6],names(mortDS)[3:4],"ccDebt^2")
# rxLinMod(generateFormula(mortDS,names(mortDS)[6]),data=mortDS)
# rxLinMod(generateFormula(mortDS,names(mortDS)[6],names(mortDS)[3:4],"ccDebt^2"),data=mortDS)