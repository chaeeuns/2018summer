library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

raw_data <- read.spss(file = "C:/Users/권채은/Downloads/KoreaSalary.sav",to.data.frame = T)
data <- raw_data

View(data)

data <- rename(data,
               sex = h10_g3,
               birth = h10_g4,
               marriage = h10_g10,
               religion = h10_g11,
               income = p1002_8aq1,
               code_job = h10_eco9,
               code_region = h10_reg7)


#pretreatment age
class(data$birth)
summary(data$birth)

data$birth <- ifelse(data$birth == 9999,NA,data$birth)
table(is.na(data$birth))

data$age <- 2015 - data$birth + 1 #파생 변수 만들기 (년도 -> 나이)
summary(data$age)
qplot(data$age)

#pretreatment income
data$income <- raw_data$p1002_8aq1
class(data$income)
table(data$income)
summary(data$income) #table too many value, use summary
qplot(data$income)
qplot(data$income)+xlim(0,1000) #to show more detail 
data$income <- ifelse(data$income %in% c(0,1000), NA, data$income) #unknown value remove
table(is.na(data$income))

#Salary difference according age

age_income <- data %>% 
  filter(!is.na(income)) %>%
  group_by(age) %>%
  summarize(mean_income = mean(income))

age_income

ggplot(data = age_income, aes(x=age,y=mean_income))+geom_line()

#20대 초만 100만원 가량의 월급을 받고 지속적으로 증가, 50대 무렵 300만원 정도로 가장 많은 월급을 받는다. 이후
#감소하다가 70대가 되면 20대 보다 더 적은 월급을 받는다 

#Salary difference according ages

data <- data %>%
  mutate(ages = ifelse(age<30,"young",ifelse(age<60,"middle","old")))  #파생변주 ages(연령대) 만들기 
table(data$ages) 

data <- data %>%
  filter(is.na(income)) %>%
  group_by(ages) %>%
  summarise(mean_income = mean(income))
mean_income
