--<9장 데이터 조작과 트랜잭션-혼자 해보기>-----------------------------
/*
 * 1.EMPLOYEE 테이블의 구조만 복사하여 EMP_INSERT란 이름의 빈 테이블을 만드시오.
 */
create table emp_insert
AS
select *
from employee
where 0=1; --무조건 거짓이 되는 조건

select * from emp_insert;
/*
 * 2.본인을 EMP_INSERT 테이블에 추가하되 SYSDATE를 이용하여 입사일을 오늘로 입력하시오.
 */
desc emp_insert; --테이블의 구조와 각 컬럼의 데이터 타입 확인 후

--[방법-1]
insert into emp_insert values(7499,'ALLEN','SALESMAN', 7698,to_date('20-2-1981', 'dd-mm-yyyy'),1600,300,30);

--[방법-2]
insert into emp_insert(eno, ename, hiredate) values(1000, '송호진', sysdate);

select * from emp_insert;
/*
 * 3.EMP_INSERT 테이블에 옆 사람을 추가하되 TO_DATE 함수를 이용하여 입사일을 어제로 입력하시오.
 */
insert into emp_insert values(7499,'ALLEN','SALESMAN', 7698,to_date('20-2-1981', 'dd-mm-yyyy'),1600,300,30);

insert into emp_insert(eno, ename, hiredate) values(1001,'김도영', to_date('2022/07/20', 'yyyy/mm/dd'));
insert into emp_insert(eno, ename, hiredate) values(1002, '이마트', to_date(to_char(sysdate-1, 'yyyy/mm/dd'), 'yyyy/mm/dd'));
/*
 * 4.EMPLOYEE 테이블의 구조와 내용을 복사하여 EMP_COPY_2란 이름의 테이블을 만드시오.
 */
create table emp_copy_2
AS
select * from employee;

select * from emp_copy_2;
/*
 * 5.사원번호가 7788인 사원의 부서번호를 10번으로 수정하시오.
 */
update emp_copy_2
set dno = 10 --수정할 값
where eno = 7788; --검색하여

select * from emp_copy_2
where eno = 7788;
/*
 * 6.사원번호가 7788의 담당 업무 및 급여를 사원번호 7499의 담당 업무 및 급여와 일치하도록 갱신하시오.
 */
select job
from emp_copy_2
where eno = 7499;

select salary
from emp_copy_2
where eno = 7499;

update emp_copy_2
set job = (select job
			from emp_copy_2
			where eno = 7499),
salary = (select salary
			from emp_copy_2
			where eno = 7499)
where eno = 7788;

select *
from emp_copy_2
where eno = 7788;
/*
 * 7.사원번호 7369와 업무가 동일한 모든 사원의 부서번호를 사원 7369의 현재 부서번호로 갱신하시오.
 */
select job
from emp_copy_2
where eno = 7369;

select dno
from emp_copy_2
where eno = 7369;

update emp_copy_2
set dno = (select dno
			from emp_copy_2
			where eno = 7369)
where job = (select job
			from emp_copy_2
			where eno = 7369);

select *
from emp_copy_2
where dno = 20;
/*
 * 8.DEPARTMENT 테이블의 구조와 내용을 복사하여 DEPT_COPY_2란 이름의 테이블을 만드시오.
 */
create table dept_copy_2
AS
select * from department;

select * from dept_copy_2;

/*
 * 9.DEPT_COPY_2 테이블에서 부서명이 RESEARCH인 부서를 제거하시오.
 */
delete from dept_copy_2
where dname = 'RESEARCH';

select * from dept_copy_2;
/*
 * 10.DEPT_COPY_2 테이블에서 부서번호가 10이거나 40인 부서를 제거하시오.
 */
delete from dept_copy_2
where dno = 10 OR dno = 40;

select * from dept_copy_2;

