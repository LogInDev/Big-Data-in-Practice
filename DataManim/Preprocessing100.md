# 전처리 100

- [1]. **데이터 로드. 데이터는 \t를 기준으로 구분되어 있음**
  ```python
  import pandas as pd
  pd.read_csv(DataUrl,sep='\t')
  ```
- [5]. **6번째 컬럼명 출력**
  ```python
  df.columns[5]
  ```
- [6]. **6번째 컬럼의 데이터 타입 출력**
  ```python
  df.iloc[:,5].dtype
  ```
- [8]. **6번째 컬럼의 3번째 값 출력**
  ```python
  df.iloc[2,5]
  ```
- [9]. **데이터 로드. 컬럼이 한글이여서 처리 필요**
  ```python
  import pandas as pd
  pd.read_csv(DataUrl, encoding='euc-kr')
  ```
- [11]. **수치형 변수를 가진 컬럼을 출력하라**
  ```python
  df.select_dtype**s**(exclude='object').columns
  ```
- [12]. **범주형 변수를 가진 컬럼을 출력하라**
  ```python
  df.select_dtypes(include=object).columns
  ```
- [13]. **각 컬럼의 결측치 개수 파악**
  ```python
  df.isna().sum()
  df.isnull().sum()
  ```
- [15]. **각 수치형 변수의 분포(사분위, 평균, 표준편차, 최대, 최소)를 확인하라**
  ```python
  df.describe()
  ```
- [16]. **거주인구 컬럼의 값들을 출력하라**
  ```python
  df['거주인구']
  ```
- [17]. **평균 속도 컬럼의 4분위 범위(IQR) 값을 구하여라**
  ```python
  Q3 = df['평균 속도'].quantile(0.75)
  Q1 = df['평균 속도'].quantile(0.25)
  IQR = Q3 - Q1
  IQR
  ```
- [18]. **읍면동명 컬럼의 유일값 개수를 출력하라**
  ```python
  df['읍면동명'].nunique()
  ```
- [19]. **읍면동명 컬럼의 유일값을 모두 출력하라**
  ```python
  df['읍면동명'].unique()
  ```
- [22]. **quantity컬럼 값이 3인 데이터를 추출하여 index를 0부터 정렬하고 첫 5행을 출력하라**
  ```python
  df[df['quantity'] == 3].head().reset_index(drop=True)
  ```
- [24]. **item_price 컬럼의 달러표시 문자를 제거하고 float 타입으로 저장하여 new_price 컬럼에 저장하라**
  - replace가 적용이 안되면, 이스케이프 문자일 수 가능성이 있음 ⇒ `\`사용
  - `regex=True` 문자 중 일부를 지울 경우 사용
  ```python
  df['new_price'] = df['item_price'].replace('\$', '', regex=True).astype('float')
  df['new_price'] = df['item_price'].str[1:].astype('float')
  ```
- [25]. **new_price 컬럼이 5이하의 값을 가지는 데이터프레임을 추출하고, 전체 갯수를 구하여라**
  ```python
  len(df[df['new_price'] <= 5])
  ```

❗ 조건을 넣을 때는 `df.loc[(조건)]` 사용

- [26]. **item_name명이 Chicken Salad Bowl 인 데이터 프레임을 추출하고 index 값을 초기화 하여라**
  ```python
  df.loc[df['item_name'] == 'Chicken Salad Bowl'].reset_index(drop=True)
  ```
- [27]. **new_price값이 9이하이고 item_name 값이 Chicken Salad Bowl인 데이터 프레임을 추출하라**
  - OR ⇒ `(조건1)|(조건2)`
  - AND ⇒ `(조건1)&(조건2)`
  - NOT ⇒ `~(조건)`
  > ⇒ 괄호 반드시 할 것
  ```python
  df.loc[(df.item_name == 'Chicken Salad Bowl') & (df.new_price <= 9)]
  ```

❗ **`DataFrame.sort_values(컬럼명, ascending=True)`**

- [28]. **df의 new_price 컬럼 값에 따라 오름차순으로 정리하고 index를 초기화 하여라**
  ```python
  df.sort_values('new_price').reset_index(drop=True)
  ```

❗ `**str.contains('문자열')` :\*\* 특정 문자열을 포함하는지 아닌지를 True/False로 반환

- [29]. **df의 item_name 컬럼 값 중 Chips 포함하는 경우의 데이터를 출력하라**
  ```python
  df.loc[df.item_name.str.contains('Chips')]
  ```
- [30]. **df의 짝수번째 컬럼만을 포함하는 데이터 프레임을 출력하라**
  ```python
  df.iloc[:, ::2]
  ```

> ❗ `DataFrame.drop_duplicates(기준 컬럼, keep=~)`
> keep = first(default. 첫번째 것만 남기고 중복 삭제), last(마지막 것만 남기고 중복 삭제), False(전부 삭제)

- [33]. **df의 item_name 컬럼 값이 Steak Salad 또는 Bowl인 데이터를 데이터 프레임화 한 후, item_name를 기준으로 중복행이 있으면 제거하되 첫번째 케이스만 남겨라**
  ```python
  Ans = df.loc[(df.item_name == 'Steak Salad') | (df.item_name == 'Bowl')]
  Ans.drop_duplicates('item_name')
  ```
- [34]. **df의 item_name 컬럼 값이 Steak Salad 또는 Bowl 인 데이터를 데이터 프레임화 한 후 , item_name을 기준으로 중복행이 있으면 제거하되 마지막 케이스만 남겨라**
  ```python
  Ans = df.loc[(df.item_name == 'Steak Salad') | (df.item_name == 'Bowl')]
  Ans.drop_duplicates('item_name', keep='last')
  ```
- [35]. **df의 데이터 중 new_price값이 new_price값이 평균값 이상을 가지는 데이터들을 인덱싱하라**
  ```python
  df.loc[df['new_price'] >= df['new_price'].mean()]
  ```
- [36]. **df의 데이터 중 item_name의 값이 Izze 데이터를 Fizzy Lizzy로 수정하라**
  ```python
  df.loc[df.item_name == 'Izze', 'item_name'] = 'Fizzy Lizzy'
  df['item_name']=df['item_name'].replace('Izze', 'Fizzy Lizzy', regex=True)
  ```
- [37]. **df의 데이터 중 choice_description 값이 NaN인 데이터의 개수를 구하여라**
  ```python
  df['choice_description'].isna().sum()
  ```

❗ `.isna()`(= `.isnull()`) : 결측치에 대해 T, F ≠ `.notna()`(= `.notnull()`) : 결측치가 아닌 것에 대해 T, F

- [38]. **df의 데이터 중 choice_description 값이 NaN 인 데이터를 NoData 값으로 대체하라(loc 이용)**
  ```python
  df.loc[df['coice_description'].isna(), 'choice_description'] = 'NoData'
  df['coice_description'].fillna('NoData')
  ```
- [40]. **df의 데이터 중 choice_description 값에 Vegetables 들어가지 않는 경우의 개수를 출력하라**
  ```python
  len(df.loc[~df['choice_description'].str.contains('Vegetables')])
  ```
- [41]. **df의 데이터 중 item_name 값이 N으로 시작하는 데이터를 모두 추출하라**
  ```python
  df[df['item_name'].str.startswith('N')]
  df.loc[df['item_name'].str[0]=='N']
  ```
- [42]. **df의 데이터 중 item_name 값의 단어개수가 15개 이상인 데이터를 인덱싱하라**
  ```python
  df.loc[df['item_name'].str.len() >= 15]
  ```
- [43]. **df의 데이터 중 new_price값이 lst에 해당하는 경우의 데이터 프레임을 구하고 그 개수를 출력하라**
  lst =[1.69, 2.39, 3.39, 4.45, 9.25, 10.98, 11.75, 16.98]
      ```python
      len(df.loc[df.new_price.isin(lst)])
      ```

❗ `.value_counts()` : 각각의 값의 개수를 출력(default는 개수 기준으로 내림차순으로 출력)
`.sort_index()` : 인덱스를 기준으로 정렬(default는 오름차순 | 내림차순 : ascending=False)
`.sort_values()` : 값을 기준으로 정렬(default는 오름차순 | 내림차순 : ascending=False)

- [45]. **데이터의 각 host_name의 빈도수를 구하고 host_name으로 정렬하여 상위 5개를 출력하라**
  ```python
  df.groupby('host_name').size().head()
  df.host_name.value_counts().sort_index().head()
  ```

❗ `index.to_series()` : Series로 변환 || `Series.to_frame()` : DataFrame으로 변환

❗ `df.groupby('host_name').size(as_index=)` : 각 그룹의 행의 수를 출력(해당 그룹을 인덱스로 지정하면 Series타입으로 출력, 인덱스로 지정 안하면 DataFrame타입으로 출력)

- [46]. **데이터의 각 host_name의 빈도수를 구하고 빈도수 기준 내림차순 정렬한 데이터 프레임을 만들어라. 빈도수 컬럼은 counts로 명명하라**
  ```python
  df.groupby('host_name').size().to_frame().rename(columns={'host_name':'counts'})
                                      .sort_values('counts', ascending=False)
  ```
- [47]. **neighbourhood_group의 값에 따른 neighbourhood컬럼 값의 갯수를 구하여라**
  ```python
  df.groupby(['neighbourhood_group', 'neighbourhood'], as_index=False).size()
  ```
- [48]. **neighbourhood_group의 값에 따른 neighbourhood컬럼 값 중 neighbourhood_group그룹의 최댓값들을 출력하라**
  ```python
  gg = df.groupby(['neighbourhood_group', 'neighbourhood'], as_index=False).size()
  gg.groupby('neighbourhood_group').max()
  ```

❗ `df.groupby().agg()` : groupby한 컬럼에 대한 집계를 출력

- [49]. **neighbourhood_group 값에 따른 price값의 평균, 분산, 최대, 최소 값을 구하여라**
  ```python
  df[['neighbourhood_group','price']].groupby('neighbourhood_group')
                                               .agg(['mean','var','max','min'])
  ```
- [51]. **neighbourhood 값과 neighbourhood_group 값에 따른 price 의 평균을 구하라**
  ```python
  df[['neighbourhood','neighbourhood_group','price']]
                  .groupby(['neighbourhood','neighbourhood_group']).agg('mean')
  df.groupby(['neighbourhood','neighbourhood_group'])['price'].agg('mean')
  df.groupby(['neighbourhood','neighbourhood_group'])['price'].mean()
  ```

❗ `df.unstack(level=-1, fill_value=None)` : 옵션인 `level` 수 만큼 인덱스에서 제외시킴. 오른쪽부터 제외. 멀티 인덱스가 아닌 하나의 인덱스라면 Series타입으로 출력

- `level` : default는 -1. -2 설정시 인덱스 2개가 컬럼으로 이동
- `fill_value` : default는 None. Nan 값을 대체할 값을 설정

- [52]. **neighbourhood 값과 neighbourhood_group 값에 따른 price 의 평균을 계층적 indexing 없이 구하라(’계층적 indexing’이란 멀티 인덱싱을 의미함. - 굵게 표시된게 index)**
  ```python
  df.groupby(['neighbourhood','neighbourhood_group']).price.mean().unstack()
  ```
- [53]. **neighbourhood 값과 neighbourhood_group 값에 따른 price 의 평균을 계층적 indexing 없이 구하고 nan 값은 -999값으로 채워라**
  ```python
  df.groupby(['neighbourhood','neighbourhood_group'])['price'].mean()
                                                      .unstack(fill_value=-999)
  ```
- [54]. **데이터 중 neighbourhood_group 값이 Queens값을 가지는 데이터들 중 neighbourhood 그룹별로 price값의 평균, 분산, 최대, 최소값을 구하라**
  ```python
  df.loc[df['neighbourhood_group'] == 'Queens'].groupby('neighbourhood')['price']
  																					.agg(['mean','var','max','min'])
  ```

❗ `.reshape(행 수, 열 수)` : 지정한 행 수와 열 수의 2차원 배열 형태로 출력.

- 행 수가 `-1`인 경우 : 지정한 열 수에 맞춰 자동으로 행 수를 지정

- [55]. **데이터 중 neighbourhood_group 값에 따른 room_type 컬럼의 숫자를 구하고 neighbourhood_group 값을 기준으로 각 값의 비율을 구하여라**
  ```python
  Ans = df[['neighbourhood_group','room_type']]
               .groupby(['neighbourhood_group','room_type']).size().unstack()
  Ans.loc[:,:] = (Ans.values /Ans.sum(axis=1).values.reshape(-1,1))
  ```

❗ 데이터를 불러올때 (ex : csv) unnamed컬럼이 생기는 경우 ⇒ read_csv(url, `index_col=0`)을 붙여주면 됨.

❗ `df[].map(dict or function)` : 인덱싱한 컬럼에 괄호에 dict을 넣으면 해당 컬럼 값을 키로 값으로 내용이 변경됨. 함수도 사용가능

- ex ] `df.Income_Category.map(lambda x: dic[x])`

- [57]. **Income_Category의 카테고리를 map 함수를 이용하여 다음과 같이 변경하여 newIncome 컬럼에 매핑하라**
  > Unknown : N
  >
  > Less than $40K : a
  >
  > $40K - $60K : b
  >
  > $60K - $80K : c
  >
  > $80K - $120K : d
  >
  > $120K +’ : e
  ```python
  # 'Income_Category' 안에 값을 먼저 확인
  df['Income_Category'].unique()
  ```
  ```python
  dic = {
      'Unknown'        : 'N',
      'Less than $40K' : 'a',
      '$40K - $60K'    : 'b',
      '$60K - $80K'    : 'c',
      '$80K - $120K'   : 'd',
      '$120K +'        : 'e'
  }
  ```
  ```python
  df['Income_Category'].map(dic).unique()   >> 잘 바뀌는지 확인
  df.loc[:,'newIncome'] = df['Income_Category'].map(dic)
  ```

❗ `df[].apply(fn)` : 해당 컬럼등에 함수를 사용해서 변경. map()과 비슷한 기능이지만 좀 더 복잡한 처리 과정이 필요할 때 사용

- [58]. **Income_Category의 카테고리를 apply 함수를 이용하여 다음과 같이 변경하여 newIncome 컬럼에 매핑하라**
  > Unknown : N
  >
  > Less than $40K : a
  >
  > $40K - $60K : b
  >
  > $60K - $80K : c
  >
  > $80K - $120K : d
  >
  > $120K +’ : e
  ```python
  >> 'Income_Category' 안에 값을 먼저 확인
  df['Income_Category'].unique()
  ```
  ```python
  	def changeCategory(x):
      if x =='Unknown':
          return 'N'
      elif x =='Less than $40K':
          return 'a'
      elif x =='$40K - $60K':
          return 'b'
      elif x =='$60K - $80K':
          return 'c'
      elif x =='$80K - $120K':
          return 'd'
      elif x =='$120K +' :
          return 'e'
  ```
  ```python
  df['newIncome']  =df.Income_Category.apply(changeCategory)
  ```
- [59]. **Customer_Age의 값을 이용하여 나이 구간을 AgeState 컬럼으로 정의하라. (0~9 : 0 , 10~19 :10 , 20~29 :20 … 각 구간의 빈도수를 출력하라**
  ```python
  df['AgeState'] = df['Customer_Age'].map(lambda x: x//10*10)
  df['AgeState'].value_counts()
  ```
- [60]. **Education_Level의 값 중 Graduate단어가 포함되는 값은 1 그렇지 않은 경우에는 0으로 변경하여 newEduLevel 컬럼을 정의하고 빈도수를 출력하라**
  ```python
  df['newEduLevel'] = df['Education_Level'].map(lambda x : 1 if 'Graduate' in x else 0)
  df['newEduLevel'].value_counts()
  ```

❗ `axis=0` : 행 방향(index)으로 동작. 작업 결과가 행으로 나타남
`axis=1` : 열 방향(columns)으로 동작. 작업 결과가 열로 나타남

- [62]. **Marital_Status 컬럼값이 Married 이고 Card_Category 컬럼의 값이 Platinum인 경우 1 그외의 경우에는 모두 0으로 하는 newState컬럼을 정의하라. newState의 각 값들의 빈도수를 출력하라**
  ```python
  def check(x):
      if x['Marital_Status'] == 'Married' and x['Card_Category'] == 'Platinum':
          return 1
      else:
          return 0
  ```
  ```python
  df['newState'] = df.apply(check, axis=1)
  df['newState'].value_counts()
  ```
- [63]. **Gender 컬럼값 M인 경우 male F인 경우 female로 값을 변경하여 Gender 컬럼에 새롭게 정의하라. 각 value의 빈도를 출력하라**
  ```python
  df['Gender'] = df['Gender'].replace({'M':'male', 'F':'female'})
  df['Gender'].value_counts()
  ```
- [65]. **Yr_Mo_Dy을 판다스에서 인식할 수 있는 datetime64타입으로 변경하라**
  ```python
  df['Yr_Mo_Dy'] = df['Yr_Mo_Dy'].astype('datetime64')
  df['Yr_Mo_Dy'] = pd.to_datetime(df['Yr_Mo_Dy'])
  ```
- [66]. Yr_Mo_Dy에 존재하는 년도의 유일값을 모두 출력하라
  ```python
  df['Yr_Mo_Dy'].dt.year.unique()
  ```
- [67]. **Yr_Mo_Dy에 년도가 2061년 이상의 경우에는 모두 잘못된 데이터이다. 해당경우의 값은 100을 빼서 새롭게 날짜를 Yr_Mo_Dy 컬럼에 정의하라**
  ```python
  def fix_century(x):
      import datetime
      year = x.year - 100 if x.year >= 2061 else x.year
      return pd.to_datetime(datetime.date(year, x.month, x.day))
  ```
  ```python
  df['Yr_Mo_Dy'] = df['Yr_Mo_Dy'].apply(fix_century)
  ```
  or
  ```python
  pd.to_datetime(df['Yr_Mo_Dy'].astype('str').map(lambda x : str(int(x[:4]) - 100)\
                                                  + x[4:] if x[:4] >= '2061' else x))
  ```
  or
  ```python
  def func(x):
      year = x.year-100 if x.year >= 2061 else x.year
      ymd = f'{year}-{x.month}-{x.day}'
      return pd.to_datetime(ymd)
  df['Yr_Mo_Dy'] = df['Yr_Mo_Dy'].map(func)
  ```
- [68]. 년도별 각 컬럼의 평균 값을 구하여라
  ```python
  df.groupby(df['Yr_Mo_Dy'].dt.year).mean()
  ```

❗ `df[].dt.weekday` : 해당 날짜의 요일 출력(월요일 : 0 ~ 일요일 : 6)

- [69]. weekday 컬럼을 만들고 요일별로 매핑하라
  ```python
  df['weekday'] = df.Yr_Mo_Dy.dt.weekday
  ```
- [70]. weekday 컬럼을 기준으로 주말이면 1 평일이면 0의 값을 가지는 WeekCheck 컬럼을 만들어라.
  ```python
  df['WeekCheck'] = df['weekday'].map(lambda x : 1 if x in [5,6] else 0)
  ```

❗ `df.fillna(method=None)` : DataFrame에 있는 Nan값을 ()안에 값으로 채워줌

- `method=None` : default는 None. `ffill`은 직전 값으로, `bfill`은 직후의 값으로 채워줌

- [72]. 모든 결측치는 컬럼기준 직전의 값으로 대체하고 첫번째 행에 결측치가 있을 경우 뒤에 있는 값으로 대체하라
  ```python
  df = df.fillna(method='ffill').fillna(method='bfill')
  df.isnull().sum()
  ```

❗ `dt.to_period('Y' or 'M')` : 괄호 안이 `Y`인 경우 년도까지 `M`인 경우 년도-월까지 공백인 경우 년도-월-일까지 출력

- [73]. **년도 - 월을 기준으로 모든 컬럼의 평균값을 구하여라**
  ```python
  df.groupby(df['Yr_Mo_Dy'].dt.to_period('M')).mean()
  ```

❗ `.diff(periods=1, axis=0)` : 차분해줌(뒤에 앞에 행을 빼줌)

- `periods:1` : 몇 개 씩 차분하는지 설정. default는 1
- `axis:0` : 차분의 방향 설정. default는 0(’index’) || 1(’columns’)

- [74]. RPT 컬럼의 값을일자별 기중으로 1차 차분하라
  ```python
  # 이미 일자 별로 정렬이 되어있으므로
  df['RPT'].diff()
  ```

❗ `.rolling(window, axis=0)` : window집계함수를 사용하기 위해 window에 설정한 숫자 만큼 묶어줌

- `window` : 묶을 수, int형
- `axis=0` : 묶는 방향. 0은 index, 1은 columns(default는 0)

- [75]. RPT와 VAL의 컬럼을 일주일 간격으로 각각 이동평균한 값을 구하라
  ```python
  df[['RPT', 'VAL']].rolling(7).mean()
  ```

❗ `datetime.timedelta()` : 날짜에 대한 연산을 할 때 사용. (ex : 말일에 1을 추가해도 달까지 수정해줌)

- [76]. 년-월-일:시 컬럼을 pandas에서 인식할 수 있는 datetime 형태로 변경하라. 서울시의 제공데이터의 경우 0시가 24시로 표현된다.
  → datetime은 24시가 없고 00시로 인식하여 24시를 00시로 수정하고 날짜도 하루 더해줘야 하는데 말일인 경우 달도 바꿔줘야한다.
  ```python
  def change_date(x):
      import datetime
      hour = x.split(':')[1]
      date = x.split(":")[0]

      if hour =='24':
          hour ='00:00:00'

          FinalDate = pd.to_datetime(date +" "+hour) +datetime.timedelta(days=1)

      else:
          hour = hour +':00:00'
          FinalDate = pd.to_datetime(date +" "+hour)

      return FinalDate

  df['(년-월-일:시)'] = df['(년-월-일:시)'].apply(change_date)
  ```

❗ `.dt.day_name()` : 날짜에 따른 영어 요일로 바꿔줌

- [77]. 일자별 영어요일 이름을 dayName 컬럼에 저장하라
  ```python
  df['dayName'] = df['(년-월-일:시)'].dt.day_name()
  ```

❗ `df.pivot(index= , columns= , values=)` : 해당 란에 원하는 값을 컬럼명으로 지정하여 df생성
→ pivot생성시 index에 동일한 값이 있는 경우 오류발생 → **pivot_table로 생성해서 aggfunc으로 집계함수를 주면 됨**(86번)

- [78].일자별 각 PM10등급의 빈도수를 파악하라
  ```python
  a = df.groupby([df['(년-월-일:시)'].dt.date, 'PM10등급'], as_index=False).size()
  a.pivot(index='(년-월-일:시)', columns='PM10등급', values='size').fillna(0)
  ```
- [79]. 시간이 연속적으로 존재하며 결측치가 없는지 확인하라
  → 시간을 차분했을 경우 첫 값은 nan, 이후 모든 차분값이 동일하면 연속이라 판단한다.
  ```coffeescript
  df['(년-월-일:시)'].diff().unique()
  ```
- [80]. 오전 10시와 오후 10시(22시)의 PM10의 평균값을 각각 구하여라
  ```python
  df.groupby(df['(년-월-일:시)'].dt.hour).mean().iloc[[10,22],[0]]
  ```

❗ `**DataFrame.set_index(컬럼명, drop=True, inplace=False)**` : 지정한 컬럼을 index로 지정함

- `drop=True` : 지정한 컬럼을 삭제할 지 여부(default는 True)
- `inplace=False` : 지정한 index를 df에 저장할지 여부(default는 False)

`**DataFrame.set_index([컬럼명1, 컬럼명2, ...])**` : 컬럼 목록을 index(Multi Index)로 지정함

- columns에서 index 쪽으로 이동됨, 기존 index는 제거됨

- [81]. 날짜 컬럼을 index로 만들어라
  ```python
  df.set_index('(년-월-일:시)', drop=True, inplace=True)
  ```

❗ `df.resample()` : ()안에 키워드를 입력하면 날짜나 시간에 따라 groupby처리 해줌
→ help(df.resample())

- [82]. 데이터를 주단위로 뽑아서 최소, 최대, 평균, 표준편차를 구하여라
  ```python
  df.resample('W').agg(['min','max','mean','std'])
  ```
- [83]. Indicator을 삭제하고 First Tooltip컬럼에서 신뢰구간에 해당하는 표현을 지워라
  ```python
  df.drop('Indicator', axis=1, inplace=True) >> drop시 axis 꼭 설정할 것!
  df['First Tooltip'] = df['First Tooltip'].map(lambda x:float(x.split("[")[0]))
  ```
- [84, 85]. 년도가 2015년 이상, Dim1이 Both sexes인 케이스를 추출하여 아래와 같이 나라에 따른 년도별 사망률을 데이터 프레임화 하라
  ```python
  target = df[(df.Period >=2015) & (df.Dim1 =='Both sexes')]
  target.pivot(index='Location',columns='Period',values='First Tooltip')
  ```
- [86]. Dim1에 따른 년도별 사망비율의 평균을 구하라
  ```python
  df.pivot_table(index='Dim1',columns='Period',values='First Tooltip',aggfunc='mean')
  ```
- [87, 88]. 한국 올림픽 메달리스트 데이터에서 년도에 따른 medal 개수를 데이터프레임화 하라
  ```python
  kr = df[df.Country=='KOR']
  kr.pivot_table(index='Year',columns='Medal',aggfunc='size').fillna(0)
  ```
- [89]. Sport종류에 따른 성별 수를 구하여라
  ```python
  Ans = df.pivot_table(index='Sport',columns='Gender',aggfunc='size')
  ```
- [90]. Discipline종류에 따른 Medal수를 구하여라
  ```python
  df.pivot_table(index='Discipline', columns='Medal', aggfunc='size')
  ```

❗ Merge보다는 Concat 권장!!!

- [91]. df1과 df2데이터를 하나의 데이터 프레임으로 합쳐라
  ```python
  pd.concat([df1, df2])
  ```
- [92]. df3과 df4 데이터를 하나의 데이터 프레임으로 합쳐라. 둘 다 포함하고 있는 년도에 대해서만 고려한다.
  ```python
  pd.concat([df3, df4], join='inner')
  ```
- [93]. df3과 df4 데이터를 하나의 데이터 프레임으로 합쳐라. 모든 컬럼을 포함하고, 결측치는 0으로 대체한다.
  ```python
  pd.concat([df3, df4], join='outer').fillna(0)
  ```
