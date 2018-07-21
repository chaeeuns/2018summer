library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

raw_data <- read.spss(file = "C:/Users/��ä��/Downloads/KoreaSalary.sav",to.data.frame = T)
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

#pretreatment age
class(data$birth)
summary(data$birth)

data$birth <- ifelse(data$birth == 9999,NA,data$birth)
table(is.na(data$birth))

data$age <- 2015 - data$birth + 1 #�Ļ� ���� ����� (�⵵ -> ����)
summary(data$age)
qplot(data$age)

#pretreatment income
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

#20�� �ʸ� 100���� ������ ������ �ް� ���������� ����, 50�� ���� 300���� ������ ���� ���� ������ �޴´�. ����
#�����ϴٰ� 70�밡 �Ǹ� 20�� ���� �� ���� ������ �޴´� 

#Salary difference according ages

data <- data %>%
  mutate(ages = ifelse(age<30,"young",ifelse(age<60,"middle","old")))  #�Ļ����� ages(���ɴ�) ����� 
table(data$ages) 

ages_income <- data %>%
  filter(!is.na(income)) %>%
  group_by(ages) %>%
  summarise(mean_income = mean(income))
ages_income
ggplot(data = ages_income, aes(x=ages,y=mean_income)) + geom_col() + scale_x_discrete(limits =c("young","middle","old")) #x�� ���� ���� ����(dafault : alphabet)
#�߳��� ���� ���� ������ �ް� �ʳ�, �߳� �� 