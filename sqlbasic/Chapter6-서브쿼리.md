# 단일 행 서브쿼리

>서브쿼리에서 메인쿼리로 하나의 값이 리턴되는 경우. 
>사용가능한 연산자 : `=`, `!=`, `^=`, `<>`, `>`, `<`, `>=`, `<=`

```sql
select ename, sal
from emp
where sal >                                 -- 메인쿼리
(select sal from emp where ename='JONES');  -- 서브쿼리
```

```sql
--ALLEN 보다 더 늦게 입사한 사원들의 이름과 월급을 출력하세요.
select ename, sal 
from emp 
where hiredate >
(select hiredate from emp where ename='ALLEN');
```


---
# 다중 행 서브쿼리

> 서브쿼리에서 메인쿼리로 여러개의 값이 리턴되는 경우
> 사용가능한 연산자 : `in`, `not in`, `>all`, `<all`, `>any`, `<any`

## IN

```sql
select ename, sal 
from emp
where sal in 
(select sal from emp where job = 'SALESMAN');
```

```sql
select ename, job 
from emp
where job in 
(select job from emp where deptno = 20);
```


---
## NOT IN

```sql
--관리자가 아닌 사원들의 이름과 월급과 직업을 출력해라.
select ename from emp where empno not in (select mgr from emp);
```
![](6-1.png)

```sql
select mgr from emp;
```
![](6-2.png)

⇒ mgr 컬럼 값 중에 `null`이 있어서 아무것도 출력되지 않음.

`not in`은 `!=all`과 같은데 실행과정이 `and` 연산자로 비교하며 실행한다.
```
7839 and 7698 .... 이렇게 비교를 진행하는데
True and True and null => 이 경우 결과는 null이 나온다.
-> null은 알수없는 값이므로 True도 False도 아닌 null로 출력되어서 결과가 안나옴.
```

따라서, `null`값이 있을경우 `null` 값을 처리해준 뒤 혹은 제외한 뒤 비교를 진행해야한다.

```sql
select ename 
from emp 
where empno not in 
(select mgr from emp where mgr is not null);
--(select nvl(mgr, -1) from emp);
```

>❗️ **서브쿼리에서 `not in`사용시 반드시 `null`처리를 해줘야한다.**


---
## EXISTS와 NOT EXISTS

>`exists`를 사용하면 메인쿼리부터 실행됨.(보통은 서브쿼리부터 실행됨.)

```sql
select * from dept d
where exists (select * from emp e where e.deptno = d.deptno);
```
![](6-3.png)

>⇒ 실행순서
>1. 메인 쿼리 실행 후 `d.deptno`의 10번  확인
>2. 서브쿼리에 `d.deptno`에 10번을 넣고 출력물이 있는지 확인
>3. 출력물이 있으면 메인쿼리의 해당 행 출력
>	(출력내용은 중요하지 않고 출력 결과만 있으면 실행됨. 따라서 서브쿼리에 select절 내용은 중요하지않음.)
>4. 나머지 부서번호도 동일하게 동작

```sql
--부서테이블에 있는 부서번호 중에서 사원 테이블에 존재하지 않는 부서번호에 대한 모든 컬럼을 출력해라.
select * from dept d
where not exists (select * from emp d where e.deptno = d.deptno);
```


---
## HAVING절의 서브쿼리

>그룹합수로 검색조건을 줄 때는 `having`절에서 주어야함.(`where`절은 그룹함수 사용 불가)

```sql
select job, sum(sal)
from emp
group by job 
having sum(sal) > (select sum(sal) from emp where job='SALESMAN');
```

```sql
--부서번호, 부서번호별 인원수를 출력하는데 10번 부서번호의 인원수보다 더 큰것만 출력해라.
select deptno, count(*) 
from emp 
group by deptno 
having count() > (select count(ename) from emp where deptno = 10);
```


---
## FROM절의 서브쿼리

>윈도우함수(분석함수. `rank()`등)은 `select`절에서만 사용가능하고 `where`절에서는 사용 불가

```sql
select *
from (select ename, sal, rank() over (order by sal desc) rnk from emp)
where rnk = 1;
```
>⇒ 실행순서
>1. `from`절에 서브쿼리 실행 후 오라클에 메모리에 결과를 올려놓음.
>2. 메인쿼리를 실행

```sql
--직업이 SALESMAN인 사원들중에서 가장 먼저 입사한 사원의 이름과 입사일을 출력해라.
select *
from (select ename, hiredate,rank() over (order by hiredate) rnk 
	  from emp where job = 'SALESMAN')
where rnk =1;
```


---
## SELECT절의 서브쿼리

```sql
---직업이 SALESMAN인 사원들의 이름과 월급을 출력하면서 그 옆에 직업이 SALESMAN인 사원들의 최대월급과 최소월급을 출력해라.
select 
	ename, sal, 
	(select max(sal) from emp where job='SALESMAN'), 
	(select min(sal) from emp where job='SALESMAN')
from emp 
where job = 'SALESMAN';
```
![](6-4.png)

```sql
select 
	ename, sal, 
	(select avg(sal) from emp where deptno = 20) 
from emp where deptno = 20;
```


---
## 서브쿼리 사용 가능한 절

>⑤`select`      서브쿼리O
>①`from`          서브쿼리O
>②`where`        서브쿼리O
>③`group by`      X
>④`having`      서브쿼리O
>⑥`order by`  서브쿼리O

실행순서 : ①→②→③→④→⑤→⑥
