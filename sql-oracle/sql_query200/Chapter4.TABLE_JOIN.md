# Oracle JOIN
## EQUI JOIN

> join시 테이블의 공통된 컬럼이 있는 경우 공통된 컬럼을 조건으로 join

```sql
select ename, loc, e.deptno 
from emp e, dept d
where e.deptno = d.deptno;

select e.ename, e.job, d.loc 
from emp e, dept d 
where e.deptno = d.deptno and e.job = 'SALESMAN';

select e.ename, e.sal, d.loc 
from emp e, dept d 
where e.deptno = d.deptno and d.loc = 'DALLAS'; 
```
⇒ 테이블에 단독으로 있는 컬럼인  `ename`, `loc`은 앞에 테이블 명을 쓰지 않아도 에러는 나지 않지만, **JOIN시 컬럼 앞에 테이블명을 써주는게 성능에 더 좋다.**(Oracle에서 해당 컬럼이 어디에 있는지 찾지 않아도 되므로)

---
## NON EQUI JOIN

> 서로 공통된 컬럼이 없는 테이블끼리 join을 하는 경우 비슷한 컬럼을 조건으로 join

```sql
select e.ename, e.sal, s.grade 
from emp e, salgrade s
where e.sal between s.losal and s.hisal;
```
![](4-1.png)

```sql
--급여등급이 4등급인 사원들의 이름과 월급을 출력하는데 월급이 높은 사원부터 출력해라.
select e.ename, e.sal 
from emp e, salgrade s 
where e.sal between s.losal and s.hisal
and s.grade = 4 
order by e.sal desc;
```


---
## OUTER JOIN

> 테이블끼리 공통된 데이터 이외의 데이터도 출력하고 싶을 때 outer join.
> equi join처럼 작성하고 join 조건에서 데이터가 더 없는 쪽에 `(+)`를 붙여주면 됨.

```sql
select e.ename, d.loc from emp e, dept d where e.deptno (+) = d.deptno;
```
![](4-2.png)

```sql
select e.ename, d.loc 
from emp e, dept d 
where e.deptno (+) = d.deptno;
```


---
## SELF JOIN

>자기 자신과 join

```sql
select 사원.ename as 사원, 사원.job as 직업, 
		관리자.ename as 관리자, 관리자.job as 직업 
		-- 같은 이름의 컬럼이 있으면 알아서 바꿔서 출력해줌.
from emp 사원, emp 관리자 
where 사원.mgr = 관리자.empno;
```
![](4-3.png)

```sql
select 사원.ename as 사원, 사원.job as 직업, 
		관리자.ename as 관리자, 관리자.job as 직업 
from emp 사원, emp 관리자 
where 사원.mgr = 관리자.empno and 관리자.sal < 사원.sal;
```


---
# 1999 ANSI JOIN

- DBMS 자체의 특수성 때문에 SQL의 사용법이 조금씩 다른데 **미국 국립 표준 협회(American National Standards Institute, ANSI)** 에서 SQL에 대한 보편적인 문법을 제시한 것이 **`ANSI Query(SQL)`** 이다.

## ON절

> `on (테이블1.공통컬럼 = 테이블2.공통컬럼)` : 조인 조건을 작성

```sql
select e.ename, e.sal, d.loc 
from emp e join dept d 
on (e.deptno = d.deptno)   -- 조인조건
where e.job='SALESMAN';    -- 검색조건
```

```sql
select e.ename, e.sal, d.loc 
from emp e join dept d 
on (e.deptno = d.deptno) 
where e.sal between 1000 and 3000;
```


---
## USING절

> `using(공통컬럼)` : 조인 조건인 컬럼만 작성

```sql
select e.ename, e.job, e.sal, d.loc 
from emp e join dept d
using (deptno)            -- 조인조건
where e.job='SALESMAN';   -- 검색조건
```

```sql
select e.ename, e.sal, d.loc 
from emp e join dept d 
using(deptno) 
where d.loc='DALLAS';
```

>**단, 공통되는 컬럼(join의 기준이 되는 컬럼)을 where절에서 사용시 테이블명을 작성하면 에러남.

```sql
select e.ename, e.sal, d.loc 
from emp e join dept d 
using(deptno) 
where detno = 10;    -- 테이블명 작성 없이 컬럼만 작성
```

---
## NATURAL JOIN

> `natural join` 키워드만 작성하면 안아서 공통된 컬럼을 찾아서 조인조건을 걸어줌.

```sql
select e.ename as 이름, e.job as 직업, e.sal as 월급, d.loc as 부서위치
from emp e natural join dept d
where e.job = 'SALESMAN';
```

>**단, 공통되는 컬럼(join의 기준이 되는 컬럼)을 where절에서 사용시 테이블명을 작성하면 에러남.

```sql
select e.ename, e.job, e.sal, d.loc 
from emp e natural join dept d 
where e.job = 'SALESMAN' and deptno = 30;
```


---
## OUTER JOIN

> `right outer join` : 데이터가 더 많은 테이블이 오른쪽에 있을 때 사용
> `left outer join` : 데이터가 더 많은 테이블이 왼쪽에 있을 때 사용

```sql
select e.ename, e.job, e.sal, d.loc 
from emp e right outer join dept d
on (e.deptno = d.deptno);
```

```sql
select e.ename, e.job, e.sal, d.loc 
from emp e left outer join dept d
on (e.deptno = d.deptno);
```


---
## FULL OUTER JOIN

> Oracle JOIN문법으로는 출력할 수 없는 결과

```sql
select e.ename, e.job, e.sal, d.loc 
from emp e full outer join dept d 
on (e.deptno = d.deptno);
```

```sql
--직업이 ANALYST이거나 부서위치가 BOSTON인 사원들의 이름과 직업과 월급과 부서위치를 출력하는데 full outer 조인을 사용하여 출력해라.
select e.ename, e.job, e.sal, d.loc 
from emp e full outer join dept d 
on (e.deptno = d.deptno) 
where e.job = 'ANALYST' or d.loc = 'BOSTON';
```
![](4-4.png)

