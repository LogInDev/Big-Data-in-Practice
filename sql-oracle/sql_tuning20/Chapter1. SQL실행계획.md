## SQL의 실행계획이란

>SQL문을 실행하기전에 내부적으로 생성한 SQL 실행 계획.

![](img/sql_tuning/chapter1/1-1.png)

- `Rule-Based Optimizer` : Oracle이 정해놓은 규칙에서 정해 놓은 우선 순위에 따라서 실행
- `Cost-Based Optimizer` : Oracle이 정해놓은 규칙대로 실행하지 않고 상황에 따라 비용이 적게 드는 순으로 실행
⇒ 현재 Oracle의 default값은 `Cost-Based Optimizer`이여서 우리는 이것만 기억하면됨.
(요새는 대부분 `Cost-Based Optimizer`로 실행한다.)


## 예상 실행 계획이란

>SQL문을 실행하기 전에 만든 예상 계획
>`explain plan for`
>	sql문;
> 
>`select * from table(dbms_xplan.display);`


## 실제 실행 계획이란

>SQL을 실행할 때 사용했던 실행계획
>`select /*+ gather_plan_statistics */ ename,sal`
>`from emp`
>`where sal = 1300;`
>  
>`select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));`

- `/*+ */` : 힌트 - 힌트대로 실행됨
- `/* */` : 주석
- `E-Rows` : 예상 출력행
- `A-Rows` : 실제 출력행
- `A-Time` : 실행 소요 시간
- `Buffers` : 실행하는데 소요된 버퍼 수. tuning 전후에 buffers를 확인해서 성능 확인 가능
![](../img/sql_tuning/chapter1/1-2.png)


## 힌트(hint)란 무엇인가

> SQL을 실행할 때 옵티마이저로 하여금 힌트대로 실행계획을 생성해달라고 주문함.

<br>

---
# 실습

## 실행계획을 먼저 확인하자

### 예제1. 예상 실행계획 확인하는 방법

```sql
explain plan for
    select ename, sal
        from emp
        where sal = 1300;
        
select * from table(dbms_xplan.display);
```
![](1-3.png)


### 예제2. 실제 실행계획 확인하는 방법

```sql
select /*+ gather_plan_statistics */ ename, sal
    from emp
    where sal = 1300;
        
select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));
```
![](1-4.png)
- tuning 전, 후에 `Buffers`를 비교해서 성능을 확인 할 수 있음.


## 예제3. full table scan 일 때

```sql
select /*+ gather_plan_statistics */ ename, sal
    from emp
    where sal = 1300;
        
select * 
from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));
```
![](1-4.png)
- 읽을 때 실행 순서는 id 큰 숫자부터 읽으면됨. 
	- `TABLE ACCESS FULL` → `SELECT STATEMENT`
	- id에 `*`는 아래 설명(`1 - filter("SAL"=1300)`이 적용된 곳. `*`인 곳이 지금 SQL에 어느 부분인지를 설명해줌.

### 예제4. 인덱스 스캔일 때

```sql
create index emp_sal
on emp(sal);

select /*+ gather_plan_statistics */ ename, sal
    from emp
    where sal = 1300;
        
select * 
from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));
```
![](1-5.png)
⇒ `Buffers`의 갯수가 2개로 줄었다.


### 아래 SQL을 튜닝해라

```sql
select empno, ename, sal, job
from emp
where empno = 7788;
```

- 튜닝 전
```sql
select /*+ gater_plan_statistics */ empno, ename, sal, job
from emp
where empno = 7788;

select * 
from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));
```
![](1-6.png)

- 튜닝 후
```sql
--인덱스 생성
select index emp_empno on emp(empno);

select /*+ gater_plan_statistics */ empno, ename, sal, job
from emp
where empno = 7788;

select * 
from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));
```
![](1-7.png)


