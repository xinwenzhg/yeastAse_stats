#!/bin/bash
#$ -N cali_null
#$ -t 1-20
#margs=$(head -n $SGE_TASK_ID cali_null_hpc_com.txt | tail -n 1) 
#module load R/3.5.1
#Rscript -<<EOF $margs

#load("hpc_need_Jan14.RData") # likelihood functions,paraGetB/BB,expi,cali,expi_Ct,cali_Ct  
require("foreach")
require("iterators")
library("bbmle")

#myargs <- commandArgs(trailingOnly = T)
#num <- myargs[1]
num <- "test_allsame"
#sp_i <- as.integer(myargs[2:length(myargs)])
#spPart1 <- sp_i[1:(length(sp_i)/2)]
#spPart2 <- sp_i[(length(sp_i)/2+1) : length(sp_i)]

######################################### define which data frame and coverage vector to use 
orig <- cali[1:1000,]
orig_Ct <- cali_Ct
f <- "cali_null"
######################################################
x_key <- names(orig_Ct)[1:10]
y_key <- names(orig_Ct)[1:10]

ans1 <- foreach(d=iter(orig,by="row"),
                .combine=rbind,
                .packages='bbmle') %do%
  paraGetBB(d,x_key,y_key,orig_Ct)
colnames(ans1) <- c("log.ecis","ecisL","ecisH","log.rHy","rHyL","rhyH")
rownames(ans1) <- orig[,1]
ans1 <- data.frame(ans1)

ans2 <- foreach(d=iter(orig,by="row"),
                .combine=rbind,
                .packages='bbmle') %do%
  paraGetB(d,x_key,y_key,orig_Ct)
colnames(ans2) <- c("B.log.ecis","B.ecisL","B.ecisH")
rownames(ans2) <- orig[,1]
ans2 <- data.frame(ans2)

ans3 <- cbind(ans1,ans2)

vn <- paste0(f,'_',num)
assign(x=vn,value=ans3)

save(list = vn,file=paste0(f,"_",num,".RData"))

#EOF
