--<10장 데이터 무결성과 제약조건-혼자 해보기>
--1.employee테이블의 구조만 복사하여 emp_sample 테이블 생성
--사원 테이블의 사원번호 컬럼에 테이블 레벨로 primary key 제약조건을 지정하되
--제약조건명은 my_emp_pk로 지정
--[1] 테이블 구조만 가져와서 테이블 생성
create table emp_sample
AS
select * from employee
where 1=0;

--[2] 제약조건 추가
alter table emp_sample
add constraint my_emp_pk primary key(eno);

--[3] 제약조건 확인
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('EMP_SAMPLE');
--2.부서테이블의 부서번호 컬럼에 테이블 레벨로 primary key 제약조건 지정하되
--제약조건명은 my_dept_pk로 지정
/* 부서테이블의 복사본 생성
create table dept_sample
AS
select * from DEPARTMENT
where 1=0;
*/

alter table dept_sample
add constraint my_dept_pk primary key(dno);


--3.사원테이블의 부서번호 컬럼에 존재하지 않는 부서의 사원이 배정되지 않도록
--외래키(=참조키) 제약조건(=참조 무결성)을 지정하되
--제약 조건 이름은 my_emp_dept_fk로 지정
--[1] 제약조건 추가
alter table emp_sample
add constraint my_emp_dept_fk foreign key(dno) references dept_sample(dno);

--[2] 제약조건 확인
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('EMP_SAMPLE', 'DEPT_SAMPLE');


--4.사원 테이블의 커미션 컬럼에 0보다 큰 값만 입력할 수 있도록 제약조건 지정
--[1] 제약조건 추가
alter table emp_sample
add constraint 제약조건명 check(commission > 0);

ALTER TABLE emp_sample
modify commission CHECK(commission > 0);

--[2] 제약조건 확인
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('EMP_SAMPLE', 'DEPT_SAMPLE');

