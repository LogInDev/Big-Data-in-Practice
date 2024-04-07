## 합집합 - UNION ALL

> 위아래 쿼리를 붙여준다. 합치는 쿼리의 결과 컬럼 갯수와 타입이 같아야 한다.
![](5-1.png)

```sql
select deptno, sum(sal) 
from emp 
group by deptno
union all
select to_number(null), sum(sal)   
-- 출력할 컬럼은 없지만 컬럼 갯수는 맞춰야하므로 null 사용
from emp
order by deptno ascs;
```
⇒ 출력할 컬럼이 없을 때 갯수를 맞춰주기 위해 `null` 사용. `null`을 사용하면 자동으로 오라클에서 타입을 맞춰주지만, 직접 타입을 지정해주면 훨씬 더 성능이 좋아진다.

> `union all`에서 `order by`사용시 맨 아래줄에만 사용가능함.

```sql
select job, sum(sal) 
from emp 
group by job
union all
select to_char(null) as job, sum(sal) 
from emp
order by job asc;
```


---
## 합집합 - UNION

>위 아래 쿼리를 붙여준다.
![](5-1.png)

```sql
select deptno, sum(sal) 
from emp 
group by deptno
union
select to_number(null) as deptno, sum(sal) 
from emp;
```

```sql
select job, sum(sal) 
from emp 
group by job
union 
select to_char(null) as job, sum(sal) 
from emp
order by job;
```

```sql
--입사한 년도, 이사한 년도별 토탈월급을 출력하는데 맨 아래에 전체 토탈월급이 출력되게 해라(입사한 년도는 정렬이 되어서 출력되게 해라)
select to_char(hiredate, 'RRRR') as hiredate, sum(sal) 
from emp 
group by to_char(hiredate, 'RRRR')
union 
select to_char(null), sum(sal) 
from emp 
order by hiredate;
```


---
## 교집합 - INTERSECT

> 위 아래 쿼리의 공통된 데이터를 출력
![](5-2.png)

```sql
select ename, sal, job, deptno
from emp
where deptno in (10, 20)
intersect
select ename, sal, job, deptno
from emp
where deptno in (20, 30);
```

```sql
select deptno from emp
intersect
select deptno from dept;
```


---
## 차집합 - MINUS

> A - B의 결과를 출력
![](5-3.png)

```sql
select ename, sal, job, deptno
from emp
where deptno in (10, 20)
minus
select ename, sal, job, deptno
from emp
where deptno in (20, 30);
```

```sql
select deptno from dept
minus
select deptno from emp;
```

