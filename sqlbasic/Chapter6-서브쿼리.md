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









