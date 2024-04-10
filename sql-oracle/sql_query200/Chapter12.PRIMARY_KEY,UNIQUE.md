
## PRIMARY

### 테이블을 만들 때 제약 설정

>`create table 테이블명`
>`(컬럼명 컬럼타입 constraint pk명 primary key)`

```sql
-- 테이블에 제약 X 만듦
create table dept2
(deptno number(10),
dename varchar2(10),
loc varchar2(10));


drop table dept2;

-- 테이블에 제약 O 만듦
create table dept2
(deptno number(10) constraint dept2_deptno_pk primary key,
dname varchar2(10),
loc varchar2(10));

insert into dept2 values(10, 'aaa', 'bbb');
insert into dept2 values(20, 'aaa', 'bbb');
select * from dept2;

insert into dept2 values(10, 'ccc', 'dddd');      -- error
insert into dept2 values(null, 'ccc', 'dddd');    -- error
```
![](12-1.png)
- `dept2_deptno_pk` 제약이름인데 나중에 제약을 삭제할 때 등등의 경우에 필요함. 이름을 안줘도 oracle에서 자동으로 만들어주지만 의미있게 만들어 주지는 않음.

- 현재 db에 있는 제약을 확인할 수 있는 명령어
```sql
select table_name, constraint_name
from user_constraints;
```

- 제약을 없애는 명령어 -> 다시 insert에 제약이 없어짐.
```sql
alter table dept2
drop constraint dept2_deptno_pk;
```


### 이미 만들어진 테이블에 제약 설정

>`alter table 테이블명`
>`add constraint pk명 primary key(컬럼명)`

- 중복된 데이터와 null값이 없어야 제약 설정 가능

```sql
alter table dept
add constraint dept_deptno_pk primary key(deptno);
```

```sql
alter table emp
add constraint emp_empno_pk primary key(empno);
```


---
## UNIQUE

### 테이블을 만들 때 제약 설정

>`create table 테이블명`
>`(컬럼명 컬럼타입 constraint unique명 unique)`

```sql
create table dept3
(deptno number(10),
dname varchar2(14) constraint dept3_dname_un unique,
loc varchar2(10));

-- dept3테이블에 unique가 걸려있는지 확인하는 명령어
select a.constraint_name, a.constraint_type, b.column_name
from user_constraints a, user_cons_columns b
where a.table_name = 'DEPT3'          -- 테이블 명을 반드시 대문자로 작성해야함!
and a.constraint_name = b.constraint_name;
```

### 이미 만들어진 테이블에 제약 설정

>`alter table 테이블명`
>`add constraint 제약명 unique(컬럼명)`

```sql
create table dept4
(deptno number(10),
dname varchar2(13),
loc varchar2(10));

alter table dept4
add constraint dept4_dname_un unique(dname);
```

- 중복된 데이터가 있는지 확인해라
```sql
select empno, count(*) 
from emp 
group by empno 
having count(*) > 2;
```

















