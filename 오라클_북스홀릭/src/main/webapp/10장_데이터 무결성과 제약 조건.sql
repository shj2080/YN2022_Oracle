--<북스 10장. 데이터 무결성과 제약 조건>

--1. 제약조건
--'데이터 무결성' 제약조건 : 테이블에 유효하지 않은(부적절한) 데이터가 입력되는 것을 방지하기 위해
--테이블 생성할 때 각 컬럼에 대해 정의하는 여러 규칙들

--<테이블 생성에 사용되는 제약 조건(5가지)>---------------------------------------------------------------------------
--1. PRIMARY KEY(기본키=PK) : not null제약조건 - null값 허용X
--							unique 제약조건 - 중복X -> 고유키(암시적 index 자동 생성)

--2. FOREIGN KEY(외래키=참조키=FK) : 참조되는 테이블에 컬럼 값이 반드시 PK or UNIQUE으로 존재
--								 (예) 사원테이블(자식) dno(FK) -> 부서테이블(부모) dno(PK or unique)
--								 ※ 참조 무결성 제약조건 : 테이블 사이의 '주종 관계를 설정'하기 위한 제약조건
--'어느 테이블부터 먼저 정의되어야 하는가? : 먼저, 부모 테이블부터 정의하고 -> 자식 테이블 정의
-- 참조 무결성이 위배되는 상황 발생 시, 다음 옵션으로 처리 가능
-- (CASCADE, NO ACTION, SET NULL, SET DEFAULT)

--3. UNIQUE : 중복X -> 유일한 값=고유한 값 -> 고유키(암시적 index 자동 생성)
--			 ★★ null은 unique제약조건에 위반되지 않으므로 'null값을 허용'

--4. NOT NULL : null값 허용 안 함

--5. CHECK : '저장가능한 데이터 범위나 조건 지정'하여 (예) CHECK(0 < salary  && salary < 1000000)
--			 -> 설정된 값 이외의 값이 들어오면 오류
-------------------------------------------------------------------------------------------------------------
--default 정의 : 아무런 값을 입력하지 않았을 때 default값이 입력됨

--제약조건 : 컬럼레벨 - 하나의 컬럼에 대해 모든 제약 조건을 정의
--		   테이블레벨 - 'not null 제외'한 나머지 제약조건을 정의

--<제약조건이름 직접 지정할 때 형식>
--constraint 제약조건이름
--constraint 테이블명_컬럼명_제약조건유형
--제약조건이름 지정하지 않으면 자동 생성됨

--(1) 제약조건이름 지정하지 않으면 자동 생성됨
drop table customer2;

create table customer2(
	id varchar2(20) unique,
	pwd varchar2(20) not null,
	name varchar2(20) not null,
	phone varchar2(30),
	address varchar2(100)
);

--USER_CONSTRAINTS : 자기 계정의 '제약 조건' 확인
-- constraint_type : P(=PK:기본키), R(=FK=참조키), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints--사용자(system)가 소유한 '제약 조건' 정보
where table_name in ('CUSTOMER2'); --★주의 : 테이블명 '대문자로 검색'
--where LOWER(table_name) in ('customer2');
--where table_name in ( UPPER('customer2') );

-------------------------------------------------------------------------------------------------------------
--(2) 제약조건이름 지정 : constraint 테이블명_컬럼명_제약조건유형
drop table customer2;

create table customer2(
	id varchar2(20) constraint customer2_id_uq unique, --컬럼레벨
	pwd varchar2(20) constraint customer2_pwd_nn not null,
	name varchar2(20) constraint customer2_name_nn not null,
	phone varchar2(30),
	address varchar2(100)
);

--USER_CONSTRAINTS : 자기 계정의 '제약 조건' 확인
-- constraint_type : P(=PK:기본키), R(=FK=참조키), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints--사용자(system)가 소유한 '제약 조건' 정보
where table_name in ('CUSTOMER2'); --★주의 : 테이블명 '대문자로 검색'

--(3) PK를 컬럼레벨
drop table customer2;

create table customer2(
	id varchar2(20) constraint customer2_id_pk PRIMARY KEY,
	pwd varchar2(20) constraint customer2_pwd_nn not null,
	name varchar2(20) constraint customer2_name_nn not null,
	phone varchar2(30),
	address varchar2(100)
);

--USER_CONSTRAINTS : 자기 계정의 '제약 조건' 확인
-- constraint_type : P(=PK:기본키), R(=FK=참조키), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints--사용자(system)가 소유한 '제약 조건' 정보
where table_name in ('CUSTOMER2'); --★주의 : 테이블명 '대문자로 검색'

--(4) PK를 테이블 레벨
drop table customer2;

create table customer2(
	id varchar2(20),
	pwd varchar2(20) constraint customer2_pwd_nn not null,
	name varchar2(20) constraint customer2_name_nn not null,
	phone varchar2(30),
	address varchar2(100),
	
	--테이블 레벨
	--constraint customer2_id_pk PRIMARY KEY(id)
	constraint customer2_id_name_pk PRIMARY KEY(id , name)--"기본키가 2개 이상"일 때 테이블 레벨 사용
);

--USER_CONSTRAINTS : 자기 계정의 '제약 조건' 확인
--constraint_type : P(=PK:기본키), R(=FK=참조키), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints--사용자(system)가 소유한 '제약 조건' 정보
where table_name in ('CUSTOMER2'); --★주의 : 테이블명 '대문자로 검색'


--1.1 NOT NULL 제약조건 : 컬럼 레벨로만 정의 : (1)적용시
insert into customer2 values(null, null, null, '010-1111-1111', '대구 달서구'); --오류

--1.2 unique 제약조건 : 유일한 값만 허용(단, null 허용) : (2)적용시
insert into customer2 values('a1234', '1234', '홍길동', '010-2222-2222', '대구 북구');
insert into customer2 values(null, '5678', '이순순', '010-3333-3333', '대구 서구');

--1.3 데이터 구분을 위한 Primary Key(=PK=기본키) 제약조건
--테이블의 모든 row를 구별하기 위한 식별자 -> index번호 자동 생성됨

--1.4 '참조 무결성'을 위한 FOREIGN KEY(FK=참조키=외래키) 제약조건
--사원 테이블의 부서번호는 언제나 부서테이블을 참조 가능 : 참조 무결성
--(예) 자식:사원테이블 dno(FK) -> 부모:부서테이블 dno(반드시 PK or unique)

select * from DEPARTMENT; --참조되는 부모테이블

desc employee;--테이블 구조 확인
--USER_CONSTRAINTS : 자기 계정의 '제약 조건' 확인
--constraint_type : P(=PK:기본키), R(=FK=참조키), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints
where table_name in ('EMPLOYEE', 'DEPARTMENT');

--<★★ 삽입(자식인 사원테이블에서)하는 방법>
insert into employee(eno, ename, dno) values(8000, '홍길동', 50);--참조하는 자식
--부서번호 50 입력하면
--ORA-02291: integrity constraint (SYSTEM.SYS_C007011) violated - parent key not found
--'참조무결성 제약조건 위배, 부모키를 발견하지 못했다.'는 오류메시지

--이유 : 사원테이블에서 사원의 정보를 새롭게 추가할 경우
--		사원테이블의 부서번호는 부서테이블의 저장된 부서번호 중 하나와 일치
--		or NULL 만 입력 가능함(단, null 허용하면) - 참조 무결성 제약조건

--삽입 방법-1
insert into employee(eno, ename, dno) values(8000, '홍길동', '');-- ''(null) 단, dno가 null 허용하면

select * from employee where eno = 8000;

--삽입 방법-2 : 제약조건을 삭제하지 않고 일시적으로 '비활성화(=disable)' -> 데이터 처리 -> '다시 활성화(=enable)'
--먼저, USER_CONSTRAINTS 데이터 사전을 이용하여 constraint_name과 constraint_type, status 조회
select constraint_name, constraint_type, status
from USER_constraints
where table_name in ('EMPLOYEE');

--[1] 참조키 제약조건 '비활성화'
ALTER TABLE employee
disable constraint SYS_C007011; --constraint_type이 R(=FK)

select constraint_name, constraint_type, status
from USER_constraints
where table_name in ('EMPLOYEE');

--[2] 자식에서 삽입
insert into employee(eno, ename, dno) values(9000, '홍길동', 50);

--[3] 다시 활성화
ALTER TABLE employee
enable constraint SYS_C007011; --constraint_type이 R(=FK)
--오류 : ORA-02298: cannot validate (SYSTEM.SYS_C007011) - parent keys not found

--오류 해결 방법-1(즉, 다시 활성화시키기 위해 dno가 50인 row 삭제하거나 dno를 ''로 수정)
delete from employee where dno = 50;
update employee set dno = '' where dno = 50;--''(null) 허용 시 사용가능
--다시 활성화
ALTER TABLE employee
enable constraint SYS_C007011;
--활성화 상태 확인
select constraint_name, constraint_type, status
from USER_constraints
where constraint_name in ('SYS_C007011');

--오류 해결 방법-2 : 이 때, 이미 여러 row를 추가했다면 찾아서 삭제 또는 수정
--[1]
select dno --{10,20,30,50,null}
from department;

--[2]
select dno --{10,20,30}
from employee NATURAL JOIN department;--dno로 자연조인

--[3]
select dno --{10,20,30,50,null} - {10,20,30} = {50, null}
from employee
MINUS
select dno
from employee NATURAL JOIN department;

/*
select eno
from employee e
where NOT EXISTS (select dno
			 from department d
			 where e.dno = d.dno);			 
*/		 

--[4-1]삭제 : dno가 50인 사원을 찾아서 삭제
delete from employee
where dno=50;
--삭제 전, dno가 50인 사원을 미리 백업시킴

--[4-2]수정 : dno가 50인 사원을 찾아서 ''(null)로 수정 후 향후 부서가 정해지면 다시 해당부서번호로 수정
UPDATE employee
set dno = ''
where dno=50;

UPDATE employee
set dno = 40 --정해진 부서번호
where dno is null;

--[삽입 방법-2 정리] : 제약조건 잠시 비활성화시켜 원하는 데이터를 삽입하더라도 다시 제약조건 활성화시키면 오류가 발생하여
--				   삽입한 데이터를 삭제하거나 수정해야 하는 번거로운 일이 발생함

--<★★ 삭제(부모인 부서 테이블에서)하는 방법>
drop table department;
--오류 : ORA-02449: unique/primary keys in table referenced by foreign keys
--자식인 EMPLOYEE테이블에서 참조하는 상황에서는 삭제 안됨

--1. 부모 테이블부터 생성 : 실습위해 department 테이블 구조와 데이터 복사하여 department2테이블 생성
--★ 주의 : 제약조건은 복사안됨
--DROP table department2;--오류(?부모 테이블로 참조되고 있어서)
--DROP table department2 CASCADE constraints; --그래서 사원테이블의 참조키 제약조건을 함께 제거

create table department2--★ 주의 : 제약조건은 복사안됨
AS
select * from department;

----제역조건 확인해보면 결과 없음
select constraint_name, constraint_type, status
from USER_constraints
where table_name in ('DEPARTMENT2');

------PRIMARY KEY 제약조건 추가하기(단, 제약조건명을 직접 만들어 추가) : 제약조건은 복사안되므로
ALTER TABLE department2
ADD constraint department2_dno_pk primary key(dno);

----제역조건 확인해보면
select constraint_name, constraint_type, status
from USER_constraints
where table_name in ('DEPARTMENT2');

--2. 자식 테이블 생성
drop table emp_second;

create table emp_second(
	eno number(4) constraint emp_second_eno_pk PRIMARY KEY,
	ename varchar2(10),
	job varchar2(9),
	salary number(7,2) default 1000 CHECK(salary > 0),
	dno number(2), --constraint emp_second_dno_fk FOREIGN KEY references department2 ON DELETE CASCADE --컬럼레벨
	
	--'테이블 레벨'에서만 가능 : ON DELETE 옵션
	constraint emp_second_dno_fk FOREIGN KEY(dno) references department2(dno)
	ON DELETE CASCADE
);

/*
== ON DELETE 뒤에 ==
1. no action(기본값) : 부모 테이블 기본키 값을 자식테이블에서 참조하고 있으면 부모 테이블의 행에 대한 삭제 불가
	※ restrict(MySQL에서 기본값, MySQL에서 restrict는 no action과 같은 의미로 사용됨)
	
	※ 오라클에서는 restrict와 no action은 약간의 차이가 있음
	
2. cascade : 참조되는 '부모 테이블의 기본키 값이 삭제'되면 연쇄적으로 '자식 테이블이 참조하는 값 역시 삭제'
			 부서 테이블의 부서번호 40 삭제할 때 사원 테이블의 부서번호 40도 삭제하여 '참조 무결성 유지함'
			 
3. set null : 참조되는 '부모 테이블의 기본키 값이 삭제'되면 이 키를 참조하는 '자식 테이블의 참조하는 값들은 NULL값으로 설정'
			 (단, null 허용한 경우)
			 
4. set default : 자식 테이블에서 미리 default값을 설정 
				참조되는 '부모 테이블의 기본키 값이 삭제'되면 이 키를 참조하는 '자식 테이블의 참조하는 값들은 default값으로 설정'
				※ 이 제약조건이 실행하려면 모든 참조키(=FK) 컬럼(사원테이블의 dno)에 default값 정의가 있어야 함
				컬럼이 null을 허용하고 명시적 DEFAULT값이 설정되어 있지 않은 경우 null은 해당 컬럼의 암시적 DEFAULT값이 됨

 */

--※참고 : 부서테이블 삭제시 부서테이블을 참조하는 "사원테이블의 참조키 제약조건"을 함께 제거
--drop table DEPARTMENT2 cascade constraints;--먼저, 사원테이블의 참조키 제약조건 제거 후 부서테이블 제거됨

insert into emp_second values(1, '김', '영업', null, 30);
insert into emp_second values(2, '이', '조사', 2000, 20);
insert into emp_second values(3, '박', '운영', 3000, 40);
insert into emp_second values(4, '조', '상담', 3000, 20);

--1.5 check 제약조건 : 값의 범위나 조건 지정
--currval, nextval, rownum 사용불가
--sysdate 함수 사용불가

--CHECK(salary > 0)
insert into emp_second values(5, '강', '상담', -4000, 20);
--오류? ORA-02290: check constraint (SYSTEM.SYS_C007090) violated
insert into emp_second values(5, '강', '상담', 4000, 20);

--1.6 DEFAULT 정의
--default 값 넣는 2가지 방법
--salary는 DEFAULT 1000
insert into emp_second(eno, ename, job, dno) values(6, '권', '인사', 30);--생략된 salary는 1000 입력됨
insert into emp_second values(6, '권', '인사', default, 30);--default 대신 1000 입력됨

select * from emp_second;
select * from department2;

--지금부터 부모인 부서테이블에서 dno=20 인 row 삭제하면 자식테이블인 사원테이블에서 dno=20인 row도 함께 삭제됨.
--이유? FOREIGN KEY(dno) references department2(dno) ON DELETE CASCADE
delete from department2 where dno = 20;

select * from department2; --부모에서 삭제하면
select * from emp_second;  --자식에서도 삭제됨

delete from department where dno = 20;
--오류 : ORA-02292: integrity constraint (SYSTEM.SYS_C007011) violated - child record found
--이유?자식에서 참조하고 있으면 부모의 레코드(=row=행)를 삭제불가(no action (=기본값))

--테이블 전체(테이블 구조+데이터) 제거
drop table department2; --실패?현재 사원테이블의 참조키로 참조하고 있으므로 테이블 전체 제거안됨

--테이블 데이터만 삭제(테이블 구조는 남기고)
truncate table department2;
delete from department2; --rollback 가능하므로(혹시 잘못 삭제 후 다시 복원가능)

select * from department2;

---------------------------------------------------------------------------------------------------------
--2. 제약 조건 변경하기
--2.1 제약 조건 추가 : ALTER table 테이블명 + ADD constraint 제약조건명 + 제약조건
--단, 'null 무결성 제약조건'은 alter table 테이블명 + ADD~로 추가하지 못함
--						 alter table 테이블명 + modify~로 null 상태로 변경 가능
--	  'default 정의할 때'도 alter table 테이블명 + modify~로

--[test 위해]
--drop table dept_copy;
create table dept_copy
AS
select * from department; --제약조건 복사안됨

--drop table emp_copy;
create table emp_copy
AS
select * from employee;

--user_제약조건 데이터 사전을 조회하여 제약조건 확인하기
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPARTMENT', 'EMPLOYEE', 'DEPT_COPY', 'EMP_COPY'); --반드시 '대문자'

--(예1)기본키 제약조건 추가하기
alter table emp_copy
add constraint emp_copy_eno_pk primary key(eno);

alter table dept_copy
add constraint dept_copy_dno_pk primary key(dno);

--기본키 제약조건이 추가되었는지 확인하기(constraint_type은 P)
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --반드시 '대문자'


--(예2)'외래키=참조키' 제약조건 추가하기
alter table emp_copy
add constraint emp_copy_dno_fk foreign key(dno) references dept_copy(dno);
--[ON DELETE 옵션은 필요시 추가]
--ON DELETE cascade | ON DELETE set null(단, emp_copy테이블의 dno가 null값을 허용할 때)
--ON DELETE set default(단, emp_copy테이블의 dno가 default값을 정의. default값을 정의안하고 null을 허용한다면 null이 default로 대체됨)

--(예3) NOT NULL 제약조건 추가하기(※주의 : ADD 대신 MODIFY변경하기)
alter table emp_copy
modify ename constraint emp_copy_ename_nn NOT NULL;

--'NOT NULL' 제약조건이 추가되었는지 확인하기(constraint_type은 C)
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --반드시 '대문자'

--(예4) DEFAULT 정의 추가하기(※주의 : ADD 대신 MODIFY변경하기)
--★★CONSTRAINT 제약조건명 입력하면 안됨. (이유? DEFAULT는 '제약조건이 아니라' 정의이므로)
alter table emp_copy
modify salary constraint emp_copy_salary_d DEFAULT 500;
--오류?ORA-02253: constraint specification not allowed here

alter table emp_copy
modify salary DEFAULT 500;--성공

--'DEFAULT 정의' 추가되었는지 확인하기 => 제약조건이 아니므로 결과에 없음
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --반드시 '대문자'

--(예5) CHECK 제약조건 추가하기
select salary from emp_copy where salary <= 1000; --800 950 (CHECK 조건에 위배되는 데이터가 있는지 확인)

alter table emp_copy
ADD constraint emp_copy_salary_check CHECK(salary > 1000);
--실패? ORA-02293: cannot validate (SYSTEM.EMP_COPY_SALARY_CHECK) - check constraint violated
--실패이유?이미 insert한 데이터 중 salary가 1000보다 작은 급여가 있으므로 '조건에 위배되어 오류 발생'

---select salary from emp_copy where salary <= 1000; --800 950 (CHECK 조건에 위배되는 데이터가 있는지 확인)

alter table emp_copy
ADD constraint emp_copy_salary_check CHECK(500 <= salary AND salary < 10000);

alter table dept_copy
ADD constraint dept_copy_dno_check CHECK(dno IN(10,20,30,40,50));--반드시 dno는 이 5가지 값 중 하나만 insert가능

--'CHECK' 제약조건이 추가되었는지 확인하기(constraint_type은 C)
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --반드시 '대문자'

---------------------------------------------------------------------------------------------------------
--2.2 제약조건 제거
--'외래키(=참조키) 제약조건'에 지정되어 있는 부모 테이블의 기본키 제약조건을 제거하려면
--자식테이블의 '참조 무결성 제약조건을 먼저 제거'한 후 제거하거나
--CASCADE 옵션 사용 : 제거하려는 컬럼을 참조하는 참조 무결성 제약조건도 함께 제거

--(예1) 먼저, 부모 테이블의 기본키 제약조건 제거 => 실패
alter table dept_copy
drop primary key;
--실패?ORA-02273: this unique/primary key is referenced by some foreign keys
--실패이유? 자식테이블에서 참조하고 있으므로...

--[해결법]
alter table dept_copy
drop primary key CASCADE;
--성공?제거하려는 '기본키제약조건을 가진 컬럼'을 참조하는 '참조 무결성 제약조건'도 함께 제거되므로

--[제거되었는지 확인] DEPT_COPY테이블에서는 P가 없고 EMP_COPY테이블에서는 R이 없어짐
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --반드시 '대문자'

--(예2) NOT NULL 제약조건 제거
alter table emp_copy
DROP CONSTRAINT emp_copy_ename_nn;

--[제거되었는지 확인]
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --반드시 '대문자'

---------------------------------------------------------------------------------------------------------

--3. 제약조건 활성화 및 비활성화
--alter table 테이블명 + DISABLE constraint 제약조건명 [cascade];
--제약 조건을 삭제하지 않고 일시적으로 비활성화
--alter table 테이블명 + ENABLE constraint 제약조건명 [cascade];
--비활성화된 제약 조건을 활성화
--※ 위 내용 참조하기

---------------------------------------------------------------------------------------------------------

--<10장 데이터 무결성과 제약조건-혼자 해보기>
--1.employee테이블의 구조만 복사하여 emp_sample 테이블 생성
--사원 테이블의 사원번호 컬럼에 테이블 레벨로 primary key 제약조건을 지정하되
--제약조건명은 my_emp_pk로 지정
--[1] 테이블 구조만 가져와서 테이블 생성
create table emp_sample
AS
select * from employee
where 1=0; --조건을 무조건 거짓 -> 데이터 구조만 복사

--[2] 제약조건 추가
alter table emp_sample
add constraint my_emp_pk primary key(eno);

--2.부서테이블의 부서번호 컬럼에 테이블 레벨로 primary key 제약조건 지정하되
--제약조건명은 my_dept_pk로 지정
create table dept_sample
AS
select * from DEPARTMENT
where 1=0;

alter table dept_sample
add constraint my_dept_pk primary key(dno);

--3.사원테이블의 부서번호 컬럼에 존재하지 않는 부서의 사원이 배정되지 않도록
--외래키(=참조키) 제약조건(=참조 무결성)을 지정하되
--제약 조건 이름은 my_emp_dept_fk로 지정
--[1] 제약조건 추가
alter table emp_sample
add constraint my_emp_dept_fk foreign key(dno) references dept_sample(dno);
--오류 발생 안한 이유 : 자식 테이블에 데이터 없음(즉, 자식에서 부모를 참조하는 데이터가 없으므로..)
--반드시 부모의 데이터를 먼저 insert한 후 -> 자식이 참조하는 데이터 insert하기

--4.사원 테이블의 커미션 컬럼에 0보다 큰 값만 입력할 수 있도록 제약조건 지정
--[1] 제약조건 추가
alter table emp_sample
add constraint emp_sample_commission_min CHECK(commission > 0);



