

- `systimestamp` : 현재 시간을 나타냄
```sql
select systimestamp from dual;
```
![](11-1.png)

- 현재시간부터 5분전 해당 테이블의 데이터를 보게 해줌.
```sql
select *
from emp
as of timestamp(systimestamp - interval '5' minute);
```

- 5분전 데이터를 테이블에 insert.
```sql
insert into emp
select *
from emp
as of timestamp(systimestamp - interval '5' minute);
```

- 시스템마다 되돌릴 수 있는 설정 시간이 다름
```sql
show parameter undo
--900 -> 15분
```
![](11-2.png)

```sql
--월급을 0으로 바꾸고 commit한뒤 1분전 데이터로 되돌려라
update emp set sal = 0;
commit;

merge into emp e
using (select empno, sal 
		   from emp
		   as of timestamp(systimestamp - interval '5' minute)) s
on (e.empno = s.empno)
when matched then
update set e.sal = s.sal;
```


---
## FLASHBACK TABLE 

>`flashback table 테이블 to timestamp(systimestamp - interval'5'minute)`

```sql
delete from emp;

commit;

alter table emp enable row movement; -- flashback이 가능한 상태로 만듦.

flashback table emp to timestamp(systimestamp - interval '5' minute); 
commit;
```

```sql
update emp set sal = 0;

commit;


flashback table emp to timestamp(systimestamp - interval'5' minute);
```


---
## FLASHBACK DROP

>`flashback table 테이블명 to before drop` : 가장 최근에 drop한 것을 복구함.

- 휴지통에 있는 걸 drop한 날짜 순으로 정렬함 .`drop`을 하면 휴지통으로 들어감.
```sql
select *
from user_recyclebin
order by droptime desc;

--휴지통 비우기
purge recyclebin;
```

```sql
drop table emp;

select * from emp;

select *
from user_recyclebin
order by droptime desc;

flashback table emp to before drop;
```

```sql
drop table dept;

select * 
	from user_recyclebin;

flashback table dept to before drop;
```


---
## FLASHBACK VERSION QUERY

> 테이블의 히스토리 내역을 확인할 때 사용
>`select 문`
>`versions between timestamp to_timestamp('날짜', '날짜 형식')`
>	`and maxvalue`
>`where 컬럼 조건`
>`order by versions_starttime;`

**[`versions query` 작성시 참고사항]**
- `commit`이 진행되어야 version이 업데이트 된다.
- `version_starttime`의 초기값은 `null`로 되어 있으므로 `nulls first`를 작성하면 순서대로 확인하기 용이하다.
- `to_timestamp`값은 특정 시점을 시작지점으로 설정할 수 있다.
	(`between timestamp` 구문에서 종료시점도 설정 가능하다.)


```sql
select * from dept;
commit;

select ename, sal, deptno, versions_starttime, versions_endtime, versions_operation
from emp
versions between timestamp to_timestamp('2024-04-08 11:56:10', 'RRRR-MM-DD HH24:MI:SS')
    and maxvalue
where ename='KING'
order by versions_starttime;


select * from dept;

update dept 
set loc='SEOUL';

commit;
select * from dept;

select deptno, dname, loc, versions_starttime, versions_endtime, versions_operation
from dept
versions between timestamp to_timestamp('2024-04-08 11:56:10', 'RRRR-MM-DD HH24:MI:SS')
    and maxvalue
where loc='SEOUL'
order by versions_starttime;
```


---
## FLASHBACK TRANSACTION QUERY

>데이터를 지워서 다시 복구하는 스크립트

- cmd에서 `sysdba`로 접속(최고 권한자로 접속)
```powershell
sqlplus "/as sysdba"
```

```sql
show user
-- "SYS"
shutdown immediate
--데이터베이스가 닫혔습니다.
--...
--ORACLE 인스턴스가 종료되었습니다.
startup mount
--...
--데이터베이스가 마운트되었습니다.
alter database archivelog;
--데이터베이스가 변경되었습니다. - 아카이브로그 모드로 변경 : db가 장애가 났을 때 언제든지 복구 가능하게 해주는 모드.
alter databasae add supplemental log data;
-- enterprise 버전에서만 가능함. - 메모리 8GB이상에서만 가능(Express Edition에서는 불가능) -> 복구에 필요한 스크립트를 저장해줌.
connect / as sysdba
--연결되었습니다.
alter database open;
-- 데이터베이스가 변경되었습니다.
connect scott/tiger
연결되었습니다.
connect /as sysdba
alter user scott account unlock;
사용자가 변경되었습니다.
alter user scott identified by tiger;
사용자가 변경되었습니다.
connect scott/tiger
connect 
연결되었습니다.
```













