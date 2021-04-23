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



# 기본 연산자: http://adv-r.had.co.nz/Vocabulary.html

# gapminder를 통한 데이터 가공
install.packages("gapminder")
library(gapminder)

# 행과 열 선택
gapminder[gapminder$country=='Korea, Rep.', c('pop', 'gdpPercap')]

# 행 선택
gapminder[gapminder$country=='Korea, Rep.',]
gapminder[gapminder$year==2007,]
gapminder[gapminder$country=='Korea, Rep.' & gapminder$year==2007,]
gapminder[1:100,]
head(gapminder, 10)

# 정렬
gapminder[order(gapminder$year, gapminder$country),]

# 변수 선택
gapminder[, c('pop', 'gdpPercap')]
gapminder[,1:3]

# 변수명 바꾸기: gdpPercap를 gdp_per_cap으로 변경
f2 = gapminder
names(f2)

names(f2)[6] = 'gdp_per_cap'
names(f2)   # 바뀐 변수 이름 확인

# 변수 변환과 변수 생성
f2 = gapminder
f2$total_gdp = f2$pop * f2$gdpPercap

# 요약 통계량 계산
median(gapminder$gdpPercap)
apply(gapminder[,4:6], 2, mean)
summary(gapminder)



## dplyr 패키지
# R에서 데이터 가공은 dplyr 패키지를 많이 사용할 것이 장려됨
# why? 데이터를 빨리 쉽게 가공할 수 있도록 도와준다.

# 1. 코드를 읽기 쉽다. %>%
# 2. 동사의 개수가 적고, 문법이 간단하다.
# 3. 데이터 프레임만 처리한다.
# 4. R studio 내에서는 변수명이 자동완성돼서 코딩이 빨라진다.

# TMI: 함수형 프로그래밍 패러다임 사용.

# 동사 종류: filter, arrange, select, mutate, summarize, distinct, sample_n()(또는 sample_frac)

library(dplyr)


# 유용한 기능1: tbl_df()
# 장점: 클래스 속성을 적용. 스크린에 맞게끔만 행과 열 출력해서 빅데이터에 유용.
# 빅데이터는 아예 불러들일 때 함수를 적용하면 유용하다.
i2 = tbl_df(iris)   
class(i2)
i2


# 유용한 기능2: glimpse()
# 장점: 데이터 프레임을 transpose해서 모든 변수를 보여주고, 속성을 나타낸다. 
glimpse(i2)


# 유용한 기능3: %>%
# 기능: x %>% f(y)면 f(x,y)로 변환해서 작동.


# dplyr의 핵심동사
# 1. filter()
# 행을 선택하는 함수
# 장점: 데이터 프레임의 변수명을 $없이 쓸 수 있다. 변수명[] 형태로 쓰지 않아도 된다.

# 위의 예제로 적용.
filter(gapminder, country=='Korea, Rep.')
filter(gapminder, year==2007)
filter(gapminder, country=='Korea, Rep.' & year==2007)

# %>%를 적용하면?
gapminder %>% filter(country=='Korea, Rep.' & year==2007)


# 2. arrange()
# 장점: 행을 변수들의 오름차순으로 정렬.
names(gapminder)

# lifeExp, pop로 정렬
arrange(gapminder, lifeExp, pop)
gapminder %>% arrange(lifeExp, pop)   # 왜 %>%를 쓰는지 알겠다. 데이터프레임과 함수, 변수를 따로 작성하고 가독성을 높여준다.


# 3. select()
# 열 이름 선택하는 함수
select(gapminder, pop, gdpPercap)
gapminder %>% select(pop, gdpPercap)


# 4. mutate()
# 기존의 변수들을 변환한 결과를 기존 변수나 새 변수에 할당.
gapminder %>% mutate(total_gdp = pop * gdpPercap, 
                     le_gdp_ratio = lifeExp / gdpPercap, 
                     lgrk=le_gdp_ratio * 100)   # 변수 이름을 쓰고 내용을 작성하면 된다.

# 5. summarize()
# 데이터 프레임의 변수(벡터값)를 입력받아 단 한 개의 값을 리턴하는 요약 통계량 함수.
# n(): 현재 그룹의 관측치 개수, n_distinct(x): 그룹 내 x 변수의 고유한 값 개수, first(x), last(x), nth(x,n)
# 그룹화된 데이터에 group_by랑 함께 쓰면 더 강력하다.
gapminder %>% summarize(n_obs = n(),
                        n_continent = n_distinct(continent),
                        med_life = median(lifeExp),
                        first_gdp = first(gdpPercap),
                        ten_st_pop = nth(pop, 10))


# 6. sample_n(), sample_frac()
# sample_n(): 정해진 개수를 샘플로 추출, sample_frac(): 정해진 비율을 추출
# default: 비복원 추출. 복원 추출을 하고 싶으면 replace=TRUE하면 된다. 
gapminder %>% sample_n(100)
gapminder %>% sample_frac(0.05)

gapminder %>% sample_n(10, replace=TRUE)


# 7. distinct()
# 고유한 행을 찾아내는 함수다.
gapminder %>% select(year) %>% distinct()   # 파이프 연산자를 두 번 이상도 쓸 수 있음을 알고 있자.



# group_by를 이용한 연산자. 
# 데이터를 그룹으로 나눠주는 함수. 
# group_by(data_set, grouping_variable), 그룹으로 나눠줘야 하니까 변수가 연속형이면 곤란하다.
gapminder %>%
  filter(year == 2002) %>%
  group_by(continent) %>%
  summarize(mean = mean(pop))   # summarize 안에 변수 이름들 꼭 쓰자. 


# 조인 연산자
# 테이블을 결합하는 함수
(df1 <- data_frame(x = c(1, 2), y = 2:1))    # x라는 열에 1과 2를, y라는 열에 2와 1을 준다.
(df2 <- data_frame(x = c(1, 3), a = 10, b = 'a'))   

# 1. inner_join(): x와 y의 교집합.
# 2. left_join(): x 테이블의 모든 행을 포함. 겹치는 행의 자료를 x 테이블에 붙힌다고 생각하면 된다.
# 3. right_join(): y 테이블의 모든 행을 포함. left에서 순서만 바뀜.
# 4. full_join(): 합집합.

df1 %>% inner_join(df2)
df1 %>% left_join(df2)   # NA가 뜨는 이유는 해당 열과 교집합 하는 자료가 없어 불러오지 못했다는 의미
df2 %>% right_join(df1)
df1 %>% full_join(df2)

# set operation: 위의 함수들과 똑같은 기능이지만 행과 열이 같아야 하는 조건이 있다.
(df3 <- data_frame(x = c(2, 2), y = 1:2))    # x라는 열에 1과 2를, y라는 열에 2와 1을 준다.
intersect(df1, df3)
setdiff(df1, df3)
setdiff(df3, df1)
union(df1, df3)
