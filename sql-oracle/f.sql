alter  tablespace ts01  offline;

alter  system flush buffer_cache;
alter  system flush shared_pool;
exec SYS.DBMS_SESSION.FREE_UNUSED_USER_MEMORY;

alter tablespace ts01 online;