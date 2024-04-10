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