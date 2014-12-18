HowToUseRxForHadoop.R - 使用RRE去連結Hadoop的前置作業與資料分析流程,內含三個補充, 背景作業, 資料清洗, xdf轉csv
HowToUseRxImportForBigData.R -使用rxImport匯入欄位數5000以下, 5001~10000, 10001以上的檔案的處理方法 
HowToUsePemaR.R - 自寫大數據演算法，但RRE7.2不支援在Hadoop上使用分散自寫演算法
HowToUseGetAllVariableToFormula.R 生成一般建模用格式


在使用rxImport匯入檔案時,路徑內不要有中文名稱,否則會出現name too long 這個錯誤