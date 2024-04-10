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

