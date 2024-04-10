-- 1. 실행게획을 먼저 확인하자!

--예제1. 예상 실행계획 확인하는 방법

explain plan for
    select ename, sal
        from emp
        where sal = 1300;
        
select * from table(dbms_xplan.display);

--예제2. 실제 실행계획 확인하는 방법

select /*+ gather_plan_statistics */ ename, sal
    from emp
    where sal = 1300;
        
select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--예제3.때 full table scan 일 때
select /*+ gather_plan_statistics */ ename, sal
    from emp
    where sal = 1300;
        
select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--예제4. 인덱스 스캔일 때 
create index emp_sal
on emp(sal);

select /*+ gather_plan_statistics */ ename, sal
    from emp
    where sal = 1300;
        
select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--아래 sql을 튜닝해라

select empno, ename, sal, job
from emp
where empno = 7788;


select /*+ gater_plan_statistics */ empno, ename, sal, job
from emp
where empno = 7788;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

select index emp_empno on emp(empno);

--2. 인덱스의 구조

-- 예제1. 월급에 인덱스를 생성하고 인덱스의 구조를 확인해라.

create index emp_sal
on emp(sal);

select sal, rowid
from emp
where sal >= 0;

--예제2. 이름에 인덱스를 생성하고 인덱스의 구조
create index emp_ename
on emp(ename);

select ename, rowid
from emp
where ename > ' ';

select /* gather_plan_statistics */ ename, rowid
from emp
where ename > ' ';

select * from table(dbms_xplan.display_cursor(null,null, 'ALLSTATS LAST'));

select /* gather_plan_statistics */ ename, rowid
from emp;

select * from table(dbms_xplan.display_cursor(null,null, 'ALLSTATS LAST'));

--예제3. 입사일에 인덱스를 생성하고 인덱스의 구조를 확인해라.

create index emp_hiredate
on emp(hiredate);

select /*+ gather_plan_statistics */ hiredate, rowid
from emp
where hiredate < to_date('9999/12/31', 'RRRR/MM/DD');

select * from table(dbms_xplan.display_cursor(null,null, 'ALLSTATS LAST'));

select /*+ gather_plan_statistics */ hiredate, rowid
from emp;

select * from table(dbms_xplan.display_cursor(null,null, 'ALLSTATS LAST'));

-- dept 테이블에 loc에 인덱스를 생성하고 인덱스의 구조를 확인해라.
create index dept_loc
on dept(loc);

select /*+ gather_plan_statistics */ loc, rowid
from dept
where loc> ' ';

select * from table(dbms_xplan.display_cursor(null,null, 'ALLSTATS LAST'));

--예제1. 월급이 1600인 사원들의 이름과 월급을 출력해라.

create index emp_sal
on emp(sal);

select /*+ gather_plan_statistics index(emp emp_sal) */ ename, sal
from emp
where sal = 1600;

select * from table (dbms_xplan.display_cursor(null,null, 'ALLSTATS LAST'));

--예제2. 이름이 SCOTT인 사원의 이름과 월급을 출력해라. 

create index emp_ename on emp(ename);

select /*+ gather_plan_statistics index(e ename) */ ename, sal
from emp e
where ename = 'SCOTT';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--예제3. 직업이 MANAGER인 사원들의 이름과 월급을 출력해라.

create index emp_job
on emp(job);

select /*+ gather_plan_statistics index(emp job) */ ename, sal
from emp
where job = 'MANAGER';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

select job, rowid
from emp
where job > ' ';

--문제) 사원 테이블의 입사일에 인덱스를 생성하고 입사일이 81년 11월 17일에 입사한 사원들의 이름과 입사일을 출력해라.
create index emp_hiredate
on emp(hiredate);

select /*+ gather_plan_statistics index(emp hiredate) */ ename, hiredate
from emp
where hiredate = to_date('1981/11/17');

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--예제1. 연봉(sal * 12)이 36000인 사원들의 이름과 연봉을 출력하는 sql을 튜닝해라.

create index emp_sal
on emp(sal);

select /*+ gather_plan_statistics index(emp sal) */ ename, sal * 12
from emp
where sal = 36000 /12;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--예제2. 직업의 첫번째부터 5번째의 자리가 SALES인 사원들의 이름과 직업을 출력하는 sql을 튜닝해라.
select ename, job
from emp
where job like 'SALES%';

--예제3. 1981년도에 입사한 사원들의 이름과 입사일을 출력하는 sql을 튜닝해라
select ename, hiredate
from emp
where hiredate between to_date('1981/01/01', 'RRRR/MM/DD')
				and to_date('1981/12/31', 'RRRR/MM/DD')+1;
                
--문제) 다음 sql을 튜닝해라
select /*+ gather_plan_statistics */ ename, sal, job
from emp
where ename || sal = 'SCOTT3000';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

select /*+ gather_plan_statistics */ ename, sal, job
from emp
where ename like 'SCOTT%' and sal = 3000;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--예제1. 사원번호가 7788번인 사원들의 사원번호와 이름과 월급을 출력해라.
create index emp_empno
on emp(empno);

select /*+ gather_plan_statistics */ empno, ename
from emp
where empno = 7788;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

drop index emp_empno;

create unique index emp_empno
on emp(empno);

create index emp_ename
on emp(ename);

select /*+ gather_plan_statistics */ empno, ename
from emp
where ename = 'SCOTT' and empno = 7788;

--예제 3

drop index emp_empno;

alter table emp
add constraint emp_empno_pk primary key (empno);

select /*+ gather_plan_statistics */ empno, ename
from emp
where ename = 'SCOTT' and empno = 7788;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--문제

alter table dept
add constraint dept_deptno_pk primary key (deptno);

select /*+ gather_plan_statistics */ loc, dname
from dept
where deptno = 20;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--table full scan 이란
select /*+ gather_plan_statistics */ ename, sal
from emp
where sal = 3000;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--단일 컬럼만 있을 때
create index emp_sal
on emp(sal);

select /*+ gather_plan_statistics */ ename, sal
from emp
where sal = 3000;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--결합 컬럼 인덱스

drop index emp_sal;

create index emp_sal_ename
on emp(sal,ename);

select /*+ gather_plan_statistics */ ename, sal
from emp
where sal = 3000;

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--index full scan

select /*+ gather_plan_statistic */ ename, sal
from emp
where ename='JONES';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--@demo
create index emp_empno_ename_sal
on emp(empno, ename, sal);

select /*+ gather_plan_statistics index_fs(emp_empno_ename_sal) */ ename, sal
from emp
where sal = 1250;


select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--
create index emp_deptno_job
on emp(deptno, job);

select deptno, job, rowid
from emp
where deptno > 0;

select /*+ gather_plan_statistics */ ename, deptno, sal
from emp
where job='MANAGER';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

--index skip scan
select /*+ gather_plan_statistics index_ss(emp emp_deptno_job) */
        ename, deptno, sal
from emp
where job='MANAGER';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

drop index emp_deptno_job;

create index emp_sal_job
on emp(sal,job);

select sal, job, rowid
from emp
where sal >0;

--@m.sql

select /*+ gather_plan_statistics index(emp emp_sal_job) */ ename, sal, job, deptno
from emp
where sal between 950 and 3000
and job='MANAGER';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

select /*+ gather_plan_statistics index_ss(emp emp_sal_job) */ ename, sal, job, deptno
from emp
where sal between 950 and 3000
and job='MANAGER';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

drop index emp_sal_job;

--문제

create index emp_hiredate_job
on emp(hiredate, job);

select /*+ gether_plan_statistics index(emp) */
		ename, sal
from emp
where hiredate between to_date('1980/01/01', 'RRRR/MM/DD')
					and to_date('1981/12/31', 'RRRR/MM/DD')
	and job='MANAGER';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

select /*+ gether_plan_statistics index_ss(emp) */
		ename, sal
from emp
where hiredate between to_date('1980/01/01', 'RRRR/MM/DD')
					and to_date('1981/12/31', 'RRRR/MM/DD')
	and job='MANAGER';

select * from table(dbms_xplan.display_cursor(null,null,'ALLSTATS LAST'));

