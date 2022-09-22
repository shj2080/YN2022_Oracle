--<북스 13장-사용자 권한과 테이블 스페이스>

--[테이블스페이스]------------------------------------------------
--오라클에서는 Data file이라는 물리적 파일 형태로 저장하고
--이러한  Data file이 하나 이상 모여서 Tablespace라는 논리적인 공간을 형성함

/* 물리적 단위          논리적 단위
 *             DATABASE
 *                 |
 * datafile   TABLESPACE : 데이터 저장 단위 중 가장 상위에 있는 단위
 * (*.dbf)         |
 *              segment : 1개의 segment는 여러 개의 extent로 구성(예)table, 트리거 등
 *                 |
 *              extent  : 1개의 extent는 여러 개의 DB block으로 구성
 *                 |      extent는 반드시 메모리에 연속된 공간을 잡아야함(단편화가 많으면 디스크 조각모음으로 단편화 해결)
 * 
 *             DB block : 메모리나 디스크에서 I/O할 수 있는 최소 단위
 *         
 */

--※ 트리거 : 데이터의 입력, 추가, 삭제 등의 이벤트가 발생할 때마다 자동으로 수행되는 사용자 정의 프로시저

-- [ 테이블스페이스 관련 Dictionary ] 
/*
    .DBA_TABLESPACES : 모든 테이블스페이스의 저장정보 및 상태정보를 갖고 있는 Dictionary
    .DBA_DATA_FILES  : 테이블스페이스의 파일정보
    .DBA_FREE_SPACE  : 테이블스페이스의 사용공간에 관한 정보
    .DBA_FREE_SPACE_COALESCED : 테이블스페이스가 수용할 수 있는 extent의 정보
*/


--[Tablespace의 종류]
--첫 째, contents로 구분하면 3가지 유형
select tablespace_name, contents
from dba_tablespaceS;--모든 테이블스페이스의 저장 정보 및 상태 정보
--1. Permanent Tablespace
--2. Undo Tablespace
--3. Temporary Tablespace 로 구성.

--둘 째, 크게 2가지 유형으로 구분하면
--즉, 오라클 DB는 크게 2가지 유형의 Tablespace로 구성
--1. 'SYSTEM' 테이블스페이스(필수, 기본) : 
--    DB설치시 자동으로 생성되는 테이블스페이스로,
--    별도로 테이블스페이스를 지정하지 않고 테이블, 트리거, 프로시저 등을 생성했다면
--    이 'SYSTEM' 테이블스페이스에 저장됨
--    (예) 모든 Data Dictionary 정보, 프로시저, 트리거, 패키지,
--    System Rollback segment 등을 저장함
--    
--    사용자 데이터도 저장 가능하나 관리 효율성 면에서 포함시키면 안됨.
--    (예)오라클 설치하면 기본으로 저장되어 있는 emp나 dept테이블(이 테이블들은 사용자들이 사용가능함) 
--    
--    
--    ※ rollback segment란? rollback시 commit하기 전 상태로 돌리는데 그 돌리기 위한 상태를 저장하고 있는 세그먼트
          
--    DB운영에 필요한 기본 정보를 담고 있는 Data Dictionary Table이 저장되는 공간으로
--    DB에서 가장 중요한 Tablespace
--    중요한 데이터가 담겨져 있는 만큼 문제가 생길 경우 자동으로 데이터베이스를 종료될 수 있으므로
--    일반 사용자들의 객체들을 저장하지 않는 것을 권장함.
--    (혹여나 사용자들의 객체에 문제가 생겨 데이터베이스가 종료되거나 
--     완벽한 복구가 불가능한 상황이 발생할 수 있기 때문에...)

--2. 'NON-SYSTEM' 테이블스페이스 : 사용자에게 할당되는 공간
--   보다 융통성있게 DB를 관리할 수 있다.
--   (예)rollback segment, 
--   Temporary Segment,
--   Application Data Segment,
--   Index Segment,
--   User Data Segment 포함

--   ※ Temporary세그먼트란?
--     :order by를 해서 데이터를 가져오기 위해선 임시로 정렬할 데이터를 가지고 있을 공간이 필요하고
--     그 곳에서 정렬한 뒤 데이터를 가져오는데 이 공간을 가리킨다.


select username, default_tablespace--SYSTEM, SYSTEM
from user_userS;

--1. <테이블스페이스 생성>----------------------------------------------------------------------
CREATE tablespace [테이블스페이스명]
datafile '파일경로'
size 초기 데이터 파일 크기 설정M
AUTOextend ON next 1M --size로 설정한 초기 크기 공간을 모두 사용하는 경우 자동으로 파일의 크기가 커지는 기능
					  --K(킬로 바이트), M(메타 바이트) 두 단위만 사용할 수 있다.
					  --1024K=1M
MAXSIZE 250M--데이터파일이 최대로 커질 수 있는 크기 지정(기본값:unlimited 무제한)
uniform size 1M;--extent 1개의 크기

--(1) tablespace 생성
CREATE tablespace test_data
datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data01.dbf'
size 10M
default storage(initial 2M --최초 extent 크기
				next 1M --2M가 꽉 차면 그다음 extent 1M 생성(extent는 반드시 메모리에 연속된 공간을 잡아야 함)
				minextents 1 --생성할 extent의 최소 개수(최소 1회부터)
				maxextents 121--생성할 extent의 최대 개수(최대 121회 발생 가능. 122회 불가능(오류))
				pctincrease 50); --기본값. 다음에 할당할 extent의 수치를 %로 나타냄
--pctincrease 50% 으로 지정하면 처음은 1M = 1024K, 두번째부터는 next 1M의 반인 512K, 그 다음에 또 512K
				
--default storage 생략하면 '기본값으로 지정된 값'으로 설정됨
				
--(2) tablespace 조회 ★★★
select * -- tablespace_name, status, segment_space_management
from dba_tablespaceS; -- 모든 테이블스페이스의 저장정보 및 상태 정보를 갖고 있는 데이터사전

--2. <테이블스페이스 변경>----------------------------------------------------------------------
--위에서 생성한 test_data 테이블스페이스에 datafile을 1개 더 추가
ALTER tablespace test_data
ADD datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data02.dbf'
size 10M;
--10M  10M => 총 20M
--즉, 물리적으로 2개의 데이터 파일로 구성되어진 하나의 테이블스페이스가 만들어짐

--3. <테이블스페이스의 datafile의 크기 조절>----------------------------------------------------------------------
--3-1. 자동으로 크기 조절
ALTER tablespace test_data
ADD datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data03.dbf'
size 10M
AUTOextend ON next 1M --1024K(K, M 두 단위만 사용가능)
MAXSIZE 250M;--(K, M 두 단위만 사용가능)
--test_data03.dbf의 크기인 10M를 초과하면 자동으로 1M씩 늘어나 최대 250M까지 늘어남
--★주의 : MAXSIZE 250M -> 기본값인 unlimited(무제한)으로 변경하면 문제 발생할 가능성이 있음
--		(예)리눅스에서는 파일 1개를 핸들링할 수 있는 사이즈가 2G로 한정되어 있으므로
--			따라서, data file이 2G를 넘으면 그 때부터 오류 발생하므로
--			가급적이면 MAXSIZE 지정하여 사용하는 것이 바람직함

--3-2. 수동으로 크기 조절(★★ 주의 : ALTER database)
--기존 test_data02.dbf 파일의 크기 변경
ALTER database
datafile 'C:\oraclexe\app\oracle\oradata\XE\test\test_data02.dbf'
REsize 20M;--10M -> 20M로 크기 변경
--하나의 테이블스페이스(test_data)=총 40M인 3개의 물리적 datafile로 구성됨

--4. <data file 용량 조회>
--file_name : data file의 위치한 경로
select file_name, tablespace_name, bytes/1024/1024MB, autoextensible as "auto"--*
from dba_data_fileS;--테이블스페이스의 파일정보

--5. <테이블스페이스의 단편화된 공간 수집 : 즉, 디스크 조각모음>
ALTER tablespace '테이블스페이스명' coalesce;
ALTER tablespace test_data coalesce;
--dba_free_space_coalesced를 조회해보고 필요에 따라 여러 번 실행해야 한다.

--6. <테이블스페이스 제거하기>-------------------------------------------------
--형식
DROP tablespace 테이블스페이스명; --테이블스페이스 내에 객체가 존재하면 삭제불가
[INCLUDING CONTENTS]; --<옵션1>해결법 : 모든 내용(객체) 포함하여 삭제
					  --그러나, 탐색기에서 확인해보면 물리적 data file까지 함께 삭제
[INCLUDING CONTENTS and datafileS]; --물리적 data file까지 함께 삭제
[CASCADE constraintS]; --<옵션3> 제약조건까지 함께 삭제

--먼저, 테이블 하나를 생성(test_data테이블스페이스에)
DROP table test;
create table test(
	a char(1) 
)tablespace test_data;

DROP tablespace test_data; --실패:ORA-01549: tablespace not empty, use INCLUDING CONTENTS option

--해결법<옵션1>
DROP tablespace test_data
INCLUDING CONTENTS; --테이블스페이스의 모든 내용(객체) 함께 삭제
--성공. 탐색기에서 확인해보면 물리적 data file은 삭제안됨
--따라서 직접 삭제해줘야 함

--해결법<옵션2>
DROP tablespace test_data
INCLUDING CONTENTS and datafileS; --물리적 data file까지 함께 삭제

--해결법<옵션3>
--그런데, 'A테이블스페이스의 사원테이블(dno:FK)'이 'B테이블스페이스의 부서테이블(dno:PK)'를 참조하는 상황에서
--B테이블스페이스를 위 방법(옵션2)처럼 삭제한다면 '참조 무결성'에 위배되므로 오류 발생
DROP tablespace B
INCLUDING CONTENTS and datafileS;
CASCADE constraintS; --제약조건까지 삭제하여 해결가능함


--교재 308p--------------------------------------------------------------
--1. 사용권한
--오라클 보안 정책 : 2가지(시스템 보안->시스템 권한, 데이터 보안->객체 권한)
--[1] 시스템 보안 : DB에 접근 권한을 설정. 사용자 계정과 암호 입력해서 인증받아야 함 
--[2] 데이터 보안 : 사용자가 생성한 객체에 대한 소유권을 가지고 있기 때문에
--              데이터를 조회하거나 조작할 수 있지만
--              다른 사용자는 객체의 소유자로부터 접근 권한을 받아야 사용가능

--권한 : 시스템을 관리하는 '시스템 권한', 객체를 사용할 수 있도록 관리하는 '객체 권한'

--308p 표-시스템 권한 :'DBA 권한을 가진 사용자'가 시스템 권한을 부여함
--1. create session : DB 접속(=연결)할 수 있는 권한

--2. create table   : 테이블 생성할 수 있는 권한
--3. unlimited tablespace : 테이블스페이스에 블록을 할당할 수 있도록 해주는 권한
--그러나 unlimited tablespace하면 문제 발생할 수 있다.(default tablespace인 'SYSTEM'의  중요데이터 보안상)
--그래서 default tablespace를 다른 테이블스페이스(USERS)로 변경하고
--quota절로 사용할 용량을 할당해준다.(이 때, unlimited로 할당해줘도 무방하다.)

--4. create sequence : 시퀀스 생성 권한
--5. create view     : 뷰 생성 권한
--6. select any table: 권한을 받은 자가 어느 테이블, 뷰라도 검색 가능
--이 외에도 100여 개 이상의 시스템 권한이 있다.
--DBA는 사용자를 생성할 때마다 적절한 시스템 권한을 부여해야 한다.

--<시스템 권한>-------------------------------------------
--소유한 객체의 사용권한 관리를 위한 명령어 : DCL(GRANT, REVOKE)
/*
 * 시스템 권한 부여 : 반드시 'DBA 권한' 가진 사용자만 권한 부여할 수 있다.
 * GRANT '시스템권한|role' TO 사용자|롤(role)|public(=모든 사용자) [with ADMIN option]
 */

--'DBA 권한' 가진 SYSTEM으로 접속하여 사용자의 이름과 암호 지정하여 사용자 생성
--주의 : create user, grant, revoke 구문등은 Run SQL~ 에서 사용해야함-----
SQL> conn system/1234
Connected.

--사용자 생성
SQL> create user user01 identified by 1234;
User created.

--DB에 접근하려면 권한이 필요함★
SQL> conn user01/1234
ERROR:
ORA-01045: user USER01 lacks CREATE SESSION privilege; logon denied

--'DBA 권한을 가진 사용자'가 권한이 필요한 사용자에게 grant로 권한 부여
SQL> conn system/1234
Connected.
SQL> grant create session, create table to user01;

--오류 이유? SYSTEM테이블스페이스의 영역을 할당받지 못해서
SQL> conn user01/1234
Connected.
SQL> create table samplebl(no number);
create table samplebl(no number)
*
ERROR at line 1:
ORA-01950: no privileges on tablespace 'SYSTEM'

--1. 실패 해결방법-1
grant unlimited tablespace to user01;
--default tablespace인 'SYSTEM' 테이블스페이스 영역을 무제한 사용
--그러나, 권한 부여하면 문제 발생할 수 있다.
--(SYSTEM테이블스페이스의 중요한 데이터 보안상★)

-------------------------------
--user01의 default_tablespace 확인
select username, default_tablespace
from dba_userS
where username in ('USER01'); --default_tablespace : SYSTEM

select username, tablespace_name, max_bytes
from dba_ts_quotaS --quota가 설정된 user만 표시
where username in ('USER01');
--결과가 없음:user01은 quota가 설정안됨
--그래서 'default_tablespace를 test_data(또는 userS)로 변경' 후 'quota를 설정'

--2. ★★실패 해결방법-2 : SYSTEM 테이블스페이스의 중요한 데이터의 보안상 문제 발생할 수 있으므로 default_tablespace를 변경함
------★기본 테이블스페이스 변경 및 quota(제한용량) 설정(Run SQL~ 에서 실행) ----------
ALTER user user01
default tablespace users --users : 사용자 데이터가 들어갈 테이블스페이스
quota 5M ON users;

ALTER user user01
default tablespace test_data --test_data: 위에서 직접 생성한 테이블스페이스
quota 2M ON test_data;

select username, tablespace_name, max_bytes --USER01, SYSTEM
from dba_ts_quotaS	--quota가 설정된 user만 표시
where username in ('USER01');

--------------------------
--quota unlimited (영역 무제한 사용)

ALTER user user01
default tablespace users --users : 사용자 데이터가 들어갈 테이블스페이스
quota unlimited ON users; --무제한 : -1로 표시됨

ALTER user user01
default tablespace test_data --test_data: 위에서 직접 생성한 테이블스페이스
quota unlimited ON test_data; --무제한 : -1로 표시됨
----------------------------------------------
--<안전한 user 생성 방법> -- DBA권한 필요함
--보통 user를 생성하고
--grant connect, resource to 사용자명;
--를 습관적으로 권한을 주는데
--resource 롤을 주면 'unlimited tablespace'까지 주기에
--'SYSTEM' 테이블스페이스를 무제한으로 사용가능하게 되어
--'보안' 혹은 관리상에 문제가 될 소지를 가지고 있다.

--[1] USER 생성
CREATE USER user02 identified by 1234;

--[2] 권한 부여
GRANT connect, resource to user02;

--[3] 'unlimited tablespace' 권한 회수 : 반드시 권한을 준 DBA가 권한 회수할 수 있다.
REVOKE unlimited tablespace FROM user02;

--[4] user02의 default tablespace를 변경하고 quota절로 영역 할당해줌
ALTER USER user02
default tablespace users--users : 사용자 데이터가 들어갈 테이블스페이스
quota 10M ON users;--quota unlimited ON users;

--[with ADMIN option]--------------(Run SQL Command Line 에서 실행)
/*
 * [with ADMIN option] 옵션
 * 1. 권한을 받은 자(=GRANTEE)가 시스템권한 또는 롤을 다른 사용자 또는 롤에게 부여할 수 있도록 해준다.
 * 2. with ADMIN option으로 주어진 권한은 계층적이지 않다.(=평등하다.)
 *    즉, b_user가 a_user의 권한을 REVOKE 할 수 있다.
 * 3. REVOKE 시에는 with ADMIN option 옵션을 명시할 필요가 없다.
 * 4. ★   with ADMIN option으로 grant한 권한은 revoke 시 cascade되지 않는다.
 */

SQL> conn system/1234
SQL> CREATE USER a_user identified by 1234;
SQL> GRANT create session TO a_user with ADMIN option;

--b_user 생성
SQL> CREATE USER b_user identified by 1234;

--a_user로 접속하여 b_user에게 DB접속 권한(with ADMIN option) 부여
SQL> conn a_user/1234
SQL> GRANT create session TO b_user with ADMIN option;

--b_user로 접속하여 a_user의 DB접속 권한 회수
SQL> conn b_user/1234
SQL> REVOKE create session FROM a_user;

--a_user로 접속하려면
SQL> conn a_user/1234 -- 실패

--<시스템 권한 회수>
--Revoke '시스템 권한|role' FROM 사용자|롤(role)|public(=모든 사용자)

---------------------------------------------------------------------
--2. 롤(role) 321p : 다양한 권한을 효과적으로 관리할 수 있도록 관련된 권한까지 묶어 놓은 것
--여러 사용자에게 보다 간편하게 권한을 부여할 수 있도록 함
--GRANT connect, resource, dba TO system;
--※ DBA 롤 : 시스템 자원을 무제한적으로 사용, 시스템 관리에 필요한 모든 권한
--※ CONNECT 롤 : Oracle 9i까지-8가지(321p 표참조), Oracle 10g부터는 'create session'만 가지고 있다.
--※ RESOURCE 롤 : 객체(테이블, 뷰 등)를 생성할 수 있도록 하기 위해서 '시스템 권한'을 그룹화
---------------------------------------------------------------------

--[객체 권한]
--소유한 '객체'의 사용권한 관리를 위한 명령어 : DCL(grant, revoke)
--1.1 객체 권한 부여(교재 312p 표 참조) : 'DB관리자나 객체소유자'가 다른 사용자에게 권한을 부여할 수 있다.

--GRANT 'select|insert|update|delete.. ON 객체' TO 사용자|role|public [with GRANT option]
-- (ex) GRANT 'ALL(모든객체권한) ON 객체' TO 사용자;

--1. select ON 테이블명
SQL> conn system/1234
SQL> CREATE USER user01 identified by 1234;
SQL> grant create session, create table to user01; --DB 접속 권한

SQL> conn user01/1234--접속 성공
SQL> select * from employees; --실패 : user01은 employees 테이블이 없어서 오류
SQL> select * from hr.employees; --실패 : user01은 hr소유의 employees 테이블 조회 권한 없어서

SQL> conn hr/1234 --접속해보니 lock되어 있으면

SQL> conn system/1234 --wjqthrgkdu
SQL> ALTER USER hr account unlock; --잠김 해제하고
SQL> ALTER USER hr identified by 1234; --비밀번호도 다시 1234로 변경

SQL> conn hr/1234 --접속 성공
--★★user01에게 employees 테이블 조회 권한 부여★★
SQL> grant select ON employees TO user01;

SQL> conn user01/1234--접속
SQL> select * from hr.employees; --조회 성공

--2. insert ON 테이블명
SQL> conn hr/1234 --접속
--user01에게 'employees 테이블 삽입 권한' 부여
SQL> grant insert ON employees TO user01;

SQL> conn user01/1234--접속
SQL> desc hr.employees;--테이블 구조:'not null인 컬럼'에 대해서만 값을 부여(나머지는 null값 자동 삽입됨)
SQL> insert into hr.employees(EMPLOYEE_ID, FIRST_NAME, LAST_NAME,EMAIL,HIRE_DATE,JOB_ID)
     values(8010, '길동', '홍', 'a@naver.com', '2022/09/22', 'AC_ACCOUNT');
     
--3. update(특정컬럼) ON 테이블명
SQL > conn hr/1234--접속
--user01에게 'employees 테이블의 특정컬럼 수정 권한' 부여
SQL> grant update(salary) ON employees TO user01;

SQL> conn user01/1234--접속
SQL> update hr.employees SET salary=1000 where EMPLOYEE_ID = 8010;--성공
SQL> update hr.employees SET commission_pct=500 where EMPLOYEE_ID = 8010; --실패?commission_pct 컬럼수정에 대한 권한 없어서

--1.2 객체 권한 회수=제거 : DB 관리자나 권한을 부여한 사용자가 다른 사용자에게 부여한 객체 권한을 박탈------------------------
--REVOKE 객체 권한 FROM 사용자
--※ PUBLIC으로 권한을 부여하면 회수할 때도 PUBLIC으로 해야 한다.

--1. revoke select ON 객체
SQL> conn hr/1234; --권한을 부여한 사용자로 접속
SQL> revoke select ON employees from user01;

SQL> conn user01/1234--접속
SQL> select * from hr.employees;--실패 (테이블 조회 권한 없음)
SQL> update hr.employees SET salary=2000 where EMPLOYEE_ID = 8010;--성공

--2. revoke ALL on 객체 : 객체에 대한 모든 권한 회수
SQL> conn hr/1234; --권한을 부여한 사용자로 접속
SQL> revoke ALL ON employees from user01;
SQL> revoke ALL ON employees from PUBLIC; --모든 사용자의 employees 테이블 객체에 대한 모든 권한 회수

SQL> conn user01/1234--접속
SQL> update hr.employees SET salary=3000 where EMPLOYEE_ID = 8010;--성공
--실패 메시지 : ORA-00942: table or view does not exist

--[with GRANT option]--------------(Run SQL Command Line 에서 실행)
/*
 * [with GRANT option] 옵션
 * 1. 권한을 받은 자(=GRANTEE)가 '객체권한'을 '다른 사용자'에게 부여할 수 있도록 해준다.
 * 2. with GRANT option으로 주어진 권한은 계층적이다.(=평등하지 않다.)
 *    즉, b_user가 a_user의 권한을 REVOKE 할 수 없다.
 * 3. REVOKE 시에는 with GRANT option 옵션을 명시할 필요가 없다.
 * 4. ★   with GRANT option으로 grant한 권한은 revoke 시 cascade된다.
 * 	  즉, 부여자의 권한이 회수될 때 권한을 받은자의 권한이 같이 회수된다.
 * 
 * ※ with GRANT option 옵션은 role에 권한을 부여할 때는 사용할 수 없다.
 */

SQL> conn system/1234--접속
SQL> create user usertest01 identified by 1234;
SQL> create user usertest02 identified by 1234;

--위에서 생성한 사용자들에게 DB접속권한, 테이블생성권한, 뷰생성권한
SQL> grant create session, create table, create view TO usertest01;
SQL> grant create session, create table, create view TO usertest02;

SQL> conn hr/1234--hr(객체 소유자)접속, conn system/1234 (DB관리자)
--usertest01에게 employees 테이블 조회권한 부여 + with GRANT option 옵션
--usertest01은 소유자 hr로부터 다른 사용자에게 해당 권한(=employees 테이블 조회권한)을 부여할 수 있는 권한 부여받음
SQL> grant select ON employees TO usertest01 WITH GRANT OPTION;

SQL> conn usertest01/1234 --접속
SQL> grant select ON hr.employees TO usertest02;

SQL> conn usertest02/1234 --접속
SQL> select * from hr.employees;--성공

--권한 회수 : 객체의 소유자 계정
SQL> conn hr/1234
SQL> revoke select on employees FROM usertest01;--권한 회수하면 cascade로 권한이 다 회수됨

SQL> conn usertest02/1234 --접속
SQL> select * from hr.employees; --실패

--------------------------------------------------------------------------------------------------
--1.4 public : 모든 사용자에게 해당 권한 부여
--권한 부여 : 객체의 소유자 계정
SQL> conn hr/1234
SQL> grant select ON employees TO public;

SQL> conn usertest02/1234 --접속하여
SQL> select * from hr.employees;--성공
--------------------------------------------------------------------------------------------------

--2. 롤을 사용한 권한 부여 (321p~)
--2. 롤(role) 321p : 다양한 권한을 효과적으로 관리할 수 있도록 관련된 권한까지 묶어 놓은 것
--여러 사용자에게 보다 간편하게 권한을 부여할 수 있도록 함
--GRANT connect, resource, dba TO system;
--※ DBA 롤 : 시스템 자원을 무제한적으로 사용, 시스템 관리에 필요한 모든 권한
--※ CONNECT 롤 : Oracle 9i까지-8가지(321p 표참조), Oracle 10g부터는 'create session'만 가지고 있다.
--※ RESOURCE 롤 : 객체(테이블, 뷰 등)를 생성할 수 있도록 하기 위해서 '시스템 권한'을 그룹화

--<사용자가 직접 정의해서 사용하는 롤 생성>
--롤에 암호 부여 가능
--롤 이름은 사용자나 다른 롤과 중복될 수 없음


--<롤 부여 순서>
--[1] role 생성 : 반드시 DBA권한을 가진 사용자만 롤 생성
--[2] role에 권한 부여
--[3] role을 사용자 또는 다른 role에게 부여

SQL> conn system/1234
SQL> create user usertest03 identified by 1234;

--[1] role 생성
SQL> create role role_test01;
--[2] role에 권한 부여
SQL> GRANT create session, create table, create view TO role_test01;
--[3] role을 사용자 또는 다른 role에게 부여
SQL> GRANT role_test01 TO usertest01;
SQL> conn usertest01/1234 --접속 성공

SQL> conn system/1234 --DBA권한을 가진 사용자로 접속
--[3] with ADMIN option : 다른 사용자나 롤에게 해당 롤을 재부여할 수 있는 옵션('평등'한 관계)
SQL> GRANT role_test01 TO usertest02 with ADMIN option;

SQL> conn usertest02/1234
SQL> GRANT role_test01 TO usertest03 with ADMIN option;

SQL> conn usertest03/1234
SQL> REVOKE role_test01 from usertest02; --성공

SQL> conn usertest02/1234--접속 실패
--------------------------------------------------------------------------------------------------
--데이터 사전을 통해 '롤에 부여된 권한 정보'를 확인가능
select *
from role_sys_privs--'롤에 부여된 시스템 권한(privilege) 정보'
where role like '%TEST%';

SQL> conn usertest01/1234
SQL> select *
     from user_role_privs; --현재 사용자가 접근가능한 롤 권한 정보
     
SQL> select *
	 from dba_role_privs
	 where grantee='USERTEST03'; --사용자에게 부여한 role

--<'객체 권한'을 role에 부여하는 방법>
--[1] role 생성 : 반드시 DBA 권한이 있는 사용자만 롤 생성
SQL> conn system/1234
SQL> CREATE ROLE role_test02;

--[2] role에 권한부여 : ★객체의 소유자(hr)로 접속하여

SQL> conn hr/1234
SQL> GRANT select, insert, update(salary) ON employees TO role_test02;

--[3] role을 사용자 또는 다른 role에게 부여 : 반드시 DBA 권한이 있는 사용자만 롤 권한 부여
SQL> conn system/1234
SQL> GRANT role_test02 TO usertest01;

SQL> conn usertest01/1234
SQL> select * from hr.employees; --조회 가능
SQL> select * from user_role_privs; --현재 사용자가 접근가능한 롤 권한 정보
SQL> select * from role_tab_privs; --롤에 부여된 테이블 권한 정보

--<ROLE 권한 제거>
--DBA 권한이 있는 사용자만 롤 권한 제거 가능
SQL> conn system/1234
SQL> DROP ROLE role_test01;

--------------------------------------------------------------------------------------------------
--3. 동의어(Synonym)
--오라클 '객체(테이블, 뷰, 시퀀스, 프로시저)에 대한 별칭'을 말하며
--실질적으로 그 자체가 객체가 아니라 객체에 대한 직접적인 참조이다.

SQL> conn system/1234

create table sampletbl(
	memno varchar2(50)
);

insert into sampletbl values('9월은 시원하구나!');
insert into sampletbl values('최선을 다합시다.');
--생성한 테이블을 hr사용자에게 조회권한 부여
GRANT select ON sampletbl TO hr;

SQL> conn hr/1234
SQL> select * from system.sampletbl; --'사용자명.객체명'

--<동의어 사용 이유>
--1. 다른 사용자가 소유한 객체에 접근하기 위해서는 소유자로부터 접근 권한을 부여받아야 하고
--	 다른 사용자가 소유한 객체에 접근하기 위해서는 '사용자명.객체명'(=>긴 이름)
--	 동의어를 사용하면 '사용자명.객체명' (=>긴 이름) 대신 간단하게 '별칭을 부여한 짧은 이름'으로 SQL코딩을 단순화시킬 수 있다.

--2. 또한 객체를 참조하는 사용자의 객체를 감출 수 있어서 이에 대한 보안을 유지할 수 있다.
--	 동의어를 사용하는 사용자는 참조하는 객체에 대한 소유자, 객체이름을 모르고 동의어 이름만 알아도 사용할 수 있다.

--3. 만약에 실무에서 다른 사용자의 객체를 참조할 때, 동의어를 생성해서 사용하면 추후에 참조하는 객체명을 바꾸거나 이동할 경우
--	 그 객체를 사용하는 SQL문을 모두 고치는 것이 아니라 동의어만 다시 정의하면 되기 때문에 매우 편리하다.

--<동의어 종류>
--1. 전용 동의어 : '객체에 대한 접근권한을 부여받은 사용자'가 생성. 해당 사용자만 사용가능
SQL> conn hr/1234 --'객체에 대한 접근권한을 부여받은 사용자'로 접속
create synonym priv_sampletbl FOR system.sampletbl; --동의어 생성
select * from priv_sampletbl; --hr만 사용가능

--2. 공용 동의어 : 'DBA 권한을 가진 사용자만' 생성. 누구나 사용가능
SQL> conn system/1234
create PUBLIC synonym pub_sampletbl FOR system.sampletbl;

GRANT select on sampletbl TO usertest01;

SQL> conn usertest01/1234
SQL> select * from pub_sampletbl; --누구나 공용동의어 사용가능

SQL> conn hr/1234
SQL> select * from pub_sampletbl; --누구나 공용동의어 사용가능

--3. 동의어 제거 : 반드시 동의어를 정의한 사용자로 접속
SQL> conn hr/1234
SQL> drop synonym priv_sampletbl;--전용 동의어 삭제
select * from priv_sampletbl; --실패
select * from pub_sampletbl;


