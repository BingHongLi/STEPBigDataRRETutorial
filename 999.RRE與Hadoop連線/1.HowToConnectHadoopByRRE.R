### RRE連線至Hadoop教學
# RRE客戶端可透過本機RRE，並透過SSH協定去連線至Hadoop叢集其中一台node的RRE，
# 以該node去跟叢集進行溝通，使用叢集資源進行運算。
# 連入node之前，必須先確認客戶端是否有下載Putty，若無請上網進行下載
# 客戶端是否已有該node的private key，並透過Putty由客戶端不輸入密碼連線至node
# 若無，請先設定
# RRE有三種設定連線至node，這裡採先透過Putty儲存可連線的資訊後，RRE會自行開啟Putty進行連線的方式
# 欲連線的node之使用者帳號
mySshUsername<-"cloudera"
# 存在putty內的session名稱
mySshHostname<-"CDH4.7SingleNode"
# 在node本地端那邊供RRE存取的資料夾路徑，請勿更動此行
myShareDir <- paste("/var/RevoShare",mySshUsername,sep="/")
# 在hdfs供RRE存取的資料夾路徑，請勿更動此行
myHdfsShareDir <-paste("/user/RevoShare",mySshUsername,sep="/")
# 新增一個ComputeContext，忘記參數內容請自己上Rdocument查，對自己有好處，可了解該函數
# sshClientDir 請設定你putty的儲存路徑
myHadoopCluster <- RxHadoopMR(
hdfsShareDir=myHdfsShareDir,
shareDir=myShareDir,
sshUsername=mySshUsername,
sshHostname=mySshHostname,
sshClientDir="D:\\putty"
)
# 告訴RRE 他必須要計算的ComputeContext為myHadoopCluster
rxSetComputeContext(myHadoopCluster)