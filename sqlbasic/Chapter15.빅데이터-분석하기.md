


## 우리나라 남자들이 가장 많이 걸리는 4대 암은 무엇인가?

> '국립암센터_24개종 암발생률' 파일 참고

```sql
select * from cancer
where 성별 != '남녀전체' and 발생연도='1999' and 발생자수 is not null and 성별 = '남자' and 암종 != '모든암' 
order by 발생자수 desc
fetch first 4 rows only;
```
![](15-1.png)


## 우리나라 여자들이 가장 많이 걸리는 암은 무엇인가?

```sql
select * from cancer
where 성별 != '남녀전체' and 발생연도='1999' and 발생자수 is not null and 성별 = '여자' and 암종 != '모든암' 
order by 발생자수 desc
fetch first 4 rows only;
```
![](15-2.png)


## 스티븐 잡스 연설문에 가장 많이 나오는 단어는 무엇인가?

>'jobs.txt' 파일 참고
>txt파일 import시 구분자와 왼쪽 둘러싸기 모두 없음으로 체크
>![](15-7.png)

- 'speech'테이블 생성후 txt 파일 import
```sql
create table speech
(speech_text varchar2(1000));

select count(*) from speech;     --143

select * from speech;
```
![](15-3.png)

- 어절을 잘라내는 쿼리
```sql
-- 공백이 아닌 것을 여러개 검색해서 첫번째에서 두번째에 나오는 걸 출력해라.
select regexp_substr('i never graduated from college', '[^ ]+', 1, 2) word
from dual;
```
![](15-4.png)

```sql
select regexp_substr(lower(speech_text), '[^ ]+', 1, a) word
from peech, (select level a
                from dual
                connect by level <= 52);
```
![](15-5.png)

- null 값 제거하고 단어별로 그룹화하여 count
```sql
select word, count(*)
from(
    select regexp_substr(lower(speech_text), '[^ ]+', 1, a) word
        from speech, (select level a
                        from dual
                        connect by level <= 52)
    )                    
where word is not null
group by word
order by count(*) desc;
```
![](15-6.png)


## 인터넷에서 긴 영어 문장을 오라클에 넣고 그 중에 가장 많이 나오는 단어가 무엇인지 출력해라.

>kennedy.txt 파일 참고

```sql
select word, count(*)
from (
        select regexp_substr(lower(speech_text), '[^ ]+', 1, a) word
        from kennedy, (select level a
                        from dual
                        connect by level <= 500)
    )
where word is not null
group by word
order by count(*) desc;
```
![](15-8.png)


## 스티븐 잡스 연설문에는 긍정단어가 많이 나올까 부정단어가 많이 나올까?

>`감정단어` : 텍스트에 긍정, 부정의 감정을 파악할 때 사용.
>`positive.txt`, `negative.txt`파일 참고

```sql
--긍정 단어를 담을 테이블 생성
create table positive (p_text varchar2(2000));
--부정 단어를 담을 테이블 생성
create table negative (n_text varchar2(2000));
```

- 스티븐 잡스 연설문을 어절별로 나눠서 view 생성
```sql
create or replace view speech_view
as
select regexp_substr(lower(speech_text), '[^ ]+', 1, a) word
from speech, (select level a
                from dual
                connect by level <= 52);

select * from speech_view;    
```

```sql
--긍정 단어 개수
select count(word) as 긍정단어
from speech_view
where lower(word) in (select lower(p_text)
                        from positive);

--부정 단어 개수
select count(word) as 부정단어 
from speech_view
where lower(word) in (select lower(n_text) 
						  from negative);  
```


## 절도가 많이 발생한 요일을 출력해라.

>'범죄발생 요일 현화.csv'파일 참고

```sql
create table crime_day
(crime_type varchar2(50),
sun_cnt number(10),
mon_cnt number(10),
tue_cnt number(10),
wed_cnt number(10),
thu_cnt number(10),
fri_cnt number(10),
sat_cnt number(10),
unknown_cnt number(10));

select * from crime_day;
```

- unpivot 생성
```sql
create table crime_day_unpivot
as
select * 
from crime_day
unpivot(cnt for day_cnt in (sun_cnt, mon_cnt, tue_cnt, wed_cnt, thu_cnt, 
							fri_cnt, sat_cnt, unknown_cnt));
```

```sql
select *
from (
        select day_cnt, cnt, rank() over(order by cnt desc) rnk 
        from crime_day_unpivot
        where trim(crime_type) = '절도'
    )
where rnk = 1;
```
![](15-9.png)


## 방화사건이 가장 많이 발생하는 요일은 언제인가?

```sql
select *
from(
        select day_cnt, cnt, rank() over(order by cnt desc) rnk
        from crime_day_unpivot
        where trim(crime_type) = '방화'
    )
where rnk = 1;
```


## 살인이 가장 많이 발생하는 요일은 언제 인가?

```sql
select *
from(
        select day_cnt, cnt, rank() over(order by cnt desc) rnk
        from crime_day_unpivot
        where trim(crime_type) = '살인'
    )
where rnk = 1;
```


## 우리나라에서 대학 등록금이 가장 비싼 학교는?

>이미 만들어진 테이블에 데이터 import 시 `이름`을 `위치`로 바꿔주면 에러 없어짐.
>![](15-10.png)

```sql
create table university_fee
(division varchar2(20),
type varchar2(20),
university varchar2(60),
loc varchar2(40),
admission_cnt number(20),
admission_fee number(20,2),
tuition_fee number(20,2));

select count(*) from university_fee;
```
`
```sql
select *
from (
        select university,tuition_fee, 
		        rank() over(order by tuition_fee desc nulls last) 순위
        from university_fee
        )
where 순위 = 1;
```
- `nulls last` : `null`을 맨 뒤로 뺀다.

## 우리나라에서 대학 입학정원이 가장 많은 대학교는 어디인가?

```sql
select * 
from (
        select university, admission_cnt, 
            rank() over (order by admission_cnt desc nulls last) 순위
        from university_fee
     )
where 순위 = 1;
```

