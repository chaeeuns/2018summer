library(foreign)
library(dplyr)
library(ggplot2)
library(readxl)

raw_data <- read.spss(file = "C:/Users/±ÇÃ¤Àº/Downloads/KoreaSalary.sav",to.data.frame = T)
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

class(data$birth)
summary(data$birth)

data$birth <- ifelse(data$birth == 9999,NA,data$birth)
table(is.na(data$birth))

data$age <- 2015 - data$birth + 1
summary(data$age)
qplot(data$age)
