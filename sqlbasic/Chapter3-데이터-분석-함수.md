## rank()

>`rank() over(order by 컬럼명 desc)` : `over`뒤에 `rank()`를 적용할 수 있는 구문을 작성.
>									동일한 등수도 포함해서 순위를 매김.
>(`over()`에 괄호안에 있는 내용을 확장해서 순위를 출력해라. - `over` : '확장하다')

```sql
--직업이 ANALYST, MANAGER인 사원들의 이름, 직업, 월급과 월급에 대한 순위를 출력해라.
select ename, job, sal, 
	rank() over (order by sal desc) 순위 
--wherer 조건에 맞는 데이터 중 월급이 높은 순서대로 정렬해서 순위를 부여해라.
from emp where job in ('ANALYST', 'MANAGER');
```

```sql
--부서번호가 20인 직원의 이름과 직업, 급여와 순위를 출력해라
select ename, deptno, sal, rank() over (order by sal desc) 순위 from emp where deptno = 20;
```
![](./img/chapter3/3-1.png)
⇒ 동일한 순위가 있을 경우 순위에 포함해서 매김(1등이 2명이여서 다음 등수는 2등이 아닌 3등으로 출력)

---
## dense_rank()

>`dense_rank() over (order by 컬럼명 desc)` :  동일한 등수를 순위에 포함시키지 않고 매김.
>`dense_rank() over(partition by 컬럼 order by 컬럼)` : `partition by`로 그룹을 지어서 순위를 매김 
>`dense_rank(기준 값) within group (order by 컬럼)` : `group()`안에서 기준 값이 몇위인지 출력. `within group` 뒤에 `rank`를 적용한 컬럼에서 기준값의 순위를 출력.

```sql
select ename, job, sal, 
	dense_rank() over( order by sal desc) 순위1, 
	rank() over(order by sal desc) 순위2 
from emp where job in ('ANALYST', 'MANAGER');
```
![](./img/chapter3/3-2.png)

```sql
--직업, 이름, 월급 순위를 출력하는데 순위가 직업별로 각각 월급이 높은 사원순으로 순위를 부여해라.
select job, ename, sal, 
	dense_rank() over(partition by job order by sal desc) 순위 
from emp;
```

```sql
--월급이 2975인 직원의 순위를 출력해라
select dense_rank(2975) within group (order by sal desc) 순위 from emp;
```


---
## ntile()

>`ntile(등급을 나눌 수) over(order by 컬럼 desc)` : `over()`로 정렬한 데이터에서 지정한 수 만큼 등급을 나누어 출력. 

```sql
--직업이 ANALYST, MANAGER, CLERK인 사원들의 이름과 직업과 월급과 등급을 출력하는데 등급을 4등급으로 나눠서 출력해라.
select ename, job, sal, 
	ntile(4) over(order by sal desc) 등급 
from emp where job in ('ANALYST', 'MANAGER', 'CLERK');
```
![](./img/chapter3/3-3.png)

```sql
--이름, 입사일, 입사한 사원순으로 등급을 나누는데 등급을 5등급으로 나눠서 출력해라
select ename, hiredate, ntile(5) over(order by hiredate) 등급 from emp;
```


---
## cume_dist()

>`cume_dist() over (order by 기준 컬럼 desc)` : `over()` 를 기준으로 순위에 대한 비율을 출력.

```sql
--이름과 월급과 순위와 자신의 월급의 순위에 대한 비율을 출력해라.
select ename, sal, 
	dense_rank() over (order by sal desc) 순위, 
	round(cume_dist() over (order by sal desc), 2) 비율
from emp;
```
![](./img/chapter3/3-4.png)

```sql
--부서번호, 이름과 월급과 월급의 순위에 대한 비율을 출력해라. 순위 비율이 부서번호별로 각각 출력되게 해라.
select deptno, ename, sal, 
	round(
		cume_dist() over (partition by deptno order by sal desc)
	, 2) 비율 
from emp;
```
![](./img/chapter3/3-5.png)


---
## listagg()

>`listagg(컬럼, 구분기호) within group (order by 컬럼) ~ group by 컬럼`  : `within group`으로 데이터 그룹을 지정하고 나열할 값의 컬럼과 구분기호를 `listagg()`에 지정한 뒤 `group by`를 꼭 사용하여 그룹을 묶어줘야한다.

```sql
--부서번호를 출력하고 해당 부서번호별로 속한 사원들의 이름을 가로로 출력해라
select deptno, 
	listagg(ename, ',') within group (order by ename) 
from emp 
group by deptno;
```
![](./img/chapter3/3-6.png)

```sql
--직업, 직업별 속한 사원들의 이름을 가로로 출력하는데 가로로 출력될 때에 월급이 높은 사원부터 출력되게 해라.
select job, 
	listagg(ename, ' | ') within group (order by sal desc) 
from emp 
group by job;
```
![](./img/chapter3/3-7.png)


---
## lag(), lead()

>`lag(컬럼명, 행번호) over (order by 기준 컬럼)` : 지정한 행번호만큼의 이전행을 출력.
>`lead(컬럼명, 행번호) over (order by 기준 컬럼)` : 지정한 행번호만큼의 다음행을 출력.
>(행 번호를 생략하면 기본 값이 1로 됨.)

```sql
--직업이 ANALYST, MANAGER인 사원들의 사원번호와 이름과 월급을 출력하는데 다음과 같이 월급의 그 전행과 다음행을 출력해라.
select empno, ename, sal, 
	lag(sal, 1) over (order by sal, 1) 전행, 
	lead(sal) over (order by sal, 1) 다음행
from emp 
where job in ('ANALYST', 'MANAGER');
```

```sql
--이름과 입사일을 출력하고, 전 입사한 직원과의 입사일 간격을 출력해라.
select ename, hiredate, 
	hiredate - lag(hiredate, 1) over (order by hiredate) 
from emp;
```


---
## 행과 열을 바꿔서 출력하기

### sum() + decode()

```sql
--부서별 월급의 합을 가로로 출력해라.
--①
select deptno, sum(sal) from emp group by deptno;
--②
select 
	sum(decode(deptno, 10, sal, 0)) as "10",
    sum(decode(deptno, 20, sal, 0)) as "20",
    sum(decode(deptno, 30, sal, 0)) as "30"
from emp;
--③
select 
	sum(decode(deptno, 10, sal, null)) as "10",
    sum(decode(deptno, 20, sal, null)) as "20",
    sum(decode(deptno, 30, sal, null)) as "30"
from emp;
```
①
![](./img/chapter3/3-8.png)
②③ 
![](./img/chapter3/3-9.png)

⇒<U>그룹 함수는 'null 값' 을 무시하기 때문에 ②번 쿼리보다는 ③번 쿼리가 더 성능이 좋음. </U>

>※ 숫자를 컬럼명으로 출력할 때는 `""` 사용.

```sql
--직업과 직업별 급여의 합을 가로로 출력해라.
select 
    sum(decode(job, 'PRESIDENT', sal, null)) as PRESIDENT,
    sum(decode(job, 'MANAGER', sal, null)) as MANAGER,
    sum(decode(job, 'SALESMAN', sal)) as SALESMAN,
    sum(decode(job, 'CLERK', sal)) as CLERK,
    sum(decode(job, 'ANALYST', sal)) as ANALYST
from emp;
```
![](./img/chapter3/3-10.png)

>※ `decode()`에서 대체값 생략 시 `null`로 출력

<br>

### pivot()

>`pivot(그룹함수 for 기준 컬럼 in (데이터1, 데이터2, ...))` : 전체 컬럼이 아닌 필요한 컬럼만 from in line view 쿼리에 넣어줘야함.

```sql
select * 
from (select deptno, sal from emp) -- pivot()에 필요한 컬럼만 출력할 것.
pivot(sum(sal) for deptno in (10, 20, 30));
```
![](3-11.png)

> `pivot()` 다음에 `select`절이 실행되므로 `pivot()`의 결과를 출력할 수 있도록 `select`절을 작성해야한다.

```sql
select *
from (select job, sal from emp)
pivot(sum(sal) for job 
		  in ('PRESIDENT', 'MANAGER', 'SALESMAN', 'CLERK', 'ANALYST'));
```
![](3-12.png)

- `''`없애기
```sql
select *
from (select job, sal from emp)
pivot(sum(sal) for job 
		  in ('PRESIDENT' as "PRESIDENT", 'MANAGER' as "MANAGER", 'SALESMAN' as "SALESMAN", 'CLERK' as "CLERK", 'ANALYST' as "ANALYST"));
```
![](3-13.png)


---
## 열을 행으로 출력하기

### unpivot()

> `unpivot( 출력할 컬럼명 for 데이터가 출력될 컬럼명 in (데이터1, 데이터2, ...))` 
> 	: `in()`안에 데이터에 `'`를 붙이면 안됨.

```sql
select *
from order2;
```
![](3-14.png)

```sql
select *
from order2
unpivot (건수 for 아이템 in (BICYCLE, CAMERA, NOTEBOOK));
```
![](3-15.png)


```sql
select * from crime_cause;
```
![](3-16.png)

```sql
select * from crime_cause;
unpivot (건수 for 범죄원인 
					IN (생계형, 유흥, 도박, 허영심, 복수, 해고, 징벌, 가정불화, 
						호기심, 유혹, 사고, 불만, 부주의, 기타))
where crime_type = '방화' order by 건수 desc;
```
![](3-17.png)



---
## 누적 데이터 출력하기 - sum() over()

>`sum(컬럼명) over(order by 기준 컬럼)` : 기준 컬럼대로 정렬된 데이터 기준으로 누적합을 구함.
>= `sum(컬럼명) over(order by 기준 컬럼 rows between unbounded preceding and current row)` 
>: 제일 첫번째부터 현재 행까지의 누적치(`rows ~ currentrow`까지 생략가능함)
>	- `unbounded preceding` : 기준 컬럼으로 정렬된 데이터 중 제일 첫번째 행을 가리킴.
>	- `current row` : 현재 행을 가리킴.

```sql
--직업이 ANALYST, MANAGER인 사원들의 사원번호, 사원이름, 월급, 월급에 대한 누적치를 출력해라.
select empno, ename, sal, 
	sum(sal) over(order by empno) 누적합 
from emp 
where job in ('ANALYST', 'MANAGER');
```

```sql
--부서번호가 20번인 사원들의 사원이름, 월급, 월급에 대한 누적치가 출력되게 해라.
select ename, sal, 
	sum(sal) over(order by ename rows 
					between unbounded preceding and current row) 누적치 
from emp 
where deptno = 20;
```


---
## ratio_to_report()

>`ratio_to_report(컬럼명) over()` : 비율 출력 

```sql
select empno, ename, sal, 
	round(ratio_to_report(sal) over (),2) 비율
from emp
where deptno = 20;
```


---
## rollup()

>`group by rollup(기준 컬럼)` : 전체에 그룹함수 적용한 결과를 맨 아래에 출력

```sql
--직업별 토탈월급을 출력하는데 맨 아래에 다음과 같이 전체 월급의 합이 출력되게 해라.
select job, sum(sal) 
from emp
group by rollup(job)
```
![](3-18.png)

```sql
--부서번호, 부서번호별 월급합을 출력하는데 맨 아래에 전체 월급합이 출력되게 해라.
select deptno, sum(sal) 
from emp 
group by rollup(deptno);
```


---
## cube()

>`group by cube(기준 컬럼)` : 전체에 그룹함수 적용 결과를 맨 위에 출력.

```sql
select job, sum(sal) 
from emp 
group by cube(job);
```
![](3-19.png)

```sql
--입사한 년도(4자리), 입사한 년도별 월급합을 출력하는데 맨 위에 사원 테이블의 전체 토탈 월급이 출력되게 해라.
select to_char(hiredate, 'RRRR'), sum(sal)
from emp
group by cube(to_char(hiredate, 'RRRR'));
```
![](3-20.png)


---
## grouping sets()

>`group by grouping sets((기준 컬럼1), (기준 컬럼2), ...)` :  그룹함수의 적용 결과를 기준 컬럼에 데이터별로 그룹 지어서 출력. 전체에 그룹함수가 적용된 결과도 출력하려면 `()`추가.

```sql
select deptno, job, sum(sal)
from emp
group by grouping sets(deptno, job,());
```
![](3-21.png)

>※`기준 컬럼`을 하나씩 나열하여 결과를 볼 경우에는 `()`를 생략해도 되지만, `()`를 붙여주는 습관을 들이는게 좋음.
⇒`grouping sets`안에서 `()`의 역할은 기준 컬럼들이 동시에 묶인 결과를 출력할 지 단일 결과를 출력할 지를 결정하는 중요한 역할을 해주기 때문

```sql
select deptno, sum(sal)
from emp
group by grouping sets((deptno), ());

select deptno, sum(sal)
from emp
group by rollup(deptno);
```
![](3-22.png)

>※ 두 쿼리는 똑같은 결과를 출력하지만 `rollup()`보다는 `grouping sets()`가 출력결과를 예상하기 쉬워서 더 많이 쓰인다.

```sql
--입사한 년도(4자리), 입사한 년도(4자리)별 월급합과 직업, 직업별 월급합을 같이 출력해라.
select to_char(hiredate, 'RRRR'), job, sum(sal)
from emp
group by grouping sets((to_char(hiredate, 'RRRR')), (job));
```
![](3-23.png)


---
## row_number()

>`row_number() over (order by 기준컬럼)` : 기준 컬럼으로 정렬되어 출력되는 순서대로 번호를 매김.

```sql
select empno, ename, sal, rank() over(order by sal desc) rank,
    dense_rank() over(order by sal desc) dense_rank,
    row_number() over(order by sal desc)
from emp
where deptno = 20; 
```
![](3-24.png)

```sql
select ename, sal, row_number() over (order by empno)
from emp
where sal between 1000 and 3000;
```


---
## rownum

>`rownum` : 출력되는 결과행의 갯수를 상위부터 제한해서 출력.숨겨진 컬럼으로 어떤 테이블이든 다 있음. 항상 1번부터 출력됨.
>	- `~ where rownum = 1` : 첫번째 행만 등호 가능. 나머지 숫자는 등호는 불가하고 부등호를 사용해야함.(첫번째 행부터 출력되어야 하므로)
>	- `select 절`에서 `rownum` 생략 가능

```sql
select rownum, empno, ename, job, sal 
from emp
where rownum <= 5;
```

```sql
SELECT ENAME, SAL, JOB
FROM EMP
WHERE JOB = 'SALESMAN'
and rownum <= 2;
```


---
## 정렬 기준 상위 몇 개만 출력 - fetch first _ rows only


```sql
--사원번호, 이름, 직업, 급여를 월급이 높은 순서대로 상위 4개만 출력해라.
select empno, ename, job, sal
from emp
order by sal desc fetch first 4 rows only;
```
![](3-25.png)

```sql
--최근에 입사한 사원순으로 이름, 입사일과 월급을 출력하는데 상위 5명만 출력해라.
select ename, hiredate, sal
from emp
order by hiredate desc fetch first 5 rows only;
```

