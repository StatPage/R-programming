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
opar = par(mfrow=c(2,2))

# boxplot: 변수 사이의 인과관계가 있을 때는 설명변수를 X로 반응변수를 Y로 놓는다.aes로 순서대로 지정하면 된다.
mpg %>% ggplot(aes(class, hwy)) + geom_boxplot()

# boxplot을 보는 여러 방법
# 1. 중복점을 퍼뜨리고(geom_jitter) 점의 진한 정도를 alpha로 조정
mpg %>% ggplot(aes(class, hwy)) + geom_jitter(col='red') + geom_boxplot(alpha=.5)

# 2. hwy변수의 중간값의 올림차순으로 범주를 재정렬(reorder(재정렬 변수, 기준 변수, 기준 값))
mpg %>% mutate(class==reorder(class, hwy, median)) %>% ggplot(aes(class, hwy)) + geom_jitter(col='blue') + geom_boxplot(alpha=.5)

# 3. factor 함수의 levels= 옵션을 이용해서도 재정렬이 가능하다. 마지막은 3 변수를 제외하고 나머지 변수들을 뭉쳐놨다.
mpg %>% mutate(class=factor(class, levels=c("2seater", "subcompact", "compact", ""))) %>% ggplot(aes(class, hwy)) + geom_jitter(col='blue') + geom_boxplot(alpha=.5)

# 4. 3번에서 x-y축을 바꿨는데 단순히 aes의 순서를 바꾸는게 아니라 변수들의 위치는 고정하고 coord_flip()을 추가했다.
mpg %>% 
  mutate(class=factor(class, levels=
                              c("2seater", "subcompact", "compact", "midsize", "minivan", "suv", "pickup"))) %>%
                 ggplot(aes(class, hwy)) + geom_jitter(col='blue') + geom_boxplot(alpha=.5) + coord_flip()

# boxplot을 볼 때 주의할 점
# 1. 번주형 x 변수의 적절한 순서를 고려한다. reorder()는 통계량으로 순서를 정하는 거고 factor(levels=)는 수동으로 정하는 것이다.
# 2. 수량형 y 변수의 제곱근과 로그변환이 도움이 될 때도 있다.
# 3. 수량형 y 변수의 분포 모양과 이상점 유무
# 4. 각 x범주 그룹의 관측치가 충분한가? geom_points()와 alpha 옵션을 통해 개별 관측치를 확인해보자.
# 5. x라벨링이 너무 길어 x-y축을 변경할 필요는 없는가? coord_flip()을 사용하자.
# 6. 여러 옵션을 계속 실시해야 한다.


## 두 범주형 변수
# 많은 경우는 아니다. 도수 분포를 알아내려고 xtabs()를 쓰고 결과를 시각화하기 위해서 mosaicplot()을 사용한다.
glimpse(data.frame(Titanic))
?Titanic

# 각 범주의 분포
xtabs(Freq ~ Class + Sex + Age + Survived, data.frame(Titanic))  

# 모자익플롯
opar = par(mfrow=c(1,1))
Titanic %>% mosaicplot(main = "Survival on the Titanic")
Titanic %>% mosaicplot(main = "Survival on the Titanic", color=TRUE)
# 결과 해석: 탑승 인원은 선원이 가장 많음. 여성의 비율은 선원에서 가장 적다. 3등실에서 아이의 비율이 가장 높다. 밝게 표시된 영역이 생존율을 의미한다. 1등실의 여성이 가장 높은 생존 비율을 보인다. 남자는 2등실이 가장 사망률이 높아보인다. 



### 많은 변수를 보여주는 기술1: geom
## 이차원 공간 이상의 값을 사용하고 싶으면 geom_ 레이어에 색깔, 모양, 선모양 등의 다른 속성을 더해주면 된다. 추가한 변수들의 각 범주별로 표현해주는 것이다. 책에서는 geom_ 레이어에 추가하라고 했지만 ggplot은 통합적으로 여러 변수를 지원하는 기능을 갖췄으니 ggplot에 작성해도 문제가 되지 않는다.
gapminder %>% filter(year==2007) %>%
  ggplot(aes(gdpPercap, lifeExp)) +
  geom_point() + scale_x_log10() +
  ggtitle("Gapminder data for 2007")

# 여기서 새로운 변수들을 나타내고 싶으면 범주형은 색깔, 수량형은 크기로 표현해주면 된다. 
gapminder %>% filter(year==2007) %>%
  ggplot(aes(gdpPercap, lifeExp)) +   # ggplot 내부에도 aes에 size와 col파라미터를 수정할 수도 있다.
  geom_point(aes(size=pop, col=continent)) + scale_x_log10() +
  ggtitle("Gapminder data for 2007")



### 많은 변수를 보여주는 기술2: facet_
## 국가별 평균 기대 수명의 연도별 추이
gapminder %>% 
  ggplot(aes(year, lifeExp, group=country)) +
  geom_line()

# 대률 정보 추가. 
gapminder %>% 
  ggplot(aes(year, lifeExp, group=country)) +
  geom_line(aes(col=continent))

# But  결과를 명확하게 보일 수가 없다.
# 따라서 facet 함수 사용. 같은 규격의 플롯을 나눠서 그려주는 기능.
gapminder %>% 
  ggplot(aes(year, lifeExp, group=country, col=continent)) +
  geom_line() + 
  facet_wrap(~ continent)



### 시각화 과정의 유용한 원칙: 
# 1. 데이터에 대한 설명을 읽고 문맥을 파악한다. 이래서 교양이 중요.
# 2. glimpse()함수로 데이터 구조를 파악하자. 행의 개수의 변수의 타입 등
# 3. paris( )로 산점도행렬로 큰 그림을 그린다. 
# 4. 주요 변수를 하나씩 살펴본다. 수량형 변수는 히스토그램, 범주형 변수는 막대그래프 사용. geom_histogram(), geom_bar()
# 5. 두 변수 간의 상관 관계를 살펴본다. 산점도와 상자그림. geom_point(), geom_bar()
# 6. 고차원의 관계를 연구. geom_ 속성에 제 3, 4의 변수를 추가한다. facet_wrap를 사용하기도 한다.
# 7. 의미있는 결과가 나올 때까지 이를 반복한다.
# 8. 의미있는 플롯을 문서화하고 코드도 관리한다.



### 에드워드 터프티가 제안한 원칙 → 의미있는 결과를 위한 원칙으로 참고
# 1. 비교, 대조, 차이를 드러내라.
# 2. 인과 관계와 상관 관계를 보여라.
# 3. 한 도표에 여러 변수를 보여라. ggplot은 통합적으로 이것을 지원.
# 4. 텍스트, 숫자, 이미지, 그래프 같은 데이터들을 한 곳에 통합.
# 5. 사용된 데이터의 출처를 그래프 안이나 각주로 밝혀라. 
# 6. 의미있는 내용을 담아라. 
# 시각화는 미니멀리즘을 지향해야 한다. 
# 조그만 도표를 동시에 여러 개 보여주는 'small multiple'을 권장.



### 필자의 권장사항:
# 1. 의미있는 변수명을 사용하라: 입력 데이터세트의 변수명을 의미 있게 하는 것이 바람직한 관행. 되도록 약러를 피하자.
# 2. 필요하면 ggtitle()을 사용해서 제목을 추가하자.
# 3. 설명이 필요없는 플롯을 지향하라. 축의 변수명과 적절한 제목은 충분한 의미를 전달한다.
# 4. small multiple을 활용하자. facet_wrap(), facet_grid()가 있다.
# 5. 시각화하는 코드도 버전에 맞게 준비돼야 한다.
# 6. 모든 데이터를 시각화해라. 안 하면 초보다.
# 7. 데이터처리에 능숙해져라. 효율적인 시각화의 70%는 데이터 전처리다. 특히 dplyr에 익숙해지자. 파이썬에서는 pandas

