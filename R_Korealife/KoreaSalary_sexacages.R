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

data$age <- 2015 - data$birth + 1 #�Ļ� ���� ����� (�⵵ -> ����)

data <- data %>%
  mutate(ages = ifelse(age<30,"young",ifelse(age<60,"middle","old")))  #�Ļ����� ages(���ɴ�) ����� 
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

ggplot(data = sex_income,aes(x=ages,y=mean_income,fill=sex))+geom_col(position="dodge")+scale_x_discrete(limits = c("young","middle","old")) #fill=sex : ����ٸ� ������ �� ������

#�ʳ�⿡�� �������� ���� ������ ���� ���ٰ� �߳��� ���鼭 ũ�� ��������. �׸��� ����� ���鼭 ������ �پ������ �ʳ�⿡ ���ؼ��� ������ ũ��. ���� �ռ� ���ɴ뺰 ���� ��ȭ�� ���� �� ���⿡ �ʳ�⺸�� ���� ������ �޴� ������ ��Ÿ���µ� �̴� �������Դ� �ش���� �ʴ´�. ���� �ʳ�⿡�� �߳��� ���鼭 ������ �����ϴ� ���� �������Ը�  �ش�Ǵ� ����� ������ ��� ū ���̰� ����. 

#mean salary according sex & age
sex_income2 <- data %>%
  filter(!is.na(income)) %>%
  group_by(sex,age)%>%
  summarise(mean_income = mean(income))
head(sex_income2)
ggplot(data = sex_income2,aes(x=age,y=mean_income,col=sex))+geom_line()
#������ ������ ���� ������ 30�� ���ķ� ���� �������ٰ� 50�� �߹� ���� ũ�� �� ���ķ� �پ��� 70�� �߹��� �Ǹ� ��� �� ������ �ȴ�. 