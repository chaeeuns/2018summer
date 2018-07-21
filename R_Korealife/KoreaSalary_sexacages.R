library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

raw_data <- read.spss(file = "C:/Users/권채은/Downloads/KoreaSalary.sav",to.data.frame = T)
data <- raw_data

View(data)
head(data)
data <- rename(data,
               sex = h10_g3,
               birth = h10_g4,
               marriage = h10_g10,
               religion = h10_g11,
               income = p1002_8aq1,
               code_job = h10_eco9,
               code_region = h10_reg7)

#pretreatment sex
class(data$sex) #type confirm
table(data$sex)
data$sex <- ifelse(data$sex == 1, "male","female")
table(data$sex) #confirm

#pretreatment ages 
class(data$birth)
summary(data$birth)

data$birth <- ifelse(data$birth == 9999,NA,data$birth)
table(is.na(data$birth))

data$age <- 2015 - data$birth + 1 #파생 변수 만들기 (년도 -> 나이)

data <- data %>%
  mutate(ages = ifelse(age<30,"young",ifelse(age<60,"middle","old")))  #파생변주 ages(연령대) 만들기 
table(data$ages) 


#pretreatment income
summary(data$income) #table too many value, use summary
data$income <- ifelse(data$income %in% c(0,1000), NA, data$income) #unknown value remove
table(is.na(data$income))

#mean income according sex & ages
sex_income <- data %>%
  filter(!is.na(income)) %>%
  group_by(sex,ages) %>% 
  summarise(mean_income = mean(income))
sex_income

ggplot(data = sex_income,aes(x=ages,y=mean_income,fill=sex))+geom_col(position="dodge")+scale_x_discrete(limits = c("young","middle","old")) #fill=sex : 막대바를 성별로 색 나누기

#초년기에는 성별간의 월급 격차가 거의 없다가 중년기로 가면서 크게 벌어진다. 그리고 노년기로 가면서 격차가 줄어들지만 초년기에 비해서는 여전히 크다. 또한 앞서 연령대별 월급 변화를 봤을 때 노년기에 초년기보다 적은 월급을 받는 것으로 나타났는데 이는 남성에게는 해당되지 않는다. 또한 초년기에서 중년기로 가면서 월급이 증가하는 것은 남성에게만  해당되는 결과로 여성의 경우 큰 차이가 없다. 

#mean salary according sex & age
sex_income2 <- data %>%
  filter(!is.na(income)) %>%
  group_by(sex,age)%>%
  summarise(mean_income = mean(income))
head(sex_income2)
ggplot(data = sex_income2,aes(x=age,y=mean_income,col=sex))+geom_line()
#여성과 남성의 월급 격차는 30대 이후로 점점 벌어지다가 50대 중반 가장 크고 그 이후로 줄어들다 70대 중반이 되면 비슷 한 수준이 된다. 