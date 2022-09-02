--<11장 뷰. 혼자해보기>

--1. 20번 부서에 소속된 사원의 사원번호와 이름, 부서번호를 출력하는 SELECT 문을 하나의 뷰(V_EM_DNO)로 정의하시오.
create view v_em_dno
AS
select eno, ename, dno
from emp11
where dno = 20;

--2. 이미 생성된 뷰(v_em_dno)에 대해서 급여 역시 출력할 수 있도록 수정하시오.
create or REPLACE view v_em_dno
AS
select eno, ename, salary, dno
from emp11
where dno = 20;

--3. 생성된 뷰(v_em_dno)를 제거하시오.
drop view v_em_dno;
