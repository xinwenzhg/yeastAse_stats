load('~/cloud/project/otherRaw/rep44.RData')
rep44 <- rep44 %>% arrange(rowSums(.[-1]))

source("~/cloud/project/otherRaw/func.R")
calh_d <- colSums(calh[,grep("_yGc",names(calh),value=T)],na.rm = T)/ colSums(calh[,grep("_rGc",names(calh),value=T)],na.rm=T)
x115 <- read.table('~/cloud/project/otherRaw/E115_summary.txt',header=T,stringsAsFactors = F)
x530 <- read.table('~/cloud/project/otherRaw/E530_summary.txt',header = T,stringsAsFactors = F)
x <- rbind(x115,x530)
x <- x[x$RG!='unknown',c('RG','assigned')]
y115 <- read.table('~/cloud/project/otherRaw/J115_summary.txt',header=T,stringsAsFactors = F)
y530 <- read.table('~/cloud/project/otherRaw/J530_summary.txt',header = T,stringsAsFactors = F)
y <- rbind(y115,y530)
y <- y[y$RG!='unknown',c('RG','assigned')]
xy <- merge.data.frame(x,y,by="RG")
xyadd <- xy$assigned.x + xy$assigned.y
exptotalRead_tmp<- data.frame(RG=xy$RG,CTS=xyadd)  # expression total read counts data 
exR <- exptotalRead_tmp[grep(pattern = "C$",invert = T,exptotalRead_tmp$RG),]
smpNm <- c(  paste0(gsub(pattern = '_',"",exR$RG),'_yGc') , 
                   paste0(gsub(pattern = '_',"",exR$RG),"_rGc") ) 
exph_Ct <-c(  exR$CTS * calh_d /(1+calh_d) , exR$CTS /(1+calh_d)   ) 
names(exph_Ct) <- smpNm ######### smp_C valuable

c120 <- read.table('~/cloud/project/otherRaw/cali_demx.txt',header=T,stringsAsFactors = F)
z <- c120[grep(pattern = "C$",invert = T,c120$RG),c("RG","assigned")]
z <- z[z$RG != "unknown",]
library(dplyr)
z <- arrange(z,RG)
cali_Ct <- round(c(z$assigned * cali_d /(1+cali_d),z$assigned / (1 + cali_d)))
names(cali_Ct) <- smpNm

#save(list = c('rep44','depth44','expi','cali','expi_Ct','cali_Ct','paraGetB','neglhBinomial_cisonly','paraGetBB','neglhbetaBinomial_cisonly','dbetabinom'),file = '/cloud/project/hpc_pre/hpc_need_Jan14.RData')

save(list = c('exph','exph_Ct_esum','paraGetB','neglhBinomial_cisonly','paraGetBB','neglhbetaBinomial_cisonly','dbetabinom'),file = '~/cloud/project/hpc_pre/hpc_need_Feb4.RData')

save(list = c('exph','exph_Ct','rep44','depth44','paraGetB','neglhBinomial_cisonly','paraGetBB','neglhbetaBinomial_cisonly','dbetabinom'),file = '~/cloud/project/hpc_pre/hpc_need_Feb1.RData')

####### local test of R program ########################################################### 
names(cali_Ct)[1:10]
names(cali_Ct)[21:30]

paraGetBB(cali[1903,],names(cali_Ct)[1:19],names(cali_Ct)[21:39],cali_Ct)
paraGetB(cali[1903,],names(cali_Ct)[1:19],names(cali_Ct)[21:39],cali_Ct)

paraGetBB(exph[1,],names(exph_Ct)[11],names(exph_Ct)[11],exph_Ct)
paraGetB(exph[1,],names(exph_Ct)[31],names(exph_Ct)[31],exph_Ct)

paraGetBB(repfine[4,],names(depth44)[1:4],names(depth44)[21:24],depth44)
paraGetB(repfine[4,],names(depth44)[1:4],names(depth44)[21:24],depth44)

paraGetBB(expi[expi$ypsGene=='ADE5',],names(expi_Ct)[c(8,19,5,3,6,4,9,1,2,20)],names(expi_Ct)[c(10,11,17,14,12,13,15,18,16,7)],expi_Ct)
paraGetB(expi[expi$ypsGene=='ADE5',],names(expi_Ct)[c(8,19,5,3,6,4,9,1,2,20)],names(expi_Ct)[c(10,11,17,14,12,13,15,18,16,7)],expi_Ct)

paraGetBB(exph[exph$geneName=='ISY1',],names(exph_Ct)[c(1,3,5,7)],names(exph_Ct)[c(2,4,6,8)],exph_Ct)
paraGetB(exph[exph$geneName=='ISY1',],names(exph_Ct)[c(1,3,5,7)],names(exph_Ct)[c(2,4,6,8)],exph_Ct)

# check likelihood surface, around 0 , it's almost flat, so if starts here, optimizer would fail , and confidence interval fail, because of this too. 
for(i in -20:30) {
ans <- neglhbetaBinomial_cisonly(0.14433,i,
    xHy = unlist(expi[expi$ypsGene=='ALG1',c(8,19,5,3,6,4,9,1,2,20)+1]),
    nHy =unlist(expi[expi$ypsGene=='ALG1',c(8,19,5,3,6,4,9,1,2,20)+1] + expi[expi$ypsGene=='ALG1',c(10,11,17,14,12,13,15,18,16,7)+1]),
    C1 = unlist(expi_Ct[c(8,19,5,3,6,4,9,1,2,20)+1]),
    C2 = unlist(expi_Ct[c(8,19,5,3,6,4,9,1,2,20)+1]))
  print(c(i,ans))
}

neglhBinomial_cisonly(0.14433,
  xHy = unlist(expi[expi$ypsGene=='ALG1',c(8,19,5,3,6,4,9,1,2,20)+1]),
nHy =unlist(expi[expi$ypsGene=='ALG1',c(8,19,5,3,6,4,9,1,2,20)+1] + expi[expi$ypsGene=='ALG1',c(10,11,17,14,12,13,15,18,16,7)+1]),
                C1 = unlist(expi_Ct[c(8,19,5,3,6,4,9,1,2,20)+1]),
                C2 = unlist(expi_Ct[c(8,19,5,3,6,4,9,1,2,20)+1]))


for(i in -0:30) {
  ans <- neglhbetaBinomial_cisonly(-0.0157,i,
                                   xHy = unlist(expi[expi$ypsGene=='ADE5',(1:10)+1]),
                                   nHy =unlist(expi[expi$ypsGene=='ADE5',(1:10)+1] + expi[expi$ypsGene=='ADE5',(21:30)+1]),
                                   C1 = unlist(expi_Ct[(1:10)]),
                                   C2 = unlist(expi_Ct[(21:30)]))
  print(c(i,ans))
}
