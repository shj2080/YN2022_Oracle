--<북스-8장. 테이블 생성 수정 제거하기>
--데이터 정의어(DDL=Data Definition Language)
--1.CREATE : DB 객체 생성
--2.ALTER  : 		변경
--3.DROP   :		삭제
--4.TRUNCATE : 		내용(데이터) 및 저장 공간 삭제
--NCS교재 'SQL 활용' 10P

--※ RENAME : DB 객체 이름 변경

/*
★★  DELETE(DML:데이터 조작어)/ TRUNCATE, DROP(DDL:데이터 정의어) 명령어의 차이점
 (DELETE, TRUNCATE, DROP 명령어는 모두 삭제하는 명령어이지만 중요한 차이점이 있다.)
 
1. DELETE 명령어      : 데이터는 지워지지만 테이블 용량은 줄어 들지 않는다.
                                      원하는 데이터만 삭제할 수 있다.
                                      삭제 후 잘못 삭제한 것은 되돌릴 수 있다.(rollback)  

2. TRUNCATE  명령어 : 용량이 줄어 들고, index 등도 모두 삭제된다.
                                       테이블은 삭제하지는 않고, 데이터만 삭제한다.
                                       한꺼번에 다 지워야 한다. 
                                       삭제 후 절대 되돌릴 수 없다.   

3. DROP 명령어           : 테이블 전체를 삭제(테이블 공간과 객체를 삭제한다.)  
                                       삭제 후 절대 되돌릴 수 없다.  
*/

--1. 테이블 구조를 만드는 CREATE TABLE문(교재206p)
--테이블 생성하기 위해서는 테이블명 정의, 테이블을 구성하는 컬럼의 데이터 타입과 무결성 제약 조건 정의

--<'테이블명' 및 '컬럼명' 정의 규칙>
--문자(영어 대소문자)로 시작, 30자 이내
--문자(영어 대소문자), 숫자0~9, 특수문자(_ $ #)만 사용가능
--대소문자 구별없음, 소문자로 저장하려면 ''로 묶어줘야 함
--동일 사용자의 다른 객체의 이름과 중복X (예)SYSTEM이 만든 테이블명들은 다 달라야 함

--<다른 테이블 정보를 활용한 테이블 생성> NCS
--<서브 쿼리를 이용하여 다른 테이블로부터 복사하여 테이블 생성 방법>
--서브 쿼리문으로 부서 테이블의 구조와 데이터 복사 -> 새로운 테이블 생성
--1.create table 테이블명(컬럼명 명시O) : 지정한 컬럼수와 데이터 타입이 서브쿼리문의 검색된 컬럼과 일치
--2.create table 테이블명(컬럼명 명시X) : 서브쿼리의 컬럼명이 그대로 복사
--
--무결성 제약조건 : ★★ not NULL 조건만 복사,
--               기본키(=PK), 외래키(=FK)와 같은 무결성제약조건은 복사X
--               디폴트 옵션에서 정의한 값은 복사
--
--서브쿼리의 출력 결과가 테이블의 초기 데이터로 삽입됨

--(구조) create table AS SELECT문;
--1.create table 테이블명(컬럼명 명시O) 의 예
--[문제] 서브 쿼리문으로 부서 테이블의 구조와 데이터 복사하기(★☆ 제약조건은 복사안됨-NOT NULL 조건만 복사)
--[1]
select dno
from DEPARTMENT;

--[2]
create table dept1(dept_id)
AS
select dno
from DEPARTMENT;

select * from dept1;
--Run SQL ~ 열어 conn system/1234
--dept1의 테이블 구조 확인 => 데이터 타입과 데이터가 복사
desc dept1;

--2.create table 테이블명(컬럼명 명시X)
--[문제] 20번 부서의 소속 사원에 대한 정보를 포함한 dept2 테이블 생성하기
--[1]. 20번 부서의 소속 사원에 대한 정보 조회
select eno, ename, salary*12
from employee
where dno = 20;

--[2]오류발생 ORA-00998: must name this expression with a column alias
--★★ 서브쿼리문 내에 '산술식'에 대해 별칭 지정해야 함(=>별칭 없으면 오류)
create table dept2
AS
select eno, ename, salary*12 as "연봉"
from employee
where dno = 20;

--[3]
select * from dept2;
--Run SQL ~에서 dept2의 테이블 구조 확인 => 데이터 타입과 데이터가 복사
desc dept2;

--<서브쿼리의 데이터는 복사하지 않고 테이블 구조만 복사 방법>
--서브쿼리의 where절을 항상 거짓이 되는 조건 지정 : 조건에 맞는 데이터가 없어서 데이터 복사안됨
--where 0 = 1

--[문제] 부서테이블의 구조만 복사하여 dept3 생성하기
create table dept3
AS
select *
from department
where 0 = 1;--거짓 조건

select * from dept3; --데이터 구조만 복사되고 데이터는 복사안됨
--Run SQL ~에서 dept3의 테이블 구조 확인 => 데이터 구조만 복사(이때, 제약조건은 복사안됨)
desc dept3;
---------------------------------------------------------------------

--2. 테이블 구조를 변경하는 ALTER TABLE문
--2.2.1 열 추가(=컬럼 추가) : 추가된 열은 가장 마지막 위치에 생성(즉, 원하는 위치에 지정할 수 없음.)
ALTER TABLE 테이블명
ADD 컬럼명 데이터타입 [DEFAULT 값];

--[문제] 사원테이블 dept2에 날짜 타입을 가진 birth 열(컬럼) 추가
ALTER TABLE dept2
add birth date;--ADD 컬럼명 데이터타입[default 값]
--이 테이블에 기존에 추가한 데이터(행)가 있다면 추가한 열(birth)의 값은 null로 자동 입력됨
select * from dept2;

--[문제] 사원테이블 dept2에 문자타입의 email 열 추가
--(이때, 기존에 추가한 데이터(행)가 있다면 새로 추가한 열(email)의 값은 'test@test.com' 입력)
ALTER TABLE dept2
ADD email varchar2(50) default 'test@test.com' NOT NULL;
--이 테이블에 기존에 추가한 데이터(행)가 있다면 추가한 열(email)의 값은 default 값으로 자동 입력됨
select * from dept2;

--2.2 열(컬럼) 데이터 타입 변경
ALTER TABLE 테이블명
MODIFY 컬럼명 데이터타입 [DEFAULT 값];

--기존 컬럼에 데이터가 없는 경우 : 컬럼타입이나 크기 변경 자유
--						  (아직 INSERT한 데이터가 없으므로 자유롭게 변경가능함)
--				 있는 경우 : 타입 변경은 char와 varchar2만 허용하고
--						  변경할 컬럼의 크기가 저장된 데이터의 크기보다 같거나 클 경우에만 변경 가능함
--						  숫자 타입은 폭 또는 전체자릿수 늘릴 수 있음(예) number,
--						  	 	number(3)=number(전체자릿수3,0) : 소수1째자리에서 반올림하여 일의 자리(0)까지 표시
--								number(5,2)=number(전체자릿수5,소수2째자리) : 소수3째자리에서 반올림 123.45

--[문제] 테이블 dept2에서 사원이름의 컬럼크기를 변경
--[1] 먼저 dept2테이블 구조 확인 후 변경
desc dept2;

--[2] 변경
ALTER TABLE dept2
MODIFY ename varchar2(30); --컬럼크기 10 -> 30으로 크게 변경

--[3] 테이블 구조 확인
desc dept2;

--[문제] 테이블 dept2에서 email의 컬럼크기를 변경 50 -> 40 작게 변경
ALTER TABLE dept2
modify email varchar2(40);--변경됨:이유?기존의 저장된 데이터보다 큰 크기이므로

ALTER TABLE dept2
modify email varchar2(5);
--오류? ORA-01401: inserted value too large for column

--[문제] 테이블 dept2에서 email의 컬럼타입을 변경 varchar2(40) -> char(30)타입으로 변경
alter table dept2
modify email char(30);

--[문제] 테이블 dept2에서 email의 컬럼타입을 변경 : char(30) -> number(30)
alter table dept2
modify email number(30);
--오류? 타입변경은 char와 varchar2만 가능
--만약, char(30) -> number(30)로 변경해야 하는 경우 : 해당 컬럼의 값을 모두 지워야 변경 가능


--2.2.2 테이블 컬럼의 이름 변경
ALTER TABLE 테이블명
RENAME COLUMN 기존컬럼명 TO 새컬럼명;
--[문제] 테이블 DEPT2에서 사원이름의 컬럼명 변경(ename -> ename2)
ALTER TABLE dept2
RENAME COLUMN ename TO ename2;

desc dept2;

select * from dept2;

--[문제] 테이블 dept2에서 ename2에 컬럼 기본 값을 '기본'으로 지정
--[1]
alter table dept2
modify ename2 varchar2(50) default '기본' not null;
--[2]
desc dept2;

--2.3 열 삭제(=컬럼 삭제) : 2개 이상 컬럼이 존재하는 테이블에서만 열 삭제 가능
alter table 테이블명
DROP column 컬럼명;

--[문제] 테이블 dept2에서 사원이름 제거
alter table dept2
drop column ename2; 

--다시 같은 이름의 컬럼 추가(=열 추가) 가능
alter table dept2
ADD ename2 varchar2(10);

desc dept2;

--2.4 SET unused : 시스템의 요구가 적을 때 컬럼을 제거할 수 있도록 하나 이상의 컬럼을 unused로 표시
--실제로 제거되지는 않음
--그래서 DROP 명령 실행으로 컬럼 제거하는 것보다 응답시간이 빨라짐
ALTER TABLE 테이블명
SET unused(컬럼명);

--데이터가 존재하는 경우에는 삭제된 것처럼 처리되기 때문에 select절로 조회가 불가능
--describe 문으로도 표시되지 않음
desc dept2; --테이블 구조 확인

--SET unused 사용하는 이유?
--1. 사용자에게 조회되지 않게 하기 위해
--2. unused로 미사용 상태로 표시한 후 나중에 한꺼번에 drop으로 제거하기 위해
--	 운영 중에 컬럼을 삭제하는 것은 시간이 오래 걸릴 수 있으므로 unused로 표시해두고 나중에 한꺼번에 drop으로 제거


--[문제] 테이블 dept2에서 "연봉"을 unused 상태로 만들기
ALTER TABLE dept2
SET unused("연봉");

select * from dept2;

--[문제] unused로 표시된 모든 컬럼을 한꺼번에 제거
alter table dept2
drop unused columns; --s:복수

--제거 후 다시 같은 이름의 컬럼 추가
alter table dept2
ADD "연봉" number;

desc dept2;
select * from dept2;

--연봉을 null 대신 0으로 표시
select eno, birth, email, ename2,
NVL("연봉", 0) as "연봉"
from dept2;

-----------------------------------------------------
--3. 테이블명 변경
--방법-1 : RENAME 이전 테이블명 TO 새테이블명;
rename dept2 to emp;

--방법-2 : alter table 이전 테이블명 RENAME TO 새테이블명;
alter table emp
RENAME to emp2;

--4. 테이블 삭제
drop table 테이블명;

--★★ [department 테이블 삭제하는 방법-1]
--삭제할 테이블의 기본키(=PK:unique + NOT NULL)나 고유키(unique)를 다른 테이블에서 참조하고 있는 경우에는 삭제가 불가능함
--그래서, '참조하는 테이블(=자식 테이블)을 먼저 제거' 후 부모 테이블 제거 가능
drop table department; --실패

drop table employee;	--사원테이블부터 먼저 삭제 후
drop table department;--삭제 성공(부서테이블의 dno를 사원테이블에서 참조하고 있으므로...)

--★★ [department 테이블 삭제하는 방법-2]
drop table department; --실패 원인?부서테이블의 dno를 사원테이블에서 참조하고 있으므로...
--그러면, 부서테이블을 삭제할 때 사원 테이블의 '참조키 제약조건까지 함께 제거'
drop table department cascade constraints;

select table_name, constraint_name, constraint_type--P(=PK:기본키), R(=FK=참조키)
from user_constraints
where table_name in ('EMPLOYEE', 'DEPARTMENT');--table_name : 대문자로 표시되므로
--where lower(table_name) in ('employee', 'department');
--where table_name in (upper('employee'), upper('department'));

--5. 테이블의 내용 삭제(=테이블의 모든 데이터만 삭제)
TRUNCATE TABLE 테이블명;
--테이블 구조는 유지, 테이블에 생성된 제약조건과 연관된 index, view, 동의어는 유지됨

select * from emp2;
--테스트위해 "연봉" 제거 후 salary 추가
alter table emp2
drop column "연봉";

alter table emp2
add salary number(7,2);

insert into emp2 values(1,'2022-07-19', default, 'kim', 2800);
select * from emp2;

TRUNCATE TABLE emp2; --"데이터만 제거"
select * from emp2; --확인

desc emp2; --확인=>테이블 구조 제거안됨
--제약조건도 확인=>제약조건도 제거안됨
select table_name, constraint_name, constraint_type--P(=PK:기본키), R(=FK=참조키), C(=NOT NUL)
from user_constraints
where table_name in ('EMP2');

--6. 데이터 사전 : 사용자와 DB 자원을 효율적으로 관리 위해 다양한 정보를 저장하는 시스템 테이블 집합
--사용자가 테이블을 생성하거나 사용자를 변경하는 등의 작업을 할 때
--'DB 서버'에 의해 자동 갱신되는 테이블
--사용자가 직접 수정X, 삭제X -> '읽기전용 뷰'로 사용자에게 정보만 제공함(즉, select문만 허용)

/* NCS 모듈
데이터 사전(Data Dictionary)에는 데이터베이스의 데이터(사용자 데이터)를 제외한 
모든 정보(DBMS가 관리하는 데이터)가 있다. 데이터 사전의 내용을 변경하는 권한
은 시스템 사용자(데이터베이스 관리자: DBA)가 가진다.
반면 일반 사용자에게는 단순 조회만 가능한 읽기 전용 테이블 형태가 제공된다.
데이터를 제외한(데이터를 구성하는) 모든 정보라는 점은 데이터의 데이터를 말한다. 
따라서 '데이터 사전은 메타 데이터(Meta data)로 구성되어 있음'을 의미한다.
 */

--※ 객체 : 테이블, 시퀀스, 인덱스, 뷰 등

--6.1 USER_데이터 사전 : 'USER_로 시작~S(복수)'로 끝남
/* 현재 자신의 계정이 소유한 객체 조회 가능 */
-- 사용자와 가장 밀접하게 관련된 뷰로
-- 자신이 생성한 테이블, ,시퀀스 , 뷰, 인덱스, 동의어 등의 객체나 해당 사용자에게 권한 정보 제공
--(1) USER_TABLES : 사용자가 소유한 '테이블'에 대한 정보 조회
select *
from USER_TABLES; --사용자(system)가 소유한 '테이블' 정보

select *
from USER_sequences;--사용자(system)가 소유한 '시퀀스' 정보

select *
from USER_indexes;--사용자(system)가 소유한 '인덱스' 정보

select *
from USER_views;--사용자(system)가 소유한 '뷰' 정보

--USER_CONSTRAINTS : 자기 계정의 '제약 조건' 확인
select table_name, constraint_name, constraint_type--P(=PK:기본키), R(=FK=참조키), C(=NOT NUL), U(=Unique)
from USER_constraints--사용자(system)가 소유한 '제약 조건' 정보
where table_name in ('EMPLOYEE', 'DEPARTMENT'); --★주의 : 테이블명 '대문자로 검색'

--USER_TAB_COLUMNS 자기 계정의 테이블 구성 칼럼 목록 확인
select *
from USER_TAB_COLUMNS;

--USER_TAB_COMMENTS 자기 계정의 테이블 코멘트 확인
select *
from USER_TAB_COMMENTS;

--6.2 ALL_데이터 사전
/*자신의 계정으로 접근할 수 있는 객체와 다른 계정에 접근 가능한 권한을 가진 모든 객체 조회 가능*/

--(1). ALL_TABLES : 권한 있는 테이블 목록 확인
--owner : 조회 중인 객체가 누구의 소유인지 확인
--사용자 : system 일 때 - 결과 500 row (SYS와 SYSTEM과 사용자(HR) 포함된 상태로 결과가 나옴)
--	   : hr		일 때 - 결과 79 row (사용자(HR)과 SYS와 SYSTEM 포함한 다른 사용자들 결과로 나옴)
select owner, table_name
from ALL_tables;
--where owner in ('SYSTEM') OR table_name in('EMPLOYEE', 'DEPARTMENT');
--where owner in ('SYSTEM') AND table_name in('EMPLOYEE', 'DEPARTMENT');

select * --owner, table_name
from ALL_tables
where owner IN ('HR');

--(2).ALL_CONSTRAINTS : 권한 있는 제약 조건 확인
select *
from ALL_CONSTRAINTS;

--(3). DBA_데이터 사전 : 데이터베이스의 모든 개체 조회 가능(DBA_는 시스템 접근 권한)
--시스템 관리와 관련된 뷰, DBA나 시스템 권한을 가진 사용자만 접근 가능
--system 계정으로 접속하여 DBA_데이터 사전을 보는데,
--이 때 system이 DBA_데이터 사전을 볼 수 있는 권한을 가졌으면 조회가 가능함

--(1) DBA_TABLES : 모든 테이블 목록 확인
select *
from DBA_tables
where owner IN ('HR'); --결과 나옴(이유? system은 DBA_데이터사전을 조회할 권한이 있어서 접근 가능)

--system접속을 끊고 hr계정으로 접속
select *
from DBA_tables
where owner IN ('HR');--결과 안나옴(이유? hr은 DBA_데이터사전을 조회할 권한이 없어서 접근 불가능)

--<8장 혼자해보기>----------------------------------------
--1. 다음 표에 명시된 대로 DEPT 테이블을 생성하시오.
--컬럼명  데이터 타입  크기
--dno   number   2
--danme varchar2 14
--loc   varchar2 13

create table dept(
	 dno number(2),
	 dname varchar2(14),
	 loc varchar2(13)
);

--2. 다음 표에 명시된 대로 EMP 테이블을 생성하시오.
--컬럼명  데이터 타입  크기
--eno   number   4
--ename varchar2 10
--dno   number   2
create table emp(
	eno number(4),
	ename varchar2(10),
	dno number(2)
);

--3. 긴 이름을 저장할 수 있도록 EMP 테이블을 수정하시오.(ename 컬럼의 크기)
--컬럼명  데이터 타입  크기
--eno   number   4
--ename varchar2 25(크기가 수정된 부분)
--dno   number   2
alter table emp
modify ename varchar2(25);

--4. EMPLOYEE 테이블을 복사해서 EMPLOYEE2란 이름의 테이블을 생성하되 
--사원번호, 이름, 급여, 부서 번호 컬럼만 복사하고 새로 생성된 테이블의 컬럼명은
--각각 EMP_ID, NAME, SAL, DEPT_ID로 지정하시오.

--[방법-1]
create table employee2(emp_id, name, sal, dept_id) --4개
AS
select eno, ename, salary, dno--4개
from employee;

--[방법-2]
--[1]
create table employee2
as
select eno, ename, salary, dno--컬럼명 그대로 복사
from employee;

select * from employee2;--컬럼명 확인

--[2] 컬럼명 수정
alter table employee2
rename column eno to emp_id;

alter table employee2
rename column ename to name;

alter table employee2
rename column salary to sal;

alter table employee2
rename column dno to dept_id;

select * from employee2; --다시 확인

--5. EMP 테이블 삭제하시오.
drop table emp;

--6. EMPLOYEE2란 이름을 EMP로 변경하시오.
--[방법-1]
rename employee2 to emp;
--[방법-2]
alter table employee2 rename to EMP;

--7. DEPT 테이블에서 DNAME 컬럼 제거하시오.
alter table dept
drop column dname;

--8. DEPT 테이블에서 LOC 컬럼을 UNUESD로 표시하시오.
alter table dept
set unused(loc);

select * from dept;

--9. DEPT 테이블에서 UNUSED 컬럼을 모두 제거하시오.
alter table dept
drop unused columns;

