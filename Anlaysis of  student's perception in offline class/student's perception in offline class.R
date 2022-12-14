#GET DATA
data<-read.csv("pa.csv")
#SIMPLEFY DATASET
data<-data[,1:16]
summary(data)
#TO FIND VARIOUS AGE GROUPS IN THE DATASET
unique(data$WHAT.IS.YOUR.AGE.)
#TRANSFORM BLANKS INTO NAS
data[data==""]<-NA
#TO GET CONFIRM THAT ALL THE OBSERVATIONS HAVE THE VALUES
#THE COMMA IS USED SIMPLY SO THAT THE CHECKING IS DONE ROW-WISE
data<-data[complete.cases(data), ]
#BUILDING OF THE DATASET
library(dplyr)
#TO SELECT ONLY THE NUMERICAL VALUE
dataset<-data %>%select_if(is.numeric)
#TO FIND AND ISOLATE THE CHARACTER VARIABLES
character<-data %>%select_if(is.character)
# AS A RESULT WE DO NOT HAVE ANY CHARACTER VARIABLE IN OUR DATASET

#TRANSFORM CHARACTER INTO NUMERICAL / DUMMY
library("fastDummies")
character<-dummy_cols(character, remove_most_frequent_dummy=TRUE)
#AS A RESULT WE SHALL GET AN ERROR THAT OUR DATASET DOES NOT HAVE ANY CHARACTER TO GET CHANGED INTO A NUMERICAL VALUE OR A DUMMY ONE

#SCALE THE DATASET:THE SCALING OF THE DATA MAKES IT EASY FOR A MODEL TO LEARN AND UNDERSTAND THE PROBLEM
dataset[,1:16] <-scale(dataset[,1:16])

#DETERMINING THE AMOUNT OF SEGNMENTS
library ("factoextra")
fviz_nbclust(dataset, kmeans, method="wss")# WSS - WEIGHTED SUM OF SQUARES
labs(subtitle="Elbow Method")

#2
#READ THE CSV FILE
a<-read.csv("pa.csv")
#SCATTER PLOT
plot(WHAT.IS.YOUR.AGE.~WHICH.ACTIVITY.IN.THE.CLASSROOM.DO.YOU.ENJOY.THE.MOST.,a)
#ADDING NAMES TO THE DOTS
with(a,text(WHAT.IS.YOUR.AGE.~WHICH.ACTIVITY.IN.THE.CLASSROOM.DO.YOU.ENJOY.THE.MOST.,labels=WHAT.IS.YOUR.AGE.,pos=4,cex=.6))

#NORMALIZATION - BY SUBTRACTING AND DIVIDING : IF THERE IS SOME LOW VALUES LIKE DECIMAL POINTS BUT THERE ANY THOUSANDS VALUES IF NORMALIZATION IS USED THEN ALL THE VARIABLES HAVE A LEVEL PLAYING FIELD AND IT SHOULD NOT HAPPEN JUST BECAUSE SOME VALUES WHICH ARE VERY HIGH SHOULD NOT DOMINATE THE WHOLE SHOW WHEN THE CLUSTERS ARE BEING FORMED WE NEED NOT WANT ONE VARIABLE TO DOMIMATE JUST BECAUSE THE OBSERVATIONS ARE ON THE HIGHER SIDE WHEN WE NORMALIZE ALL THE VARIABLES THEN THE AVERAGE FOR EACH VARIABLES BECOME ZERO AND THE STANDARD DEVIATION IS APPROXIMATELY ONE AND THIS CREATES THE LEVEL PLAYING FIELD
m<-apply(a,2,mean)#MEAN
s<-apply(a,2,sd)#STANDARD DEVIATION
z<-scale(a,m,s)#CALCULATION OF NORMALIZED DATASET Z

#CALCULATING EUCLIDIAN DISTANCE
distance<-dist(z)
print(distance,digits=3)

#HIERARCHICAL CLUSTERING USING DENDROGRAM
#CLUSTER DENDROGRAM WITH COMPLETE LINKAGE
hc.c<-hclust(distance)
plot(hc.c, labels= a$WHAT.IS.YOUR.AGE.)#DENDROGRAM USING PLOT
plot(hc.c, hang=-1)



#CLUSTER DENDROGRAM WITH AVERAGE LINKAGE
hc.a<-hclust(distance,method="average")
plot(hc.a,hang=-1)




#CLUSTER MEMBERSHIP
member.c<-cutree(hc.c,3)#EXPECTING FOR 3 CLUSTERS
member.a<-cutree(hc.a,3)
table(member.c,member.a)
#INTERPRETATION:AS PER AVERAGE LINKAGE 32+8 OBSERVATIONS BELONGS TO CLUSTER 1,4+3 TO 2 AND 3 TO 3. AS PERCOMPLETE LINKAGE 8+4 TO 1, 
#WHEN COMPARING AVERAGE AND COMPLETE LINKAGES THERE IS A GOOD MATCH FOR 8 AGE GROUPS AS THEY HAVE BEEN LISTED AS CLUSTER 1
#WHERE AS 32 AGE GROUPS HAVE A MISMATCH IN THE COMPLETE AND AVERAGE LINKAGE
#THIS TABLE GIVES A COMPARISION OF AVERAGE AND COMPLETE LINKAGES
#CLUSTER MEANS 
aggregate(z,list(member.c),mean)#we shall get the average values for the three clusters for each variables and importantly these are normalized values and this will help us in characterising these three clusters and here we do not observe too much variations among these there averages for a variable that means that variable is not really playing a very significant role in deciding cluster membership for the age groups.These averages indicates which variables arereally playing an important role in characterising the clusters
#AGGREGATION IN ORIGINAL UNITS - FOR EASIER INTERPRETATION
aggregate(a[,-c(1,1)], list(member.c),mean)


#SILHOUETTE PLOT
library(cluster)
plot(silhouette(cutree(hc.c,3),distance))
#USING HIERARCHICAL CLUSTER OF COMPLETE LINKAGE METHOD AND WE HAVE THRE CLUSTERS THE FUNCTION USED HERE IS THE CUT TREE ,USED TO DEVELOPE A SCENE HOT A PLOT
#INTERPRETATION: IF THE CLUSTER FORMATION HAS BEEN GOOD OR MEMBERS IN THE CLUSTERS ARE CLOSER TO EACH OTHER THE WE HAVE HIGH SI VALUES. IF THEY ARE NOT THEN THE SI VALUES WILL BE LOW AND THIS KIND OF VISUALIZATION HELPS US TO IDENTITY CLUSTERS VISUALLY IF YOU HAVE SI VALUE WHIVH IS NEGATIVE OBVIOUSLY THAT MEMBER IN THE GROUP IS SORT OF OUTLIER DOES NOTREALLY BELONG TO THAT GROUP
#SCREE PLOT : A SCREE PLOT WILL REQUIRES CALCULATION OF WITHIN GROUP SUM OF SQUARES SO WITHIN GROUP SUM OF SQUARES IS REPRESENTED HERE USING WSS AND IT'S CALCULATION IS ALSO INCLUTED HERE
wss<-(nrow(z)-1)*sum(apply(z,2,var))
for(i in 2:20) wss[i] <- sum(kmeans(z,centers=i)$withinss)
plot(1:20, wss, type="b", xlab="Number of Clusters", ylab="within Group SS")
#THE SCREE PLOT GIVES YOU THE OVERVIEW OF ALL THE POSSIBLE CLUSTERS AND WITHIN GROUP SUM OF SQUARES SO WITHIN GROUP MEANS WITHIN CLUSTER VARIABILITY WE WANT TO REDUCE WITHIN CLUSTER VARIABILITY SO WHEN YOU GO FROM ONE CLUSTER TO TWO CLUSTER YOU CAN SEE THE DROP IN WITHIN GROUP SUM OF SQUARES IS VERY LARGE SIMILARLY WHEN WE COME HERE YOU CAN SEE THE DROP IS VERY LARGE BUT MAY BE SOME WHERE HERE LIKE IF YOU TRY TO HAVE FIVE OR MORE CLUSTERS THE IMPROVEMENT IS NOT THAT SIGNIFICANT THE DROP IN VARIABILTYOR WITHIN GROUP SUM OF SQUARES IS NOT REALLY TAHT MUCH A SCREE PLOT INDICATES IN THIS CASE THAT WE SHOULD GO FOR LOWER NUMBER OF CLUSTERSMAYBE TWO MAYBE THREE BEYOND THAT THE GAINS ARE NOT VERY SIGNIFICANT.

#K - MEANS CLUSTERING : NON - HIERARCHICAL
#IN THE BEGINNING WE HAVE TO CHOOSE THAT HOW MANY CLUSTERS WE ARE INTERESTED IN WE CAN DO THIS K - MEANS CLUSTERING USING K - MEANS FUNCTION AND WE WILL USE Z OR NORMALIZED DATASET AND LETS SAY WE SHALL GO FOR THREE CLUSTERS WE CAN STORE THIS INFORMATION ININ SAY KC IT DENOTES THE K-MEANS CLUSTERING SO IF YOU WANT TO LOOK AT WHAT THIS ANALYSIS IS GIVING US WE CAN SIMPLY TYPE AND IT GIVES US A LOT OF INFORMATION FOR EXAMPLE THE TOP LINE IS K-MEANS CLUSTERING WITH THREE CLUSTERS OF SIZES 20,14 AND 16 SO FIRST CLUSTER HAS 20 AGE GROUPS IN IT AND SO ON AND IT ALSO GIVES US CLUSTER MEANS THE FOLLOWED BY CLUSTER MEMBERSHIP AND THE CLUSTERING VECTOR TELLS THE FIRST QUESTION SHOULD GO INTO THE CLUSTER 2 BASED ON HTIS ANALYSIS AND SO ON, THEN WE SHALL HAVE WITHIN CLUSTER SUM OF SQUARES WITHIN CLUSTER VARIABILITY IS 258.9898 FOR FIRST CLUSTER WHEREAS THE CLUSTER 2 WHICH HAS THE 14 MEMBERS THE VARIABILITY IS LOWER THAT MEANS THE MEMBER ARECLOSER TO EACH OTHER INTERMS OF DISTANCE, IT ALSO GIVE YOU BETWEEN CLUSETER SUM OF SQUARES DIVIDED BY THE TOTAL SUM OF SQUARES RIGHT NOW IT IS ABOUT 18.0% AND THEN THERE ARE VARIOUS COMPONENTS OF THIS CLUSTER ANALYSIS THAT IS AVAILABLE IF YOU WANT TO FOR EXAMPLE LOOK AT THE FIRST ONE WE CAN SAY KC AND DOLLAR SIGN CLUSTER THIS GIVESUS THE CLUSTER MEMBERSHIPS SIMILARLY IF YOU DO KC DOLLAR SIGN CENTERS WE GET AVERAGES AND WE ALSO PLOT ANY TWO VARIABLES IN THE FORM OF A SCATTER PLOT SO LET US TRY TWO VARIABLES SUPPORTIVE CLASSMATES AND CHANCE SO WE ARE PLOTING SUPPORTIVE CLASSMATES AND CHANCE, AND OUR DATASET IS a OR IF WE SIMPLY RUN THIS PLOT THEN IT WILL GIVE YOU A SCATTER PLOT WHICH LOOKS LIKE THIS YOU CAN COLOR - CODE THOSE THREE CLUSTERS LIKE THIS WE CAN SAY COLOR EQUALS SO NOW THE MEMBERSHIPS IS INDICATED WITH THE HELP OF A COLOR SO IN FIRST CLUSTER WE HAVE 20 OBSERVATIONS SO THESE CIRCLES THAT ARE BLACK IN COLOR THOSE ARE ONLY ONE AGE GROUP SIMILARLY SECOND CLUSTER HAS  3 AGE GROUPS AND ARE IN PINK COLOR FINALLY THE GREEN ONES ARE THIRD CLUSTERS
kc<-kmeans(z,3)
kc
plot(GIVEN.A.CHANCE..WHAT.IS.ONE.CHANGE.THAT.YOU.WOULD.LIKE.TO.SEE.~DO.YOU.HAVE.SUPPORTIVE.CLASSMATES.,a,col=kc$cluster)
