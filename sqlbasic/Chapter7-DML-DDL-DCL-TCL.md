# DML

- DML(Data Manipulation Language) : `insert`, `update`, `delete`, `merge`

## INSERT

> `insert into 테이블명 (컬럼1, 컬럼2, ...)`  -- 전체 컬럼값을 추가할 때는 컬럼 특정 생략가능
> `values (값1, 값2, ...);`

```sql
insert into emp (empno, ename, sal, job, hiredate)
values (2812, 'JACK', 3500, 'ANALYST', to_date('2019-06-05', 'RRRR-MM-DD'));
```

```sql
insert into dept
values(50, 'RESEARCH', 'SEOUL');
```


---
## COMMIT, ROLLBACK

> `commit;` : `insert`, `update`, `delete`를 영구히 저장할 경우
> `rollback;` : `insert`, `update`, `delete`를 취소할 경우(`commit;`한 경우에는 취소 불가능)


---
## UPDATE

>`update 테이블명`
>`set 변경 컬럼 = 변경 값`
>`where 적용할 row 조건;`

```sql
update emp 
set sal = 3200 
where ename = 'SCOTT';
```

```sql
--직업이 SALESMAN인 사원들의 커미션을 7000으로 수정해라.
update emp s
et comm=7000 
where job = 'SALESMAN';
```


---
## 데이터 삭제하기 - DELETE, TRUNCATE, DROP

| 명령어        | 데이터 | 저장공간 | 저장구조 | `rollback`여부                             |
| ---------- | --- | ---- | ---- | ---------------------------------------- |
| `delete`   | 삭제  | 유지   | 유지   | `rollback`가능                             |
| `truncate` | 삭제  | 삭제   | 유지   | `rollback`불가능<br>(명령어 실행 후 자동 `commit`됨) |
| `drop`     | 삭제  | 삭제   | 삭제   | 휴지통 기능이 있어서 휴지통에서 복원가능                   |

### DELETE

>`delete from 테이블명`
>`where 적용할 row 조건;`

```sql
delete from emp 
where ename = 'SCOTT';

delete from emp 
where sal >= 3000;
```

<br>

### TRUNCATE

>`truncate table 테이블명;` 

```sql
--부서테이블을 지우는데 구조만 남기고 다 삭제해라.
truncate table dept;
```

<br>

### DROP

>`drop table 테이블명;`



---
## MERGE

>- `insert`와 `delete`와 `update`를 한번에 해주는 명령어
>`merge into 삽입할 테이블명`
>`using 데이터 불러올 테이블명`
>`on (기준이 되는 조건)`
>`when matched then`  -- `on`조건이 match된다면 아래 쿼리를 실행해라.
>`update set ~`
>`when not matched then`
>`insert ~;`

```sql
alter table emp add loc varchar2(20);

merge into emp e
using dept d
on (e.deptno = d.deptno)
when matched then
update set e.loc = d.loc
when not matched then
insert (e.empno, e.deptno, e.loc) values(1111,d.deptno, d.loc);;
```

```sql
alter table emp add dname varchar2(20);

merge into emp e
using dept d
on (e.deptno = d.deptno)
when matched then
update set e.dname = d.dname;
```



---
## LOCK

> 하나의 세션에서 `update`실행시 해당 행은 `LOCK`이 걸려서 다른 세션에서 수정하지 못하게 됨.
> ⇒ 항상 일관된 데이터를 볼 수 있게 해주는 것.(`LOCK`은 행 전체가 적용된다.)

![](7-1.png)

- `LOCK`이 풀리는 시점은 `update`한 세션에서 `commit` 혹은 `rollback` 실행시 풀림.
![](7-2.png)

- 오른쪽 세션에서 `update`를 했지만 `select`로 출력되는 결과는 최종 `commit`된 결과를 보여줌.
![](7-3.png)

- 오른쪽 세션에서 `commit`을 하면 최종 `commit`내용이 보여짐
![](7-4.png)


### SELECT 시에도 LOCK 적용 - SELECT FOR UPDATE절

>`select ~ for update;` 조회하는 동안 `LOCK`을 걸어서 접근하지 못하게 함.

![](7-5.png)

![](7-6.png)

```sql
--부서번호가 10, 20번인 사원들의 이름과 직업과 부서번호를 조회하는 동안 다른 사람이 부서번호 10,20번인 사원들의 데이터를 갱신하지 못하도록 해라.
select 
	ename, job, deptno 
from emp 
where deptno in (10, 20)
for update;

commit;
```


---
## 서브쿼리 사용해서 데이터 입력하기

>`insert into 테이블명 (컬럼1, 컬럼2, ...)`
>`삽입할 테이터가 출력되는 서브쿼리;`                           --`values`가 없음.

```sql
--emp테이블과 똑같은 emp2테이블 만들기
create table emp2
as
select * from emp;

--emp테이블 구조만 같은 emp2테이블 만들기
create table emp2
as
select * from emp
where 1 = 2;
```

```sql
insert into emp2(empno, ename, sal, deptno)
select empno, ename, sal, deptno
from emp
where deptno = 10;
```

```sql
--부서 테이브로가 같은 구조의 테이블을 dept2라는 이름으로 생성하고 부서번호가 20,30번의 모든 컬럼의 데이터를 dept2에 입력해라
create table dept2
as
select * from dept
where 1 = 2;

insert into dept2 
select * from dept 
where deptno in (20, 30);
select * from dept2;
```


---
## 서브쿼리 이용하여 데이터 수정하기

```sql
--직업이 SALESMAN인 사원들의 월급을 ALLEN의 월급으로 수정해라.
update emp 
set sal = (select sal 
			   from emp 
			   where ename='ALLEN') 
where job='SALESMAN';
```

```sql
--부서번호가 30번인 사원들의 직업을 MARTIN의 직업으로 변경해라.
update emp 
	set job = (select job 
					from emp 
					where ename = 'MARTIN') 
where deptno=30;
```


---
## 서브쿼리 사용하여 데이터 삭제하기

```sql
--SCOTT보다 더 많은 월급을 받는 사원들을 삭제해라.
delete from emp 
where sal > (select sal 
				 from emp 
				 where ename = 'SCOTT');
```

```sql
--ALLEN보다 늦게 입사한 사원들의 모든 행을 지워라.
delete from emp 
where hiredate > (select hiredate 
					  from emp 
					  where ename = 'ALLEN');
```


---
## 서브 쿼리를 사용하여 데이터 합치기

```sql
--사원테이블에서 각 부서의 월급 합을 부서테이블에 sumsal 컬럼을 추가하여 값을 넣어라.
alter table dept
add sumsal number(10);

merge into dept d
using (select deptno,sum(sal) as sumsal 
		   from emp 
		   group by deptno) e
on (d.deptno = e.deptno)
when matched then
update set d.sumsal = e.sumsal;
```

```sql
--부서테이블에 cnt라는 컬럼을 추가하고 해당 부서번호의 인원수로 값을 갱신해라.
alter table dept
add cnt number(10);

merge into dept d
using (select deptno, count(*) as cnt
            from emp
            group by deptno) c
on (d.deptno = c.deptno)
when matched then
update set d.cnt = c.cnt;
```

