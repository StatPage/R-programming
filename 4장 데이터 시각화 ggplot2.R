### 4.1 시각화의 중요성

# gapmider 데이터를 이용한 시각화
install.packages("gapminder")
library(gapminder)
??gapminder
gapminder::continent_colors
gapminder
names(gapminder)


# head & tail: 데이터 머리와 꼬리
head(gapminder)
tail(gapminder)


# glimpse: 데이터를 한 번에 살펴보기
library(dplyr)
glimpse(gapminder)


# 특정 변수 살펴보기
gapminder$country
gapminder[,'country']   # 변수명은 반드시 따옴표를 넣어주자.
select(gapminder, country)   # dplyr는 []랑 변수 이름에 ''를 안 써도 되서 편함.
gapminder %>% select(country)


# summary: 간단한 통계량 살펴보기. 최소, 1분위, 중앙, 평균, 3분위, 최대
## summarize는 dplyr의 함수.
summary(gapminder$year)
summary(gapminder$gdpPercap)
cor(gapminder$year, gapminder$gdpPercap)


# par(mfrow=c(n,m)): 시각화 객체 생성
opar = par(mfrow=c(2,2))
opar
hist(gapminder$lifeExp)
hist(gapminder$gdpPercap)
hist(log10(gapminder$gdpPercap), nclass=50)   # 데이터가 왼쪽으로 치우치면 log변환
# hist(sqrt(gapminder$gdpPercap), nclass=50)   # 데이터가 오른쪽으로 치우치면 루트변환
plot(log10(gapminder$gdpPercap), gapminder$lifeExp, cex=.5)   # 변환 결과 되게 상관이 높아보인다.

# 상관계수 비교(비선형 관계일 때는 method = 'kendall' or 'spearman' 사용)
cor(gapminder$lifeExp, gapminder$gdpPercap)
cor(gapminder$lifeExp, log10(gapminder$gdpPercap))

# 켄달과 스피어만 상관계수
# 스피어만의 경우 단조성을 평가하기 위해 사용.한 변수의 값이 커지면 다른 변수의 값도 커지는 지를 알아보는 것.
# 켄달의 경우 단조성을 평가하기 위해 사용. 그러나 측정 방법은 순위가 일치하는 쌍과 일치하지 않는 쌍을 구해 개수의 차이로 측정.
cor(gapminder$lifeExp, gapminder$gdpPercap, method='spearman')
cor(gapminder$lifeExp, gapminder$gdpPercap, method='kendall')

## 정리를 하자면 (피어슨)상관계수는 선형성을 확인하는 것이고 spearman과 kendall은 단조성을 확인하는 것이다.



### 4.2 베이스 R 그래픽과 ggplot2
# gglplot은 출력 결과가 시각적으로 눈에 더 편안하고 세련되게 나타난다.
library(ggplot2)
library(dplyr)
library(gapminder)
opar1 = par(mfrow=c(2,2))
opar1

gapminder %>% ggplot(aes(x=lifeExp)) + geom_histogram()
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram()
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram() + scale_x_log10()
gapminder %>% ggplot(aes(x=gdpPercap, y=lifeExp)) + geom_point() + scale_x_log10() + geom_smooth()


## ggplot2
# grammar of graphics의 두 g를 가져옴.
# 장점: 커스텀화가 따로 필요 없다. 다양한 플롯 타입을 통일된 개념으로 처리. 다변량 데이터 플롯에 효율적(facet_*함수는 특히)
install.packages("ggplot2")
library(ggplot2)
?ggplot
help(ggplot)
example(ggplot)
return


## ggplot과 dplyr의 %>% 
# aes는 변수를 그래프 구성요소에 매핑해준다.
ggplot(gapminder,aes(lifeExp)) + geom_histogram()
gapminder %>% ggplot(aes(lifeExp)) + geom_histogram()

gapminder %>% ggplot(aes(gdpPercap)) + geom_histogram()
gapminder %>% ggplot(aes(log10(lifeExp))) + geom_histogram()

gapminder %>% ggplot(aes(pop)) + geom_histogram()
gapminder %>% ggplot(aes(year)) + geom_histogram()


## diamonds와 mpg 데이터?
?diamonds
?mpg

glimpse(diamonds)
glimpse(mpg)



### 변수의 종류에 따른 시각화 기법
## 한 수량형 변수
# 1. 도수히스토그램   2.도수 폴리곤: 막대를 직선으로 연결  3. 커널밀도추정함수: 확률분포 밀도함수를 곡선으로 추정.
# 대부분 히스토그램이면 충분.

# 확인해야 할 사항들
# 1. 이상점 유무  2. 분포의 모양(어디로 치우쳤나, 피크가 두 개인가?)  3. 어떤 변환을 하면 정규분포처럼 될까?  4. 히스토그램이 너무 자세하거나 거친가? binwidth로 조정
summary(gapminder)   # 우선 기초 통계량 확인하고
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram()   # 히스토그램
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_freqpoly()   # 도수 폴리곤
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_density()   # 커널밀도추정함수

# x 축을 log변환하여 다시 그렸다.
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram() + scale_x_log10()   
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_freqpoly() +  scale_x_log10()  
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_density() + scale_x_log()

# aes의 default값은 x 축이지만 y=로 지정해주면 그래프 축이 y로 바뀐다.
gapminder %>% ggplot(aes(y=gdpPercap)) + geom_histogram()   # 히스토그램
gapminder %>% ggplot(aes(y=gdpPercap)) + geom_histogram() + scale_y_log10()   # 물론 바뀐 축에 대한 변환도 필요하다.

## 두 수량형 변수
# 산점도: 수량형 변수 두 개일 때 사용. geom_point를 쓰지만 점들이 중복되면 geom_jitter() 사용
mpg %>% ggplot(aes(x=cyl, y=hwy)) + geom_point()   # 산점도는 x와 y가 필요하니까 변수를 두 개 지정해줬다.
mpg %>% ggplot(aes(x=cyl, y=hwy)) + geom_jitter()   # geom_jitter()가 점들을 흩어줬다.

diamonds %>% ggplot(aes(x=carat, y=price)) + geom_point()   # 이런 경우를 위해서 geom_jitter()를 사용.
diamonds %>% ggplot(aes(x=carat, y=price)) + geom_point(alpha=.01)

# 산점도를 볼 때 주의할 사항
# 1. 데이터 수가 너무 많으면 천 개 정도만 표본화 혹은 alpha 값을 줄여서 투명하게 만들기.
# 2. x나 y변수에 변환이 필요한지 확인해보기
# 3. 데이터의 상관 관계가 선형(피어슨)인지 비선형(켄달, 타우)인지 선형관계가 쎈지(기울기가 급격한지) 살펴보기.
# 4. 이상점 유무
# 5. 인과 관계를 반영해 원인이 되는 변수는 x, 결과가 되는 변수는 y로 한다.

pairs(diamonds %>% sample_n(1000))   # 산점도를 통해 눈에 띄는 관계들을 파악하고 탐구하자.


## 수량형 변수와 범주형 변수
