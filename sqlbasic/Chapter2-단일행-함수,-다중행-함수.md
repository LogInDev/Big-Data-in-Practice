# 함수의 종류

#### 단일행 함수
하나의 행만 입력했을 때 값을 내는것

| 함수        | 함수명         |
| ----------- | ---------- |
| 문자함수    | upper, lower, initcap, substr, instr, length, concat, lpad, rpad, itrim, rtrim, trim |       |
| 숫자함수    | round, trunc, mod                                                                    |       |
| 날짜함수    | months_between, add_months, next_day, last_day                                       |       |
| 변환함수    | to_char, to_number, to_date                                                          |       |
| 일반함수    | nvl, nvl2, case, decode                                                              |       |

#### 다중행 함수
여러 행을 입력했을 때 값을 내는 것

| 함수        | 함수명                |
| ----------- | --------------|
| 최대값                         | max   |
| 최소값                                  | min   |
| 평균값                                   | avg   |
| 합계                                       | sum   |
| 갯수                                | count |

---
# 단일행 함수
## 문자열 함수
### lower(), upper(), initcap()

```sql
select ename, lower(ename), upper(ename), initcap(ename) from emp;
```

![](./img/2-1.png)

- `lower()` : 전부 소문자로 출력
- `upper()` : 전부 대문자로 출력
- `initcap()` : 첫 글자만 대문자 나머지는 소문자로 출력


---
### substr()

> `substr(컬럼명 또는 문자열, 시작철자 인덱스, 잘라낼 갯수)`

```sql
select substr('SMITH', 2, 2) from dual;
```

![](./img/2-2.png)

```sql
-- 이름의 첫글자만 출력하고 첫글자를 소문자로 출력해라.
select lower(substr(ename, 1, 1)) from emp;
```


---
### length()

> length(컬럼명 또는 '문자열')

```sql
select ename, length(ename) from emp;
-- 이름이 5글자 이상인 이름 및 이름의 철자수 출력
select ename, length(ename) from emp where length(ename) >= 5;
```


---
### instr()

> instr(컬럼명 또는 문자열, 철자)

```sql
select instr('SMITH', 'M') from dual;
-- 이름에 S가 포함된 사원들
select ename from emp where instr(ename, 'S') > 0;
```



---
### replace()

> replace(컬럼명 또는 문자열, 변경 전 문자, 변경 후 문자)

```
regexp_ : 정규식 표현으로 regexp_ 뒤에 사용할 함수명을 입력 후 원하는 값을 출력한다.
```

```sql
-- 숫자 0 ~ 3까지는 *로 출력되게 해랴.
select ename, regexp_replace(sal, '[0-3]','*') from emp; 
```



---
### lpad(), rpad()

> `lpad(컬럼명, 출력할 전체 자릿수, 채워넣을 문자)` : 왼쪽부터 채워 넣음.
> `rpad(컬럼명, 출력할 전체 자릿수, 채워넣을 문자)` : 오른쪽부터 채워 넣음.

```sql
select ename, lpad(sal, 10, '*') from emp;
select ename, rpad(sal, 10, '*') from emp;
```



---
### trim(), rtrim(), ltrim()

>`trim(잘라낼 문자 또는 문자열 from 컬럼명 또는 문자열)` : 양쪽에서 철자를 잘라냄.
>`rtrim(컬럼명 또는 문자열, 잘라낼 문자 또는 문자열)` : 오른쪽에서 철자를 잘라냄.
>`ltrim(컬럼명 또는 문자열, 잘라낼 문자 또는 문자열)` : 왼쪽에서 철자를 잘라냄.
>⇒ <U>잘라낼 문자열을 입력하지 않으면 기본값으로 공백을 모두 잘라냄.</U>

```sql
select 'smith', ltrim('smith', 's'), rtrim('smith', 'h'), trim('s' from 'smiths') from dual;
```

![](./img/2-3.png)

```sql
insert into emp(empno, ename, sal) values(3821, 'JACK ', 3000);

select ename, sal from emp where rtrim(ename) = 'JACK';
```



---
## 숫자함수
### round()

>`round(숫자, 반올림 후 출력할 자릿수)` : 반올림해서 출력
>⇒ 숫자만 입력할 경우 출력하는 자릿수는 기본값인 0이 됨.

```sql
select 876.567, round(876.567, 2) from dual;
```
![](./img/2-4.png)

- 자릿수

| 8   | 7   | 6   | .   | 5   | 6   | 7   |
| --- | --- | --- | --- | --- | --- | --- |
| -3  | -2  | -1  | 0   | 1   | 2   | 3   |



---
### trunc()

> `trunc(숫자, 잘라낸 뒤 출력할 자릿수)` :  지정된 자릿수만큼 출력되도록 자름.
```sql
select 876.567, trunc(876.567, 1) from dual;
```



---
### mod()

>`mod(분자, 분모)` : 나눈 나머지 값을 출력.

```sql
select mod(10, 3) from dual;
-- 사원번호가 홀수인 사원의 사원번호와 이름을 출력해라.
select empno, ename from emp where mod(empno, 2) = 1;
```



---
## 날짜 함수

### month_between()

>`month_between(최근 날짜, 이전 날짜)` : 날짜와 날짜사이의 개월수를 출력해 줌(최신 날짜를 먼저써야 -값이 안나옴.)

```sql
-- 오늘 날짜 출력
select sysdate from dual;
```

![](./img/2-5.png)

```sql
select ename, round(months_between(sysdate, hiredate)) from emp;
select months_between(sysdate, '1993/08/11')from dual;
```


---
### add_months()

>`add_months(기준일자, 개월수)` : 특정 날짜를 구하는 함수

```sql
-- 2019년 5월 1일부터 100달 뒤의 날짜
select add_months('2019/5/1', 100) from dual;
```

![](./img/2-6.png)

```sql
-- 오늘부터 100달 뒤의 날짜
select add_months(sysdate, 100) from dual;
```



---
### next_day()

> `next_day(기준 날짜, 구하고 싶은 요일)` : 기준 날짜로부터 돌아오는 요일의 날짜 출력. (요일은 한글, 숫자 다 가능)
> ⇒ 1 ~ 7 : 일 ~ 토

```sql
select next_day('2021/5/5', '월요일') from dual;
-- 오늘부터 돌아올 금요일의 날짜
select next_day(sysdate, 6) from dual;
```



---
### last_day()

>`last_day(기준 날짜)` : 해당하는 달의 마지막 날짜를 출력.

```sql
select last_day('2021/5/5') from dual;
```
![](./img/2-7.png)

```sql
-- 오늘부터 이번달 마지막 일까지 남은 일수
select last_day(sysdate) - sysdate from dual;
```


---
### to_char()

>`to_char(날짜 컬럼명, 날짜 포멧)` : 문자형으로 데이터 유형 변환.(날짜형 → 문자형, 숫자형 → 문자형)

| 출력 데이터 | 날짜 포멧              |
| ------ | ------------------ |
| 년도     | RRRR, YYYY, RR, YY |
| 월      | MON, MM            |
| 일      | DD                 |
| 요일     | DAY, DY            |
| $      | $999,999           |
| ₩      | L999,999           |

```sql
select ename, to_char(hiredate, 'day'), 
	to_char(sal, '999,999') 
from emp where ename = 'SCOTT';
```
![](2-8.png)

```sql
select ename, hiredate, to_char(hiredate, 'RRRR'), 
		to_char(hiredate, 'MON'),to_char(hiredate, 'DD'), 
		to_char(hiredate, 'day'), to_char(hiredate, 'dy')
from emp where ename = 'SCOTT';
```
![](./img/2-9.png)

```sql
-- 태어난 날짜의 요일을 구해라 - to_date()사용안하면 에러남.
select to_char(to_date('1993/8/11', 'RRRR/MM/DD'), 'day') from dual;
```


---
### to_date

> `to_date(날짜, 포멧)` : 날짜를 해당 포멧의 date타입으로 바꿔줌.

```sql

select ename, hiredate from emp where hiredate = to_date('81/11/17', 'rr/mm/dd');
```


---
### 현재 세션 날짜 

- 현재 세션의 날짜 형식을 확인하는 방법(세션 : 내가 접속한 'SCOTT'의 창)

```sql
select * from nls_session_parameters;
```
![](./img/2-10.png)

- 현재 세션의 날짜 형식을 DD/MM/RR 로 변경

```sql
alter session set nls_date_format='DD/MM/RR';
```
![](./img/2-11.png)


---
## 암시적 형 변환

>Oracle DB에서 조건절의 데이터를 확인 후 자동으로 형 변환을 시행한다.
>`숫자` > `문자`  ← 문자보다 숫자가 우선순위가 높다.

```sql
-- 실행 계획 살펴보기
explain plan for
select ename, sal from emp where sal = '3000';
-- '3000'문자를 숫자로 바꿔서 실행

select * from table(dbms_xplan.display);
```
![](./img/2-12.png)

```sql
select ename, sal from emp where sal like '30%';
```
![](./img/2-13.png)

⇒ sal 컬럼을 문자로 바꿔서 실행시킴.

- 이런식으로 암시적 형 변환이 되는게 꼭 좋은 것만은 아님.
→ 암시적 형 변환이 되면서 전체 sal을 문자로 바꿔야 하는 상황이 발생하므로 
⇒sal이라는 컬럼에 `like`를 자주 쓰게 된다면 처음부터 문자형 컬럼으로 만드는 것이 더 낫다.


---
## 일반함수
### nvl()

> `nvl(컬럼명, NULL을 대체할 값)` : NULL 값 대신 대체 값 출력. 컬럼과 대체값의 데이터 유형이 같아야함.

- 데이터에 `null`값이 존재하는 경우 연산자를 이용한 결과를 출력할 때 `null`값으로 출력된다. → `null`값을 연산하는 경우 0으로 변경해서 연산을 해야 연산됨.

```sql
select ename, sal,  comm, sal+comm from emp;
```
![](./img/2-14.png)

```sql
select ename, sal,  comm, sal+nvl(comm,0) from emp;
```
![](./img/2-15.png)

```sql
--comm 컬럼을 출력하는데 null인 경우 'no comm'으로 출력되게 해라
select ename, nvl(comm, 'no comm') from emp;
```
![](/img/2-16.png)

⇒ comm컬럼은 숫자 타입인데 대체 값으로 문자형을 넣어서 에러가 남.

```sql
select ename, comm, nvl(to_char(comm), 'no comm') from emp;
```
![](./img/2-17.png)


---
### decode()

> `decode(컬럼명, 값1, 값1 대체값, 값2, 값2 대체값,..., else 값)` : if문을 sql로 구현한 것. code가 없다(de - 디카페인의 디). 동등비교(`=`)만 가능

```sql
-- 이름, 부서번호, 보너스를 출력하는데 보너스가 부서번호가 10이면 300, 20이면 400 나머지 부서번호는 0을 출력해라
select ename, deptno, 
    decode(deptno, 10, 300, 
				   20, 400, 0 ) as 보너스 from emp;
```
![](./img/2-18.png)


---
### case()

>`case when 컬럼명1 조건1 then 변경값1`
   	  `when 컬럼명2  조건2 then 변경값2`
   	    `... else 나머지 변경값`
   	    `end` : if문을 sql로 구현.

```sql
select ename, job, sal, 
    case when sal >= 3000 then 500
         when sal >= 2000 then 300
         when sal >= 1000 then 200
         else 0 end as 보너스
from emp where job in ('SALESMAN', 'ANALYST');
```


<br>

---
# 다중행 함수(그룹함수)

- `null`값을 무시한다.
## max()

> `max(컬럼명)` : 컬럼중 제일 큰 수 출력.

```sql
select max(sal) from emp;
```

```sql
select job, max(sal) from emp where job = 'SALESMAN';
```
![](./img/2-19.png)

> ※ 그룹함수 연산을 통해 단순히 하나의 값만 출력하려 해도 단일 결과가 나오기 위해서는 그룹으로 묶어야 한다.
> ⇒ 실행 순서
	③ `select job, max(sal)`  
	①`from emp`
	②`where job = 'SALESMAN';
	→ ①,②에서 가져온 여러 행에서 max()는 하나의 행만 출력하려하고 job은 여러행 모두를 출력하려고 해서 에러가 남!
> `group by`로 묶어줘야함. <U>그룹화하여 단일행으로 만들어줌</U>
	④`select job, max(sal)`  
	①`from emp`
	②`where job = 'SALESMAN'
	③`group by job;`


---
## min()

>`min(컬럼명)` : 컬럼중 제일 작은값 출력

```sql
select min(sal) from emp where job = 'SALESMAN';
-- 그룹별로 최소값 구하기
select deptno, min(sal) from emp group by deptno;
```
![](./img/2-20.png)


---
## avg()

>`avg(컬럼명)` : 컬럼의 평균 값을 출력.

```sql
select round(avg(sal)) from emp;
select job, avg(sal) from emp group by job order by 2 desc;
select job, avg(sal) as 평균 from emp group by job order by 평균 desc;
```

> ※ 실행순서
> 	③`select job, round(avg(sal))
> 	①`from emp`
> 	②`group by job`
> 	④`order by 2 desc;`
> ⇒<U>`order by`는 항상 마지막에 실행됨. 따라서 `order by`에서는 `alias`사용이 가능함.</U>

```sql
-- 부서번호, 부서번호별 평균월급을 출력하는데 부서번호별 평균월급을 출력할 때에 천단위 표시해라.
select deptno, to_char(avg(sal), '999,999') from emp group by deptno; 
```

- `null`이 있는 경우 `null`값을 무시하고 평균을 내서 정확한 전체평균은 아니다.
```sql
-- null을 제외한 값의 합을 null이 아닌 값의 갯수로 나눔
select avg(comm) from emp;
```
![](./img/2-21.png)

```sql
select avg(nvl(comm,0)) from emp;
```
![](./img/2-22.png)


---
## sum()

>`sum(컬럼명)` : 컬럼의 총합을 출력.

```sql
select deptno, sum(sal) from emp group by deptno;
```


---
## group by ~ having ~

> `group by 컬럼명1,컬럼명2, ... having 조건` : 조건에 맞는 그룹만 출력. (where절은 group 함수에 적용되지 않음)

```sql
-- 직업과 지업별 토탈월급을 출력하는데 직업별 토탈월급이 6000이상인 것만 출력해라
select job, sum(sal) from emp group by job having sum(sal) >= 6000;
```


---
## 그룹함수 실행순서

⑤`select 컬럼명`
①`from 테이블명`
②`where 검색조건`
③`group by 그룹핑할 컬럼명`
④`having 그룹함수에 적용할 검색조건`
⑥`order by 정렬할 컬럼명`
⇒`from`부터 `order by` 전까지 실행 후 `select` 실행. 가장 마지막 실행은 `order by`

---
## count()

>`count(컬럼명)` : 컬럼의 출력 행 갯수를 출력. 그룹함수여서 `null`값은 무시. 포함시키지 않음.

```sql
select count(empno) from emp;
select count(*) from emp;
```

⇒ `count()`의 괄호 안에 컬럼명을 작성하면 해당 컬럼만 갯수를 세지만, `*`를 사용하는 경우 행 전체를 하나로 갯수를 센다. 따라서 `null`값의 영향을 안받으려면 `*`를 사용하는 게 좋다.

```sql
--부서번호와 부서번호 별 인원수를 출력해라.
select deptno, count(deptno) from emp  group by deptno;
```
```sql
--직업과 직업별 인원수를 출력하는데 직업이 salesman은 제외하고 출력하고 직업별 인원수가 3명 이상인 것만 출력하세요.
select job, count(job) from emp where job not in ('SALESMAN') group by job having count(job) >= 3;
```
⇒  `having`절에 salesman을 제외하는 조건을 넣어도 에러는 나지 않지만, 성능이 떨어지므로 where절로 필터링 할 수 있는건 where절에 적용하는게 성능이 더 좋다.


