
## 컬럼명 변경해서 출력

```sql
select 
	empno as 사원번호,
	ename as 사원이름,
	sal as "Salary"
from emp;
```
- 따로 `""` 적용할 필요는 없지만 대소문자 구분이 필요할 경우 
`""`가 필요함.(`""` 없으면 그냥 대문자로만 출력됨)

<br>

---
## 연결 연산자(||)

- 컬럼끼리 붙여서 출력가능
```sql
select ename || sal from emp;
```
![[img/sql_tuning/chapter1/1-1.png||110]]


- `'`를 사용하여 문장으로 출력가능
```sql
select ename||'의 직업은 '||job||'입니다.' from emp;
```
![[1-2.png||290]]

<br>

---
## DISTINCT() 중복제거
```sql
select DISTINCT(job) from emp;
```

<br>

---
## 오름차순(ASC), 내림차순(DESC) 출력
```sql
select ename, sal 
from emp 
order by sal asc;
```

<br>

---
## 오라클 연산자 종류 3가지

| 종류     | 연산자                         |
| ------ | --------------------------- |
| 산술 연산자 | * / + -                     |
| 비교연산자  | >, <, >=, <=, =, !=, <>, ^= |
| 논리 연산자 | and, or, not                |

```sql
select ename, sal*12 from emp where sal*12 >= 36000; (O)
```

```sql
select ename, sal*12 as 연봉 from emp where 연봉 >= 36000;(X)
-- ORA-00904: "연봉": 부적합한 식별자 
```

### 조건절에 alias를 사용하면 에러가 나는 이유
![[1-1.excalidraw]]

- 코딩 순서 : `select` → `from` → `where`
- 실행 순서 : `from` → `where` → `select`

<br>

---
## 기타 비교연산자 4가지

| 맞는 것 검색할 때        | 아닌거 검색할 때             |
| ----------------- | --------------------- |
| between .. and .. | not between .. and .. |
| like              | not like              |
| in                | not in                |
| is null           | is not null           |

<br>

---
## null 값

1. 데이터가 없는 상태
2. 알 수 없는 값 → `null`과 `0`은 다름.(`0`은 `0`인 것을 알 수 있으므로)

따라서 `null` 값과 비교 연산자는 연산이 불가능하다.
```sql
select ename, comm from emp where comm = null;(X)
-- 문법적으로는 가능하지만 연산이 되지 않아 결과가 없음
```

```sql
select ename, comm from emp where comm is null;(O)
```

