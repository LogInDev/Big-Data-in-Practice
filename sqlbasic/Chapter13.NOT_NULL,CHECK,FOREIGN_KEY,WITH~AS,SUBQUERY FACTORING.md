
## NOT NULL

### 테이블 만들 때 제약 걸기

>`create table 테이블명`
>`(컬럼명 컬럼타입 constraint 제약명 not null)`

```sql
create table dept5
(deptno number(10),
dname varchar2(14),
loc varchar2(10) constraint dept5_loc_nn not null);
```


### 이미 있는 테이블에 제약 걸기

>`alter table 테이블명`
>`modify 컬럼명 constraint dept6_loc_nn not null`

```sql
create table dept6
(deptno number(10),
dname varchar2(13),
loc varchar2(10));

alter table dept6
modify loc constraint dept6_loc_nn not null;
```

- emp테이블에 null값이 몇건 있는지 출력해라
```sql
select count(*)
from emp
where ename is null;
```

```sql
select * from dept where deptno is null;

alter table dept
modify deptno constraint dept_deptno_nn not null;
```


---
## CHECK

### 테이블을 만들 때 제약 설정

>`create table 테이블명`
>`(컬럼명 컬럼타입 constraint 제약명 check (조건))`

- 특정 조건에 맞는 것만 입력되도록 설정하는 제약

```sql
drop table emp6;

create table emp6
(empno number(10),
ename varchar2(20),
sal number(10) constraint emp6_sal_ck check (sal between 0 and 6000));
```


### 이미 있는 테이블에 제약 설정

>`alter table 테이블명`
>`add constraint 제약명 check(조건)`

```sql
alter table emp
add constraint emp_sal_ck check(sal between 0 and 9000);
```

```sql
--사원 테이블의 부서번호에 부서번호가 10번, 20번, 30번만 입력, 수정되게 제약을 걸어라.
alter table emp
add constraint emp_deptno_ch check(deptno in (10, 20,30));
```

```sql
--부서 테이블의 부서위치에 NEW YORK, DALLAS, CHICAGO, BOSTON만 입력, 수정되게 제약을 걸어라.
alter table dept
add constraint dept_loc_ck check(loc in ('NEW YORK', 'DALLAS', 'CHICAGO', 'BOSTON'));
```

```sql
--사원 테이블에 이메일 컬럼을 추가하고 이메일에 @가 있어야만 입력, 수정되도록 제약을 걸어라.
alter table emp
add email varchar(20);

alter table emp
add constraint emp_email_ck 
check(REGEXP_LIKE(email, '^[^@]+@[^@]+\.[^@]+$'));
```


---
## FOREIGN KEY

- 다른 테이블의 primary key 컬럼에 foreign key 제약을 사용.

```sql
create table dept7
(deptno number(10) constraint dept7_deptno_pk primary key,
dname varchar(20),
loc varchar(20));

create table emp7
(empno number(10),
ename varchar2(20),
sal number(10),
deptno number (10)
constraint emp7_deptno_fk references dept7(deptno));

select a.constraint_name, a.constraint_type, b.column_name
from user_constraints a, user_cons_columns b
where a.table_name in ('DEPT7', 'EMP7')
and a.constraint_name = b.constraint_name;
```
![](13-1.png)

- primary key 제약 삭제 명령어
```sql
alter table dept7
 drop constraint dept7_deptno_pk;
```
![](13-2.png)

- `cascade` : primary key와 foreign key 같이 삭제
```sql
 alter table dept7
 drop constraint dept7_deptno_pk cascade;
```

```sql
--사원 테이블에 empno에 primary key를 걸어라
alter table emp
 add constraint empno_emp_pk primary key (empno);
```

```sql
--사원 테이블에 관리자 번호(mgr)에 foreign key 제약을 걸고 사원 테이블에 사원번호에 있는 컬럼을 참조하게 하여 관리자 번호가 사원 테이블에 있는 사원번호에 해당하는 사원들만 관리자 번호로 입력, 수정될 수 있도록 해라
 alter table emp
 add constraint mgr_emp_fk foreign key(mgr) references emp(empno);
```


---
## WITH ~ AS

>`with ~ as`로 임시테이블(temp table)을 메모리에 저장해서 사용. 하나의 쿼리문에 서브쿼리가 중복으로 사용되는 경우 성능 최적화를 위해사용. 하지만 남발하면 메모리에 무리가됨.

```sql
 with job_sumsal as 
	 (select job, sum(sal) as 토탈 
		 from emp 
		 group by job)
 select job, 토탈
	 from job_sumsal
	 where 토탈 > (select avg(토탈)
					 from job_sumsal);
```

```sql
--부서번호별 토탈월급을 출력하는데 부서번호별 토탈월급들의 평균값 보다 더 큰것만 출력되게해라.
 with dept_sumsal as (select deptno, sum(sal) as sumsal
                        from emp
                        group by deptno)
select deptno, sumsal
from dept_sumsal
where sumsal > (select avg(sumsal) 
                from dept_sumsal);
```

```sql
--부서위치, 부서위치별 토탈월급을 출력하는데 부서위치별 토탈월급의 평균값보다 더 큰 것만 출력해라.
with empdept as (select * from emp e,dept d where e.deptno = d.deptno),
locsal as (select loc, sum(sal) as sumsal from empdept
                    group by loc)
select loc, sumsal from locsal
where sumsal > (select avg(sumsal) from locsal);
```


---
## SUBQUERY FACTORING

- from절에 있는 서브쿼리는 join시 사용하지 못함.
```sql
-- 불가능한 구문
select deptno, sum(sal)
from (select job, sum(sal) 토탈
        from emp
        group by job) as job_sumsal,
    (select deptno, sum(sal) 토탈
    from emp
    group by deptno
    having sum(sal) > (select avg(토탈) + 3000
                        from job_sumsal)); -- error. job_sumsal 사용불가
```

```sql
--subquery factoring으로 해결 가능
with job_sumsal as (select job, sum(sal) 토탈
                        from emp
                        group by job),
    deptno_sumsal as (select deptno, sum(sal) 토탈
                        from emp
                        group by deptno
                        having sum(sal) > (select avg(토탈) + 3000
                                                    from job_sumsal)
                        )
select deptno, 토탈 from deptno_sumsal;  
```

```sql
--입사한 년도와 입사한 년도별 토탈월급을 출력하는데 부서번호별 토탈월급들의 평균값보다 더 큰것만 출력해라.
with deptsum as (select deptno, sum(sal) as 토탈  
                    from emp
                    group by deptno
                    ),
    hiresum as ( select to_char(hiredate, 'RRRR') as 년도, sum(sal) as sumsal 
                    from emp 
                    group by to_char(hiredate, 'RRRR')
                    having sum(sal) > (select avg(토탈)
                                            from deptsum)
                )
select 년도, sumsal 
from hiresum;
```

