--<9�� ������ ���۰� Ʈ�����-ȥ�� �غ���>-----------------------------
/*
 * 1.EMPLOYEE ���̺��� ������ �����Ͽ� EMP_INSERT�� �̸��� �� ���̺��� ����ÿ�.
 */
create table emp_insert
AS
select *
from employee
where 0=1; --������ ������ �Ǵ� ����

select * from emp_insert;
/*
 * 2.������ EMP_INSERT ���̺� �߰��ϵ� SYSDATE�� �̿��Ͽ� �Ի����� ���÷� �Է��Ͻÿ�.
 */
desc emp_insert; --���̺��� ������ �� �÷��� ������ Ÿ�� Ȯ�� ��

--[���-1]
insert into emp_insert values(7499,'ALLEN','SALESMAN', 7698,to_date('20-2-1981', 'dd-mm-yyyy'),1600,300,30);

--[���-2]
insert into emp_insert(eno, ename, hiredate) values(1000, '��ȣ��', sysdate);

select * from emp_insert;
/*
 * 3.EMP_INSERT ���̺� �� ����� �߰��ϵ� TO_DATE �Լ��� �̿��Ͽ� �Ի����� ������ �Է��Ͻÿ�.
 */
insert into emp_insert values(7499,'ALLEN','SALESMAN', 7698,to_date('20-2-1981', 'dd-mm-yyyy'),1600,300,30);

insert into emp_insert(eno, ename, hiredate) values(1001,'�赵��', to_date('2022/07/20', 'yyyy/mm/dd'));
insert into emp_insert(eno, ename, hiredate) values(1002, '�̸�Ʈ', to_date(to_char(sysdate-1, 'yyyy/mm/dd'), 'yyyy/mm/dd'));
/*
 * 4.EMPLOYEE ���̺��� ������ ������ �����Ͽ� EMP_COPY_2�� �̸��� ���̺��� ����ÿ�.
 */
create table emp_copy_2
AS
select * from employee;

select * from emp_copy_2;
/*
 * 5.�����ȣ�� 7788�� ����� �μ���ȣ�� 10������ �����Ͻÿ�.
 */
update emp_copy_2
set dno = 10 --������ ��
where eno = 7788; --�˻��Ͽ�

select * from emp_copy_2
where eno = 7788;
/*
 * 6.�����ȣ�� 7788�� ��� ���� �� �޿��� �����ȣ 7499�� ��� ���� �� �޿��� ��ġ�ϵ��� �����Ͻÿ�.
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
 * 7.�����ȣ 7369�� ������ ������ ��� ����� �μ���ȣ�� ��� 7369�� ���� �μ���ȣ�� �����Ͻÿ�.
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
 * 8.DEPARTMENT ���̺��� ������ ������ �����Ͽ� DEPT_COPY_2�� �̸��� ���̺��� ����ÿ�.
 */
create table dept_copy_2
AS
select * from department;

select * from dept_copy_2;

/*
 * 9.DEPT_COPY_2 ���̺��� �μ����� RESEARCH�� �μ��� �����Ͻÿ�.
 */
delete from dept_copy_2
where dname = 'RESEARCH';

select * from dept_copy_2;
/*
 * 10.DEPT_COPY_2 ���̺��� �μ���ȣ�� 10�̰ų� 40�� �μ��� �����Ͻÿ�.
 */
delete from dept_copy_2
where dno = 10 OR dno = 40;

select * from dept_copy_2;

