--테이블 삭제
drop table department;

--외래키(참조키) 제약조건 제거 후 삭제
drop table department cascade constraints;

select * from employee;
select * from department;

--외래키 제약조건 설정
alter table employee
modify dno number(2) REFERENCES department;

--[해결할 문제] '사원번호가 7788'인 사원이 소속된 '사원번호, 사원이름, 소속부서번호, 소속부서이름' 얻기
select eno, ename, e.dno, dname
from employee e, department d
where e.dno = d.dno --조인조건
AND eno = 7788; --검색조건

select eno, ename, e.dno, dname
from employee e JOIN department d
ON e.dno = d.dno --조인조건
where eno = 7788; --검색조건

select eno, ename, dno, dname
from employee natural JOIN department
where eno = 7788;

select eno, ename, dno, dname
from employee JOIN department
USING(dno)
where eno = 7788;




select e.dno
from employee e
where NOT EXISTS (select dno
			 from department d
			 where e.dno = d.dno)
AND e.dno IS NOT NULL;

delete employee
where dno = (select e.dno
			from employee e
			where NOT EXISTS (select dno
						 from department d
						 where e.dno = d.dno)
			AND e.dno IS NOT NULL);
			

			
			
			
			
select * from employee;

