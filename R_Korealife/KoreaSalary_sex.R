install.packages("foreign") 
#foreign : SPSS SAS STATA �� �پ��� ����м� ����Ʈ������ ���� �ҷ� �� �� �ִ�

library(foreign) #SPSS ���� �ҷ�����
library(dplyr) #��ó��
library(ggplot2) #�ð�ȭ
library(readxl) #�������� �ҷ�����

raw_data <- read.spss(file = "C:/Users/��ä��/Downloads/KoreaSalary.sav",to.data.frame = T)  #������ �ҷ����� #to.data.frame = T : ���������������·� ��ȯ
data <- raw_data #���纻 ����� 

View(data)

data <- rename(data,
               sex = h10_g3,
               birth = h10_g4,
               marriage = h10_g10,
               religion = h10_g11,
               income = p1002_8aq1,
               code_job = h10_eco9,
               code_region = h10_reg7) #���� �� �ڵ忡�� ���� �ܾ�� ��ȯ



#Salary difference according to sex

##pretreatment sex
class(data$sex) #type confirm
table(data$sex)
#if 9 exist, 
#ifelse(data$sex==9,NA,data$dssex)
#table(is.na(data$sex))
data$sex <- ifelse(data$sex == 1, "male","female")
table(data$sex) #confirm
qplot(data$sex)

##pretreatment income
data$income <- raw_data$p1002_8aq1
class(data$income)
table(data$income)
summary(data$income) #table too many value, use summary
qplot(data$income)
qplot(data$income)+xlim(0,1000) #to show more detail 
data$income <- ifelse(data$income %in% c(0,1000), NA, data$income) #unknown value remove
table(is.na(data$income))

##analysis
sex_income <- data %>%
  filter(!is.na(income)) %>%
  group_by(sex) %>%
  summarise(mean_income = mean(income))
sex_income
###male's income > female's income (about 1,500,000)