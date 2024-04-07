# youtube_LAB

```python
import pandas as pd   # 라이브러리 불러오기
```

## 파일 읽어오기

---

- 엑셀 파일 : `**pd.read_excel('파일이름', engine='openpyxl')**`

→`**engine='openpyxl'` 생략 가능\*\*

- csv 파일 : `**pd.read_csv('파일이름')**`
- DataFrame으로 읽어옴.

```python
df = pd.read_excel('data_01/youtube_rank.xlsx', engine='openpyxl)
print(type(df))       **# <class 'pandas.core.frame.DataFrame'>**
# 원본 복사해 두기
original = df.copy()
```

## 데이터 구조 확인

---

- `**DataFrame.head(n)**` : 처음부터 n개 행의 데이터를 가져옴. (default는 5개)
- `**DataFrame.tail(n)`\*\* : 마지막 n개의 행의 데이터를 가져옴. (default는 5개)
- `**DataFrame.info()`\*\* : 데이터 프레임의 row 개수 및 각 column의 Non null, dtype 정보 및 메모리 사용량을 확인 가능
- `**DataFrame.shape`\*\* : 데이터 프레임의 행, 열의 수를 tuple로 반환 ⇒ (행 수, 열 수)

```python
df.head()    # 처음부터 5개 행의 데이터 출력
df.head(9)   # 처음부터 9개 행의 데이터 출력
df.tail()    # 마지막 5개 행의 데이터 출력
df.tail(3)   # 마지막 3개 행의 데이터 출력
```

```python
df.info()
```

![1.png](./youtube_LAB_img/1.png)

- `entries` : 행의 단위
- `non-null` : null이 없다는 의미
- `RangeIndex` : 0 to 999까지 `RangeIndex`타입이라는 의미
- `object` : 데이터 타입이 문자열이라는 의미
- `memory usage: 39.2+ KB` : ‘+’는 메모리 사용량이 더 있다는 의미.

```python
# 보다 정확한 메모리 사용량의 알고싶을 때
df.info(**memory_usage='deep**)
```

![1.png](./youtube_LAB_img/1%201.png)

### DataFrame의 구성요소

- **`DataFrame.index`** : 행 index
- **`DataFrame.columns`**: 열 index
- **`DataFrame.values`** : 2차원 데이터

![1.png](./youtube_LAB_img/1%202.png)

```python
# index 구성요소 확인
> df.index                # RangeIndex(start=0, stop=1000, step=1)
# index 10개만 출력
> df.index.values[:10]    # array([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
# columns 구성요소 확인
> df.columns
# Index(['title', 'category', 'subscriber', 'view', 'video'], dtype='object')
> df.columns.values    # 1차원
# array(['title', 'category', 'subscriber', 'view', 'video'], dtype=object)
# values 구성요소 확인
df.values
```

![1.png](./youtube_LAB_img/1%203.png)

⇒ **`ndarray` - `numpy`의 배열, 2차원 배열( array타입보다 효율적이고 빠름)**

### ❗DataFrame의 한 개의 column은 Series이다.

- `**DataFrame[컬럼명]**` : Series타입
- `**DataFrame[[컬럼명1, 컬럼명2, ...]]**` : DataFrame 타입

```python
s = df['video']
print(type(s))
s.head(5)
```

![1.png](./youtube_LAB_img/1%204.png)

```python
temp = df[['title', 'video']]
print(type(temp))
temp.head(3)
```

💡 `**df[ ]` : 인덱싱 - Series타입
`df[[]]` : 목록 - DataFrame타입\*\*

![1.png](./youtube_LAB_img/1%205.png)

### Series의 구성요소

- `**Seriex.index**` : Series의 행 index
- `**Series.values**` : 1차원 Series 데이터

![1.png](./youtube_LAB_img/1%206.png)

```python
df['title'].index      # RangeIndex(start=0, stop=1000, step=1)
```

```python
df['title'].values[:10] # 슬라이싱
```

![1.png](./youtube_LAB_img/1%207.png)

💡 **DataFrame의 index, columns 및 Series의 index 는 할당연산을 사용하여 변경 가능**
✅ **단, 개수가 동일해야 함**

```python
df.columns
# Index(['title', 'category', 'subscriber', 'view', 'video'], dtype='object')
df.columns **=** ['채널', '카테고리', '구독자', '조회', '영상']
df.head(2)
```

![1.png](./youtube_LAB_img/1%208.png)

## 데이터 타입 변경

---

### 데이터 타입 확인하는 방법

- `**DataFrame.info()**` : dtype 뿐 아니라 Non Null, Memory의 정보까지 표시됨
- `**DataFrame.dtypes**` : 각 columns 별 dtype 확인
- `**Series.dtype**` : Series의 dtype 확인

```python
# `object` : 문자열타입
df.dtypes
# 일부 컬럼만 데이터 타입 확인
df['subscriber'].dtype      # object
```

![1.png](./youtube_LAB_img/1%209.png)

### 데이터 타입 변경하는 방법

- `**Series.astype(타입)`\*\*
- 타입 종류 : `int`, `int32`, `int64`, `float`, `str`, `category`, …등의 문자열로 지정,
  `np.int16`, `np.float32`, `np.datetime64`, … 등의 numpy 타입으로 지정
- numpy 타입으로 지정하기 위해서는 `import numpy as np` 라이브러리 추가 필수

```pytho# ERROR : 한글, 특수문자 등이 섞여 있으면 정수로 변경할 수 없어서
~~df['subscriber'].astype('int64')~~
```

![1.png](./youtube_LAB_img/1%2010.png)

### ⇒ 데이터 값 변경 후 타입 변경 → `Series` 타입으로 출력

- `**Series.replace(**변경대상, 변경내용**)**`
- `**Series.replace(**[변경대상1, 변경대상2, ...], [변경내용1, 변경내용2, ...]**)**`
- `**Series.replace({**변경대상1:변경내용1, 변경대상2:변경내용2, …}**)**`
- `**str**` accessor를 사용해서도 값 변경 가능
- DataFrame도 replace 메서드 있음
- replace는 기본적으로 값 전체를 변경대상으로 지정함
- **`regex=True`**를 사용하면 변경대상을 일부 내용만 대상으로 지정 할 수 있음
- regex : regular expression(정규식, 정규표현식)

```python
df['subscriber'].replace('만', '0000').head(# 변경되지 않음
-> '5140만' 값 전체를 하나로 인식하여 '만'을 찾지 못함
df['subscriber'].replace('5140만', '51400000').head(# '5140만'만 변경됨
df['subscriber'].replace('만', '0000', regex=True).head()# 전부 변# 값을 분리해서 '만'을 찾# return값이 있으므로 저장은 아님 -> 따로 대입하는 과정이 있어야 저장됨
```

```python
# 데이터 타입 변경
print(df['subscriber'].replace('만', '0000', regex=True).astype('int64'))
```

```python
# 변경할 내용이 여러  개 일 경우 두 개의 list 또는 dict 를 사용합니다
# df의 'view' 컬럼에 대해 '억'에 대해서는 삭제, '만'에 대해서는 '0000'로 변경하는 작업을 수행한 뒤,
# astype('int64')를 사용하여 데이터 타입을 정수로 변경하고 처음 5개 데이터를 출력합니다.
df['view'].replace(['억', '만'], ['', '0000'], regex=True).head()
df['view'].replace({'억': '', '만' : '0000'}, regex=True).astype('int64').head()
```

```python
# 콤마(,)는 의미가 있는 문자(=메타문자)이므로 \(역슬래쉬)를 함께 사용합니다.
# 메타문자 : , . + ? * ^ $ [  ]  (etc)... 등
# 메타문자의 기능을 없애기 위해 역슬래쉬(\) 사용 (ex : '\,'  '\.')**
# df의 'video' 컬럼에서 '개'와 ','을 제거하는 작업을 수행한 뒤, 처음 5개 데이터를 출력합니다
df['video'].replace(['\,', '개'], ['', ''], regex=True).head()
df['video'].replace(['\,', '개'], '', regex=True).head()
# 동일한 문자를 변경하거나 변경될 때 리스트에 담지 않아도 가능
```

```python
# df의 'video' 컬럼에서 '개', ','을 제거하고, astype('int32')를 사용하여 는 작업을 수행한 뒤, 처음 5개 데이터를 출력합니다.
df['video'].replace(['\,', '개'], '', regex=True).astype('int32').head()
# int 64, 32 중 어떤걸 사용해도 무관**
```

### 원래 데이터의 값 별 개수 확인

- `Series.value_counts()` : 값 별 개수를 Series로 반환
- 개수가 많은 것부터 내림차순으로 정렬되어 반환
- 값이 index, 개수가 value로 사용됨
- `category`타입 : 내부적으로 일련번호로 관리하여 메모리 사용이 줄어듦.

**index의 정렬**

- `DataFrame / Series.sort_index(ascending=True)`

```python
# df의 열 중 'category' 컬럼에 대해 값 별 개수(몇 번 나왔는지)를 확인합니다.
df['category'].value_counts()
```

![1.png](./youtube_LAB_img/1%2011.png)

```python
# df의 'category'에 대해 '[', ']'을 제거하고, astype('category') 를 사용하여 category 타입으로 변경합니다.
#ⅰ) 첫글자, 마지막 글자가 아니여도 제거(중간에 있어도 찾음) - dict, list타입**
temp = df['category'].replace({'\[':'','\]':''}, regex=True# dict타입을 이용해서 제거
temp.value_counts()
df['category'].replace(['\[','\]'], '', regex=True).astype('category')
```

![1.png](./youtube_LAB_img/1%2012.png)

![2.png](./youtube_LAB_img/2.png)

```python
#ⅱ) 첫글자와 마지막 글자만 확인(문자열 중간까지 확인X)**
df['category'].str #문자열에 사용할 수 있는 accessor - 모두 문자열로 봄(따라서 슬라이싱 가능)
# <pandas.core.strings.accessor.StringMethods at 0x7fe957bbb370>
df['category'].str[1:-1].astype('category')
```

```python
# 위의 replace 및 accessor-str을 사용한 작업을 요약해 보겠습니다. 반영을 위해 대입하는 작업이 필요함
df['subscdf['video'] = df['video'].replace(['개', '\,'], '', regex=True).astype('int32')
df['category'] = df['category'].str[1:-1].astype('category')
df['video'] = df['video'].replace(['개', '\,'], '', regex=True).astype('int32')
df['category'] = df['category'].str[1:-1].astype('category')
df.info()
```

![1.png](./youtube_LAB_img/1%2013.png)

```python
# 'youtube_v1.xlsx' 엑셀 파일로 저장하기
df.to_excel('youtube_v1.xlsx')
temp = pd.read_excel('youtube_v1.xlsx', engine='openpyxl')
temp.info()
```

- `0 Unnamed` - index까지 저장돼서. index를 저장하지 않으려면 저장 시 `index=False`가 필요함

![1.png](./youtube_LAB_img/1%2014.png)

```python
df.to_excel('youtube_v1.xlsx', index=False)
temp = pd.read_excel('youtube_v1.xlsx', engine='openpyxl')
temp.info()
```

![2.png](./youtube_LAB_img/2%201.png)

**⇒ 다시 사용하기 위해서는 다운로드/업로드가 필요함 - 자동 삭제됨**

### datetime, category 타입변경

- `pd.to_datetime(Series, format='형식')`
  - `%Y` : 4글자 년도, `%y` : 2글자 년도, `%m` : 2글자 월, `%d` : 2글자 일
  - 다양한 형식 문자들 : [https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior](https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior)
  - `format`의 지정이 필수는 아님
- `pd.Categorical(Series, categories=['범주1', '범주2', ...], ordered=None)`
  - `ordered=True` 사용시 순서 있는 범주형, 정렬 시(`.sort_values()`) 정해진 순서가 사용됨
  - `categories`, `ordered`의 지정이 필수는 아님

```python
temp = pd.DataFrame({'날짜_일반': ['2021/01/01', '2021/01/02', '2021/01/03', '2021/01/04', '2021/01/05'],
                     '날짜_시간': ['2021-01-01 1:12:10', '2021-01-02 1:13:45', '2021-01-03 2:50:10', '2021-01-04 3:12:30', '2021-01-05 5:40:20'],
                     '날짜_특수': ['21-01-01', '21-01-02', '21-01-03', '21-01-04', '21-01-05'],
                     '범주': ['금', '토', '일', '월', '화']})
temp
```

![1.png](./youtube_LAB_img/1%2015.png)

```python
temp.info()
```

![1.png](./youtube_LAB_img/1%2016.png)

```python
import numpy as np
# Series.astype(np.datetime64) 을 사용하여 '날짜_일반'의 dtype을 변경해 보자
s1 = temp['날짜_일반'].astype(np.datetime64)
s1
```

![1.png](./youtube_LAB_img/1%2017.png)

```python
# Series.astype(np.datetime64) 을 사용하여 '날짜_시간'의 dtype을 변경해 보자
s2 = temp['날짜_시간'].astype(np.datetime64)
s2
```

![1.png](./youtube_LAB_img/1%2018.png)

```python
# Series.astype(np.datetime64)을 사용하여 '날짜_특수'의 dtype을 변경해 보자
s3 = temp['날짜_특수'].astype(np.datetime64)
s3
```

![1.png](./youtube_LAB_img/1%2019.png)

- 연원일을 제대로 인식하지 못함
  ⇒ `format`형식 설정 필요

```python
s4 =  pd.to_datetime(temp['날짜_특수'], format='%y-%m-%d')
```

![1.png](./youtube_LAB_img/1%2020.png)

```python
# Series.astype('category')를 사용하여 '범주'의 dtype을 변경해 보자
s5 = temp['범주'].astype('category')
s5
```

![1.png](./youtube_LAB_img/1%2021.png)

```pytho# 가나다라 순으로 값 정렬
s5.sort_values()
```

![1.png](./youtube_LAB_img/1%2022.png)

```python
s6 = pd.Categorical(temp['범주'],
									categories = ['월', '화', '수', '목', '금', '토', '일'], ordered=True)
s6, s6.sort_values()
```

![1.png](./youtube_LAB_img/1%2023.png)

## 인기 채널 확인하기

---

### 데이터 정렬하기

- `DataFrame.sort_values(컬럼명, ascending=True)`
- `DataFrame.sort_values([컬럼명1, 컬럼명2, ...], ascending=[...])`
- default는 오름차순, `ascending=False`를 사용하여 내림차순 지정
- 1차기준, 2차기준 등 여러개 기준이 존재하는 경우
  - 1차기준 정렬된 후 , 1차 기준이 같은 것 내부에서 2차 기준으로 정렬됨
  - 정렬방법은 각 기준별로 부여하거나, 1개만 부여할 수 있음

```python
import pandas as pd
df = pd.read_excel('data_01/youtube_rank.xlsx', engine='openpyxl')
df['subscriber'] = df['subscriber'].replace('만', '0000', regex=True).astype('int64')
df['view'] = df['view'].replace({'억':'', '만':'0000'}, regex=True).astype('int64')
df['video'] = df['video'].replace(['개', '\,'], '', regex=True).astype('int32')
df['category'] = df['category'].str[1:-1].astype('category')
df.head(2)
```

```python
# subscriber' 가 가장 많은 5개의 채널을 알아봅니다.
df.sort_values('subscriber', ascending=False).head()
```

![1.png](./youtube_LAB_img/1%2024.png)

```python
# 'view'가 가장 많은 5개 채널을 알아봅니다
df.sort_values('view', ascending=False).head()
# 'video'가 가장 많은 5개 채널을 알아봅니다
df.sort_values('video', ascending=False).head()
# 'video'가 가장 적은 5개 채널을 알아봅니다
df.sort_values('video').head()  # ascending 생략 가능(default는 오름차순)
# 'category'로 오름차순, 'subscriber'로 내림차순 정렬해 봅니다.
df.sort_values(['category','subscriber'], ascending=[True,False])
df.sort_values(['category','subscriber'], ascending=True)  # 둘 다 True인 경우 하나만 지정 가능
```

### Boolean indexing 사용하여 조건에 맞는 데이터 가져오기

- `**DataFrame.loc[조건, :]**` ← [(행에 대한 조건), (열에 대한 조건)] : 행에만 주거나 행, 열 둘 다 주거나 택 1
- **`DataFrame[조건]`** : 행에 대한 조건만 가능
- 조건은 boolean dtype이어야 하며 행의 수와 같아야 함
- 복잡한 조건 작성
  - OR ⇒ `(조건1)|(조건2)`
  - AND ⇒ `(조건1)&(조건2)`
  - NOT ⇒ `~(조건)`

```python
temp = pd.DataFrame({'A': [1, 2, 3, 4],
                     'B': [6, 5, 4, 3],
                     'C': [3, 4, 5, 2]})
temp
```

![1.png](./youtube_LAB_img/1%2025.png)

```python
temp[[True, True, False, True]] #행의 인덱스 0,1,3출력
```

![1.png](./youtube_LAB_img/1%2026.png)

```python
temp.loc[[False, True, False, True]]
temp.loc[[False, True, False, True], ['A', 'C']]
```

![1.png](./youtube_LAB_img/1%2027.png)

```python
# 'category'가 '음악/댄스/가수'인 채널의 subscriber TOP5를 알아봅니다.
(df['category'] == '음악/댄스/가수').sum() # 조건이 True인 개수 확인
df[df['category'] == '음악/댄스/가수'].sort_values('subscriber', ascending=False).head()
```

![1.png](./youtube_LAB_img/1%2028.png)

```python
# 'category'가 'TV/방송'인 채널의 view TOP5를 알아봅니다.
(df['category'] == 'TV/방송').sum()
df[df['category'] == 'TV/방송'].sort_values('view', ascending=False).head()
```

```python
# 'subscriber'가 30000000 (3천만) 이상인 채널을 알아봅니다.
df[df['subscriber'] >= 30000000]
```

![1.png](./youtube_LAB_img/1%2029.png)

```python
# 'video' 개수가 30000 이상 35000 이하인 채널을 알아봅니다
df[(df['video'] >= 30000) & (df['video'] <= 35000)]  << **괄호로 꼭 묶어줘야함**
# 'subscriber'가 30000000 (3천만)이상 이거나, 'video' 개수가 50000 이상인 채널을 알아봅니다.
df.loc[(df['subscriber'] >= 30000000) | (df['video'] >=50000), :] << **:** - 전부 다
```

![1.png](./youtube_LAB_img/1%2030.png)

### Series의 value가 목록에 포함된 내용인지 확인

- `**Series.isin([내용1, 내용2, …])**` : Series에 포함된 내용이 목록에 있는 경우 True, 없으면 False인 Boolean Series 반환(Boolean indexing에 사용)

```python
# 'category'의 값 별 개수를 확인합니다.
df['category'].value_counts(# 개수별로 내림차순으로 보여줌
```

![1.png](./youtube_LAB_img/1%2031.png)

```python
# 'category'가 'TV/방송' 이거나 '게임'인 채널의 개수를 확인합니다.  (262개)
방식 #
temp = df[(df['category'] == 'TV/방송')| (df['category'] == '게임')]
len(temp)  # 262
```

```python
방식 #
df['category'].isin(['TV/방송', '게임'])    # 해당 조건이 맞으면 bool타입으로 출력
temp = df[df['category'].isin(['TV/방송', '게임'])]# True인 것만 출력
temp
len(temp)  # 262
```

![1.png](./youtube_LAB_img/1%2032.png)

![1.png](./youtube_LAB_img/1%2033.png)

```python
# 'category'가 '음악/댄스/가수'인 채널의 subscriber TOP5를 알아봅니다. (isin 활용)
df[df['category'].isin(**[**'음악/댄스/가수'**]**)].sort_values('subscriber', ascending=False).head()
```

![1.png](./youtube_LAB_img/1%2034.png)

### Series(Object타입)의 str Accessor 사용

- `**str.contains('문자열')**` : 특정 문자열을 포함하는지 아닌지를 True/False로 반환(Boolean Indexing 조건으로 사용 가능)
- `**str.upper()**` : 영문자 소문자를 대문자로 변경
- `**str.lower()**` : 영문자 대문자를 소문자로 변경
- 세부 내용 : [https://pandas.pydata.org/docs/reference/series.html#string-handling](https://pandas.pydata.org/docs/reference/series.html#string-handling)

### Series의 데이터를 list 및 ndarray로 반환

- `Series.to_list()` : Series의 values를 `list`로 반환
- `Series.to_numpy()` : Series의 values를 `ndarray`로 반환(`Series.values`와 동일)

```python
# title에 'KBS'가 포함된 채널 명 목록을 만들어 봅니다.
df['title'].str.contains('KBS')]['title'].to_numpy()# DataFrame[행조건][열조건]
df.loc[df['title'].str.lower().str.contains('kbs'), 'title'].to_numpy()
df.loc[df['title'].str.upper().str.contains('KBS'), 'title'].to_numpy()
```

![1.png](./youtube_LAB_img/1%2035.png)

## 통계값 알아보기

- `DataFrame.describe()` : 숫자형 데이터타입을 가는 컬럼에 대해 count, mean, std, min, max, Q1, Q2, Q3 등의 통계값 구하기
- **`Series.count()`** : 개수
- **`Series.sum()`** : 합계
- **`Series.mean()`** : 평균
- **`Series.std()`** : 표준편차
- **`Series.var()`** : 분산
- **`Series.median()`** : 중앙값
- **`Series.mode()`** : 최빈값
- **`Series.quantile([0.5, 0.75])`** : 분위수 || IQR = Q3(0.75) - Q1(0.25)

```python
import pandas as pd
df = pd.read_excel('data_01/youtube_rank.xlsx', engine='openpyxl')
df['subscriber'] = df['subscriber'].replace('만', '0000', regex=True).astype('int64')
df['view'] = df['view'].replace({'억':'', '만':'0000'}, regex=True).astype('int64')
df['video'] = df['video'].replace(['개', '\,'], '', regex=True).astype('int32')
df['category'] = df['category'].str[1:-1].astype('category')
df.head(2)
```

```python
# 소수점 아래 2째자리까지 표시되도록 설정하기 - 실제 저장되는 건 아님
pd.optins.display.float_format = '{:,.2f}'.format
```

```python
# subscriber, view, video에 대한 통계값을 알아봅니다. (describe 사용)
df.describe()
```

![1.png](./youtube_LAB_img/1%2036.png)

```python
# 'video' 컬럼의 데이터 개수를 구합니다
df['video'].count                        # 1000
# 'video' 컬럼의 합계를 구합니다.
df['video'].sum()                        # 4766680
# 'video' 컬럼의 평균, 중앙값을 구합니다.
df['video'].mean(), df['video'].median() # (4766.68, 506.0)
# 'video'의 분산과 표준편차를 구합니다.
df['video'].var_), df['video'].std()     # (646420552.9165165, 25424.801924823652)
# 'subscriber'의 최대, 최소값을 구합니다.
df['subscriber'].max(), df['subscriber'].min(# (51400000, 400000)
# 'subscriber'의 최빈값을 구합니다. => Series : 최빈값이 여러개 일 수도 있어서
df['subscriber'].mode(), df['subscriber'].mode()[0]# 하나만 구하려면 인덱싱이 필요함
```

![1.png](./youtube_LAB_img/1%2037.png)

```python
# 'subscriber'의 Q1, Q2, Q3(25% 50%, 75%) 를 구합니다.
df['subscriber'].quantile()     # 780000.0(50%값)
Q1, Q2, Q3 = df['subscriber'].quantile([0.25, 0.5, 0.75])
print(Q1, Q2, Q3, Q3-Q1)        # 540000.0 780000.0 1392500.0 852500.0
```

### 그룹별 통계치 구하기

- `DataFrame.groupby(그룹명).적용할통계함수()`
  - DataFrame의 함수 적용 가능 컬럼들에 대해 그룹별 통계치를 구함
  - 통계함수에는 sum, mean, std, var, min, max, count, quantile 등이 있음
- `DataFrame.groupby(그룹명)[컬럼].적용할통계함수()` : Series
- `DataFrame.groupby(그룹명)[[컬럼1, 컬럼2, ...]].적용할통계함수()` : DataFrame

```python
# category 별 평균을 구할 수 있는 모든 컬럼에 대한 평균을 구합니다.
df.groupby('category').mean()
```

![1.png](./youtube_LAB_img/1%2038.png)

```python
# category 별 view에 대한 평균을 구합니다.# type()
df.groupby('category')['view'].mean()    # pandas.core.series.Series 타입
df.groupby('category')[['view']].mean()  # pandas.core.frame.DataFrame 타입
```

![1.png](./youtube_LAB_img/1%2039.png)

![2.png](./youtube_LAB_img/2%202.png)

```python
# category 별 view, video에 대한 합계를 구합니다.
df.groupby('category')[['view', 'video']].sum()
```

![1.png](./youtube_LAB_img/1%2040.png)
