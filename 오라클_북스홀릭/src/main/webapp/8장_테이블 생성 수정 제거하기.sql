--<�Ͻ�-8��. ���̺� ���� ���� �����ϱ�>
--������ ���Ǿ�(DDL=Data Definition Language)
--1.CREATE : DB ��ü ����
--2.ALTER  : 		����
--3.DROP   :		����
--4.TRUNCATE : 		����(������) �� ���� ���� ����
--NCS���� 'SQL Ȱ��' 10P

--�� RENAME : DB ��ü �̸� ����

/*
�ڡ�  DELETE(DML:������ ���۾�)/ TRUNCATE, DROP(DDL:������ ���Ǿ�) ��ɾ��� ������
 (DELETE, TRUNCATE, DROP ��ɾ�� ��� �����ϴ� ��ɾ������� �߿��� �������� �ִ�.)
 
1. DELETE ��ɾ�      : �����ʹ� ���������� ���̺� �뷮�� �پ� ���� �ʴ´�.
                                      ���ϴ� �����͸� ������ �� �ִ�.
                                      ���� �� �߸� ������ ���� �ǵ��� �� �ִ�.(rollback)  

2. TRUNCATE  ��ɾ� : �뷮�� �پ� ���, index � ��� �����ȴ�.
                                       ���̺��� ���������� �ʰ�, �����͸� �����Ѵ�.
                                       �Ѳ����� �� ������ �Ѵ�. 
                                       ���� �� ���� �ǵ��� �� ����.   

3. DROP ��ɾ�           : ���̺� ��ü�� ����(���̺� ������ ��ü�� �����Ѵ�.)  
                                       ���� �� ���� �ǵ��� �� ����.  
*/

--1. ���̺� ������ ����� CREATE TABLE��(����206p)
--���̺� �����ϱ� ���ؼ��� ���̺�� ����, ���̺��� �����ϴ� �÷��� ������ Ÿ�԰� ���Ἲ ���� ���� ����

--<'���̺��' �� '�÷���' ���� ��Ģ>
--����(���� ��ҹ���)�� ����, 30�� �̳�
--����(���� ��ҹ���), ����0~9, Ư������(_ $ #)�� ��밡��
--��ҹ��� ��������, �ҹ��ڷ� �����Ϸ��� ''�� ������� ��
--���� ������� �ٸ� ��ü�� �̸��� �ߺ�X (��)SYSTEM�� ���� ���̺����� �� �޶�� ��

--<�ٸ� ���̺� ������ Ȱ���� ���̺� ����> NCS
--<���� ������ �̿��Ͽ� �ٸ� ���̺�κ��� �����Ͽ� ���̺� ���� ���>
--���� ���������� �μ� ���̺��� ������ ������ ���� -> ���ο� ���̺� ����
--1.create table ���̺��(�÷��� ���O) : ������ �÷����� ������ Ÿ���� ������������ �˻��� �÷��� ��ġ
--2.create table ���̺��(�÷��� ���X) : ���������� �÷����� �״�� ����
--
--���Ἲ �������� : �ڡ� not NULL ���Ǹ� ����,
--               �⺻Ű(=PK), �ܷ�Ű(=FK)�� ���� ���Ἲ���������� ����X
--               ����Ʈ �ɼǿ��� ������ ���� ����
--
--���������� ��� ����� ���̺��� �ʱ� �����ͷ� ���Ե�

--(����) create table AS SELECT��;
--1.create table ���̺��(�÷��� ���O) �� ��
--[����] ���� ���������� �μ� ���̺��� ������ ������ �����ϱ�(�ڡ� ���������� ����ȵ�-NOT NULL ���Ǹ� ����)
--[1]
select dno
from DEPARTMENT;

--[2]
create table dept1(dept_id)
AS
select dno
from DEPARTMENT;

select * from dept1;
--Run SQL ~ ���� conn system/1234
--dept1�� ���̺� ���� Ȯ�� => ������ Ÿ�԰� �����Ͱ� ����
desc dept1;

--2.create table ���̺��(�÷��� ���X)
--[����] 20�� �μ��� �Ҽ� ����� ���� ������ ������ dept2 ���̺� �����ϱ�
--[1]. 20�� �μ��� �Ҽ� ����� ���� ���� ��ȸ
select eno, ename, salary*12
from employee
where dno = 20;

--[2]�����߻� ORA-00998: must name this expression with a column alias
--�ڡ� ���������� ���� '�����'�� ���� ��Ī �����ؾ� ��(=>��Ī ������ ����)
create table dept2
AS
select eno, ename, salary*12 as "����"
from employee
where dno = 20;

--[3]
select * from dept2;
--Run SQL ~���� dept2�� ���̺� ���� Ȯ�� => ������ Ÿ�԰� �����Ͱ� ����
desc dept2;

--<���������� �����ʹ� �������� �ʰ� ���̺� ������ ���� ���>
--���������� where���� �׻� ������ �Ǵ� ���� ���� : ���ǿ� �´� �����Ͱ� ��� ������ ����ȵ�
--where 0 = 1

--[����] �μ����̺��� ������ �����Ͽ� dept3 �����ϱ�
create table dept3
AS
select *
from department
where 0 = 1;--���� ����

select * from dept3; --������ ������ ����ǰ� �����ʹ� ����ȵ�
--Run SQL ~���� dept3�� ���̺� ���� Ȯ�� => ������ ������ ����(�̶�, ���������� ����ȵ�)
desc dept3;
---------------------------------------------------------------------

--2. ���̺� ������ �����ϴ� ALTER TABLE��
--2.2.1 �� �߰�(=�÷� �߰�) : �߰��� ���� ���� ������ ��ġ�� ����(��, ���ϴ� ��ġ�� ������ �� ����.)
ALTER TABLE ���̺��
ADD �÷��� ������Ÿ�� [DEFAULT ��];

--[����] ������̺� dept2�� ��¥ Ÿ���� ���� birth ��(�÷�) �߰�
ALTER TABLE dept2
add birth date;--ADD �÷��� ������Ÿ��[default ��]
--�� ���̺� ������ �߰��� ������(��)�� �ִٸ� �߰��� ��(birth)�� ���� null�� �ڵ� �Էµ�
select * from dept2;

--[����] ������̺� dept2�� ����Ÿ���� email �� �߰�
--(�̶�, ������ �߰��� ������(��)�� �ִٸ� ���� �߰��� ��(email)�� ���� 'test@test.com' �Է�)
ALTER TABLE dept2
ADD email varchar2(50) default 'test@test.com' NOT NULL;
--�� ���̺� ������ �߰��� ������(��)�� �ִٸ� �߰��� ��(email)�� ���� default ������ �ڵ� �Էµ�
select * from dept2;

--2.2 ��(�÷�) ������ Ÿ�� ����
ALTER TABLE ���̺��
MODIFY �÷��� ������Ÿ�� [DEFAULT ��];

--���� �÷��� �����Ͱ� ���� ��� : �÷�Ÿ���̳� ũ�� ���� ����
--						  (���� INSERT�� �����Ͱ� �����Ƿ� �����Ӱ� ���氡����)
--				 �ִ� ��� : Ÿ�� ������ char�� varchar2�� ����ϰ�
--						  ������ �÷��� ũ�Ⱑ ����� �������� ũ�⺸�� ���ų� Ŭ ��쿡�� ���� ������
--						  ���� Ÿ���� �� �Ǵ� ��ü�ڸ��� �ø� �� ����(��) number,
--						  	 	number(3)=number(��ü�ڸ���3,0) : �Ҽ�1°�ڸ����� �ݿø��Ͽ� ���� �ڸ�(0)���� ǥ��
--								number(5,2)=number(��ü�ڸ���5,�Ҽ�2°�ڸ�) : �Ҽ�3°�ڸ����� �ݿø� 123.45

--[����] ���̺� dept2���� ����̸��� �÷�ũ�⸦ ����
--[1] ���� dept2���̺� ���� Ȯ�� �� ����
desc dept2;

--[2] ����
ALTER TABLE dept2
MODIFY ename varchar2(30); --�÷�ũ�� 10 -> 30���� ũ�� ����

--[3] ���̺� ���� Ȯ��
desc dept2;

--[����] ���̺� dept2���� email�� �÷�ũ�⸦ ���� 50 -> 40 �۰� ����
ALTER TABLE dept2
modify email varchar2(40);--�����:����?������ ����� �����ͺ��� ū ũ���̹Ƿ�

ALTER TABLE dept2
modify email varchar2(5);
--����? ORA-01401: inserted value too large for column

--[����] ���̺� dept2���� email�� �÷�Ÿ���� ���� varchar2(40) -> char(30)Ÿ������ ����
alter table dept2
modify email char(30);

--[����] ���̺� dept2���� email�� �÷�Ÿ���� ���� : char(30) -> number(30)
alter table dept2
modify email number(30);
--����? Ÿ�Ժ����� char�� varchar2�� ����
--����, char(30) -> number(30)�� �����ؾ� �ϴ� ��� : �ش� �÷��� ���� ��� ������ ���� ����


--2.2.2 ���̺� �÷��� �̸� ����
ALTER TABLE ���̺��
RENAME COLUMN �����÷��� TO ���÷���;
--[����] ���̺� DEPT2���� ����̸��� �÷��� ����(ename -> ename2)
ALTER TABLE dept2
RENAME COLUMN ename TO ename2;

desc dept2;

select * from dept2;

--[����] ���̺� dept2���� ename2�� �÷� �⺻ ���� '�⺻'���� ����
--[1]
alter table dept2
modify ename2 varchar2(50) default '�⺻' not null;
--[2]
desc dept2;

--2.3 �� ����(=�÷� ����) : 2�� �̻� �÷��� �����ϴ� ���̺����� �� ���� ����
alter table ���̺��
DROP column �÷���;

--[����] ���̺� dept2���� ����̸� ����
alter table dept2
drop column ename2; 

--�ٽ� ���� �̸��� �÷� �߰�(=�� �߰�) ����
alter table dept2
ADD ename2 varchar2(10);

desc dept2;

--2.4 SET unused : �ý����� �䱸�� ���� �� �÷��� ������ �� �ֵ��� �ϳ� �̻��� �÷��� unused�� ǥ��
--������ ���ŵ����� ����
--�׷��� DROP ��� �������� �÷� �����ϴ� �ͺ��� ����ð��� ������
ALTER TABLE ���̺��
SET unused(�÷���);

--�����Ͱ� �����ϴ� ��쿡�� ������ ��ó�� ó���Ǳ� ������ select���� ��ȸ�� �Ұ���
--describe �����ε� ǥ�õ��� ����
desc dept2; --���̺� ���� Ȯ��

--SET unused ����ϴ� ����?
--1. ����ڿ��� ��ȸ���� �ʰ� �ϱ� ����
--2. unused�� �̻�� ���·� ǥ���� �� ���߿� �Ѳ����� drop���� �����ϱ� ����
--	 � �߿� �÷��� �����ϴ� ���� �ð��� ���� �ɸ� �� �����Ƿ� unused�� ǥ���صΰ� ���߿� �Ѳ����� drop���� ����


--[����] ���̺� dept2���� "����"�� unused ���·� �����
ALTER TABLE dept2
SET unused("����");

select * from dept2;

--[����] unused�� ǥ�õ� ��� �÷��� �Ѳ����� ����
alter table dept2
drop unused columns; --s:����

--���� �� �ٽ� ���� �̸��� �÷� �߰�
alter table dept2
ADD "����" number;

desc dept2;
select * from dept2;

--������ null ��� 0���� ǥ��
select eno, birth, email, ename2,
NVL("����", 0) as "����"
from dept2;

-----------------------------------------------------
--3. ���̺�� ����
--���-1 : RENAME ���� ���̺�� TO �����̺��;
rename dept2 to emp;

--���-2 : alter table ���� ���̺�� RENAME TO �����̺��;
alter table emp
RENAME to emp2;

--4. ���̺� ����
drop table ���̺��;

--�ڡ� [department ���̺� �����ϴ� ���-1]
--������ ���̺��� �⺻Ű(=PK:unique + NOT NULL)�� ����Ű(unique)�� �ٸ� ���̺��� �����ϰ� �ִ� ��쿡�� ������ �Ұ�����
--�׷���, '�����ϴ� ���̺�(=�ڽ� ���̺�)�� ���� ����' �� �θ� ���̺� ���� ����
drop table department; --����

drop table employee;	--������̺���� ���� ���� ��
drop table department;--���� ����(�μ����̺��� dno�� ������̺��� �����ϰ� �����Ƿ�...)

--�ڡ� [department ���̺� �����ϴ� ���-2]
drop table department; --���� ����?�μ����̺��� dno�� ������̺��� �����ϰ� �����Ƿ�...
--�׷���, �μ����̺��� ������ �� ��� ���̺��� '����Ű �������Ǳ��� �Բ� ����'
drop table department cascade constraints;

select table_name, constraint_name, constraint_type--P(=PK:�⺻Ű), R(=FK=����Ű)
from user_constraints
where table_name in ('EMPLOYEE', 'DEPARTMENT');--table_name : �빮�ڷ� ǥ�õǹǷ�
--where lower(table_name) in ('employee', 'department');
--where table_name in (upper('employee'), upper('department'));

--5. ���̺��� ���� ����(=���̺��� ��� �����͸� ����)
TRUNCATE TABLE ���̺��;
--���̺� ������ ����, ���̺� ������ �������ǰ� ������ index, view, ���Ǿ�� ������

select * from emp2;
--�׽�Ʈ���� "����" ���� �� salary �߰�
alter table emp2
drop column "����";

alter table emp2
add salary number(7,2);

insert into emp2 values(1,'2022-07-19', default, 'kim', 2800);
select * from emp2;

TRUNCATE TABLE emp2; --"�����͸� ����"
select * from emp2; --Ȯ��

desc emp2; --Ȯ��=>���̺� ���� ���žȵ�
--�������ǵ� Ȯ��=>�������ǵ� ���žȵ�
select table_name, constraint_name, constraint_type--P(=PK:�⺻Ű), R(=FK=����Ű), C(=NOT NUL)
from user_constraints
where table_name in ('EMP2');

--6. ������ ���� : ����ڿ� DB �ڿ��� ȿ�������� ���� ���� �پ��� ������ �����ϴ� �ý��� ���̺� ����
--����ڰ� ���̺��� �����ϰų� ����ڸ� �����ϴ� ���� �۾��� �� ��
--'DB ����'�� ���� �ڵ� ���ŵǴ� ���̺�
--����ڰ� ���� ����X, ����X -> '�б����� ��'�� ����ڿ��� ������ ������(��, select���� ���)

/* NCS ���
������ ����(Data Dictionary)���� �����ͺ��̽��� ������(����� ������)�� ������ 
��� ����(DBMS�� �����ϴ� ������)�� �ִ�. ������ ������ ������ �����ϴ� ����
�� �ý��� �����(�����ͺ��̽� ������: DBA)�� ������.
�ݸ� �Ϲ� ����ڿ��Դ� �ܼ� ��ȸ�� ������ �б� ���� ���̺� ���°� �����ȴ�.
�����͸� ������(�����͸� �����ϴ�) ��� ������� ���� �������� �����͸� ���Ѵ�. 
���� '������ ������ ��Ÿ ������(Meta data)�� �����Ǿ� ����'�� �ǹ��Ѵ�.
 */

--�� ��ü : ���̺�, ������, �ε���, �� ��

--6.1 USER_������ ���� : 'USER_�� ����~S(����)'�� ����
/* ���� �ڽ��� ������ ������ ��ü ��ȸ ���� */
-- ����ڿ� ���� �����ϰ� ���õ� ���
-- �ڽ��� ������ ���̺�, ,������ , ��, �ε���, ���Ǿ� ���� ��ü�� �ش� ����ڿ��� ���� ���� ����
--(1) USER_TABLES : ����ڰ� ������ '���̺�'�� ���� ���� ��ȸ
select *
from USER_TABLES; --�����(system)�� ������ '���̺�' ����

select *
from USER_sequences;--�����(system)�� ������ '������' ����

select *
from USER_indexes;--�����(system)�� ������ '�ε���' ����

select *
from USER_views;--�����(system)�� ������ '��' ����

--USER_CONSTRAINTS : �ڱ� ������ '���� ����' Ȯ��
select table_name, constraint_name, constraint_type--P(=PK:�⺻Ű), R(=FK=����Ű), C(=NOT NUL), U(=Unique)
from USER_constraints--�����(system)�� ������ '���� ����' ����
where table_name in ('EMPLOYEE', 'DEPARTMENT'); --������ : ���̺�� '�빮�ڷ� �˻�'

--USER_TAB_COLUMNS �ڱ� ������ ���̺� ���� Į�� ��� Ȯ��
select *
from USER_TAB_COLUMNS;

--USER_TAB_COMMENTS �ڱ� ������ ���̺� �ڸ�Ʈ Ȯ��
select *
from USER_TAB_COMMENTS;

--6.2 ALL_������ ����
/*�ڽ��� �������� ������ �� �ִ� ��ü�� �ٸ� ������ ���� ������ ������ ���� ��� ��ü ��ȸ ����*/

--(1). ALL_TABLES : ���� �ִ� ���̺� ��� Ȯ��
--owner : ��ȸ ���� ��ü�� ������ �������� Ȯ��
--����� : system �� �� - ��� 500 row (SYS�� SYSTEM�� �����(HR) ���Ե� ���·� ����� ����)
--	   : hr		�� �� - ��� 79 row (�����(HR)�� SYS�� SYSTEM ������ �ٸ� ����ڵ� ����� ����)
select owner, table_name
from ALL_tables;
--where owner in ('SYSTEM') OR table_name in('EMPLOYEE', 'DEPARTMENT');
--where owner in ('SYSTEM') AND table_name in('EMPLOYEE', 'DEPARTMENT');

select * --owner, table_name
from ALL_tables
where owner IN ('HR');

--(2).ALL_CONSTRAINTS : ���� �ִ� ���� ���� Ȯ��
select *
from ALL_CONSTRAINTS;

--(3). DBA_������ ���� : �����ͺ��̽��� ��� ��ü ��ȸ ����(DBA_�� �ý��� ���� ����)
--�ý��� ������ ���õ� ��, DBA�� �ý��� ������ ���� ����ڸ� ���� ����
--system �������� �����Ͽ� DBA_������ ������ ���µ�,
--�� �� system�� DBA_������ ������ �� �� �ִ� ������ �������� ��ȸ�� ������

--(1) DBA_TABLES : ��� ���̺� ��� Ȯ��
select *
from DBA_tables
where owner IN ('HR'); --��� ����(����? system�� DBA_�����ͻ����� ��ȸ�� ������ �־ ���� ����)

--system������ ���� hr�������� ����
select *
from DBA_tables
where owner IN ('HR');--��� �ȳ���(����? hr�� DBA_�����ͻ����� ��ȸ�� ������ ��� ���� �Ұ���)

--<8�� ȥ���غ���>----------------------------------------
--1. ���� ǥ�� ��õ� ��� DEPT ���̺��� �����Ͻÿ�.
--�÷���  ������ Ÿ��  ũ��
--dno   number   2
--danme varchar2 14
--loc   varchar2 13

create table dept(
	 dno number(2),
	 dname varchar2(14),
	 loc varchar2(13)
);

--2. ���� ǥ�� ��õ� ��� EMP ���̺��� �����Ͻÿ�.
--�÷���  ������ Ÿ��  ũ��
--eno   number   4
--ename varchar2 10
--dno   number   2
create table emp(
	eno number(4),
	ename varchar2(10),
	dno number(2)
);

--3. �� �̸��� ������ �� �ֵ��� EMP ���̺��� �����Ͻÿ�.(ename �÷��� ũ��)
--�÷���  ������ Ÿ��  ũ��
--eno   number   4
--ename varchar2 25(ũ�Ⱑ ������ �κ�)
--dno   number   2
alter table emp
modify ename varchar2(25);

--4. EMPLOYEE ���̺��� �����ؼ� EMPLOYEE2�� �̸��� ���̺��� �����ϵ� 
--�����ȣ, �̸�, �޿�, �μ� ��ȣ �÷��� �����ϰ� ���� ������ ���̺��� �÷�����
--���� EMP_ID, NAME, SAL, DEPT_ID�� �����Ͻÿ�.

--[���-1]
create table employee2(emp_id, name, sal, dept_id) --4��
AS
select eno, ename, salary, dno--4��
from employee;

--[���-2]
--[1]
create table employee2
as
select eno, ename, salary, dno--�÷��� �״�� ����
from employee;

select * from employee2;--�÷��� Ȯ��

--[2] �÷��� ����
alter table employee2
rename column eno to emp_id;

alter table employee2
rename column ename to name;

alter table employee2
rename column salary to sal;

alter table employee2
rename column dno to dept_id;

select * from employee2; --�ٽ� Ȯ��

--5. EMP ���̺� �����Ͻÿ�.
drop table emp;

--6. EMPLOYEE2�� �̸��� EMP�� �����Ͻÿ�.
--[���-1]
rename employee2 to emp;
--[���-2]
alter table employee2 rename to EMP;

--7. DEPT ���̺��� DNAME �÷� �����Ͻÿ�.
alter table dept
drop column dname;

--8. DEPT ���̺��� LOC �÷��� UNUESD�� ǥ���Ͻÿ�.
alter table dept
set unused(loc);

select * from dept;

--9. DEPT ���̺��� UNUSED �÷��� ��� �����Ͻÿ�.
alter table dept
drop unused columns;

