## 예제 데이터 파일 불러오기

# R에 있는 기본 데이터 
help(package = 'datasets')  # 여기 있는 데이터는 바로 불러올 수 있다.

# ggplo2 패키지에 들어있는 데이터
data(package = 'ggplot2')

install.packages('ggplot2')
library(ggplot2)



# table 파일 불러오기
help(read.table)
read.table("file_name.txt")   # 확장자가 txt일 때 사용.

# 파일을 불러올 때 중요한 옵션들: separator, header, comment.char, quote, as.is, skip


# csv 파일 불러오기(csv파일은 read.csv사용)
help(read.csv)
read.csv("file_name.csv")

mall_customer <- read.csv("Mall_Customers.csv")   # read.table과 동일하지만 header=TRUE, sep=","만 다르다.
mall_customer2 <- read.csv("C:/Users/K/Documents/Data Science/Mall_customers.csv")

# 데이터 살펴보기
# dplyr::glimpse(boston)를 써도 됨.
library(dplyr)
glimpse(mall_customer)   # 행과 열, 변수명과 데이터 값들을 대략적으로 보여준다.
plot(mall_customer)
summary(mall_customer)



# 용량이 매우 큰 외부 파일

# 이 때는 read.table과 read.csv의 실행 시간이 많이 걸릴 수도 있다.
# 해결법: read.table 패키지를 불러와서 fread 함수를 사용하자.
library(data.table)
big_data <- fread("very_big.csv")
big_data <- fread("very_big.csv", data.table = FALSE)



# 엑셀 파일 읽어 들이기
library(readxl)

# 1. xls, xlsx 모든 포맷을 다 읽는다. 
read_excel("spreadsheep_name.xls")
read_excel("spreadsheepname.xlsx")

# 2. 파일 내에 여러 시트가 있을 경우 특정 시트를 지정하자.
read_excel("spreadsheepname.xlsx", sheet = "sheet_name")
read_excel("spreadsheepname.xlsx", sheet = 2)

# 3. 결측치가 빈 셀이 아닌 다른 문자로 코드되어 있을 땐 그 문자를 써주자.
read_excel("spreadsheepname.xlsx", na = 'NA')