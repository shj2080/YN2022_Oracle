--<�Ͻ� 10��. ������ ���Ἲ�� ���� ����>

--1. ��������
--'������ ���Ἲ' �������� : ���̺� ��ȿ���� ����(��������) �����Ͱ� �ԷµǴ� ���� �����ϱ� ����
--���̺� ������ �� �� �÷��� ���� �����ϴ� ���� ��Ģ��

--<���̺� ������ ���Ǵ� ���� ����(5����)>---------------------------------------------------------------------------
--1. PRIMARY KEY(�⺻Ű=PK) : not null�������� - null�� ���X
--							unique �������� - �ߺ�X -> ����Ű(�Ͻ��� index �ڵ� ����)

--2. FOREIGN KEY(�ܷ�Ű=����Ű=FK) : �����Ǵ� ���̺� �÷� ���� �ݵ�� PK or UNIQUE���� ����
--								 (��) ������̺�(�ڽ�) dno(FK) -> �μ����̺�(�θ�) dno(PK or unique)
--								 �� ���� ���Ἲ �������� : ���̺� ������ '���� ���踦 ����'�ϱ� ���� ��������
--'��� ���̺���� ���� ���ǵǾ�� �ϴ°�? : ����, �θ� ���̺���� �����ϰ� -> �ڽ� ���̺� ����
-- ���� ���Ἲ�� ����Ǵ� ��Ȳ �߻� ��, ���� �ɼ����� ó�� ����
-- (CASCADE, NO ACTION, SET NULL, SET DEFAULT)

--3. UNIQUE : �ߺ�X -> ������ ��=������ �� -> ����Ű(�Ͻ��� index �ڵ� ����)
--			 �ڡ� null�� unique�������ǿ� ���ݵ��� �����Ƿ� 'null���� ���'

--4. NOT NULL : null�� ��� �� ��

--5. CHECK : '���尡���� ������ ������ ���� ����'�Ͽ� (��) CHECK(0 < salary  && salary < 1000000)
--			 -> ������ �� �̿��� ���� ������ ����
-------------------------------------------------------------------------------------------------------------
--default ���� : �ƹ��� ���� �Է����� �ʾ��� �� default���� �Էµ�

--�������� : �÷����� - �ϳ��� �÷��� ���� ��� ���� ������ ����
--		   ���̺��� - 'not null ����'�� ������ ���������� ����

--<���������̸� ���� ������ �� ����>
--constraint ���������̸�
--constraint ���̺��_�÷���_������������
--���������̸� �������� ������ �ڵ� ������

--(1) ���������̸� �������� ������ �ڵ� ������
drop table customer2;

create table customer2(
	id varchar2(20) unique,
	pwd varchar2(20) not null,
	name varchar2(20) not null,
	phone varchar2(30),
	address varchar2(100)
);

--USER_CONSTRAINTS : �ڱ� ������ '���� ����' Ȯ��
-- constraint_type : P(=PK:�⺻Ű), R(=FK=����Ű), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints--�����(system)�� ������ '���� ����' ����
where table_name in ('CUSTOMER2'); --������ : ���̺�� '�빮�ڷ� �˻�'
--where LOWER(table_name) in ('customer2');
--where table_name in ( UPPER('customer2') );

-------------------------------------------------------------------------------------------------------------
--(2) ���������̸� ���� : constraint ���̺��_�÷���_������������
drop table customer2;

create table customer2(
	id varchar2(20) constraint customer2_id_uq unique, --�÷�����
	pwd varchar2(20) constraint customer2_pwd_nn not null,
	name varchar2(20) constraint customer2_name_nn not null,
	phone varchar2(30),
	address varchar2(100)
);

--USER_CONSTRAINTS : �ڱ� ������ '���� ����' Ȯ��
-- constraint_type : P(=PK:�⺻Ű), R(=FK=����Ű), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints--�����(system)�� ������ '���� ����' ����
where table_name in ('CUSTOMER2'); --������ : ���̺�� '�빮�ڷ� �˻�'

--(3) PK�� �÷�����
drop table customer2;

create table customer2(
	id varchar2(20) constraint customer2_id_pk PRIMARY KEY,
	pwd varchar2(20) constraint customer2_pwd_nn not null,
	name varchar2(20) constraint customer2_name_nn not null,
	phone varchar2(30),
	address varchar2(100)
);

--USER_CONSTRAINTS : �ڱ� ������ '���� ����' Ȯ��
-- constraint_type : P(=PK:�⺻Ű), R(=FK=����Ű), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints--�����(system)�� ������ '���� ����' ����
where table_name in ('CUSTOMER2'); --������ : ���̺�� '�빮�ڷ� �˻�'

--(4) PK�� ���̺� ����
drop table customer2;

create table customer2(
	id varchar2(20),
	pwd varchar2(20) constraint customer2_pwd_nn not null,
	name varchar2(20) constraint customer2_name_nn not null,
	phone varchar2(30),
	address varchar2(100),
	
	--���̺� ����
	--constraint customer2_id_pk PRIMARY KEY(id)
	constraint customer2_id_name_pk PRIMARY KEY(id , name)--"�⺻Ű�� 2�� �̻�"�� �� ���̺� ���� ���
);

--USER_CONSTRAINTS : �ڱ� ������ '���� ����' Ȯ��
--constraint_type : P(=PK:�⺻Ű), R(=FK=����Ű), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints--�����(system)�� ������ '���� ����' ����
where table_name in ('CUSTOMER2'); --������ : ���̺�� '�빮�ڷ� �˻�'


--1.1 NOT NULL �������� : �÷� �����θ� ���� : (1)�����
insert into customer2 values(null, null, null, '010-1111-1111', '�뱸 �޼���'); --����

--1.2 unique �������� : ������ ���� ���(��, null ���) : (2)�����
insert into customer2 values('a1234', '1234', 'ȫ�浿', '010-2222-2222', '�뱸 �ϱ�');
insert into customer2 values(null, '5678', '�̼���', '010-3333-3333', '�뱸 ����');

--1.3 ������ ������ ���� Primary Key(=PK=�⺻Ű) ��������
--���̺��� ��� row�� �����ϱ� ���� �ĺ��� -> index��ȣ �ڵ� ������

--1.4 '���� ���Ἲ'�� ���� FOREIGN KEY(FK=����Ű=�ܷ�Ű) ��������
--��� ���̺��� �μ���ȣ�� ������ �μ����̺��� ���� ���� : ���� ���Ἲ
--(��) �ڽ�:������̺� dno(FK) -> �θ�:�μ����̺� dno(�ݵ�� PK or unique)

select * from DEPARTMENT; --�����Ǵ� �θ����̺�

desc employee;--���̺� ���� Ȯ��
--USER_CONSTRAINTS : �ڱ� ������ '���� ����' Ȯ��
--constraint_type : P(=PK:�⺻Ű), R(=FK=����Ű), C(=NOT NUL), U(=Unique)
select table_name, constraint_name, constraint_type
from USER_constraints
where table_name in ('EMPLOYEE', 'DEPARTMENT');

--<�ڡ� ����(�ڽ��� ������̺���)�ϴ� ���>
insert into employee(eno, ename, dno) values(8000, 'ȫ�浿', 50);--�����ϴ� �ڽ�
--�μ���ȣ 50 �Է��ϸ�
--ORA-02291: integrity constraint (SYSTEM.SYS_C007011) violated - parent key not found
--'�������Ἲ �������� ����, �θ�Ű�� �߰����� ���ߴ�.'�� �����޽���

--���� : ������̺��� ����� ������ ���Ӱ� �߰��� ���
--		������̺��� �μ���ȣ�� �μ����̺��� ����� �μ���ȣ �� �ϳ��� ��ġ
--		or NULL �� �Է� ������(��, null ����ϸ�) - ���� ���Ἲ ��������

--���� ���-1
insert into employee(eno, ename, dno) values(8000, 'ȫ�浿', '');-- ''(null) ��, dno�� null ����ϸ�

select * from employee where eno = 8000;

--���� ���-2 : ���������� �������� �ʰ� �Ͻ������� '��Ȱ��ȭ(=disable)' -> ������ ó�� -> '�ٽ� Ȱ��ȭ(=enable)'
--����, USER_CONSTRAINTS ������ ������ �̿��Ͽ� constraint_name�� constraint_type, status ��ȸ
select constraint_name, constraint_type, status
from USER_constraints
where table_name in ('EMPLOYEE');

--[1] ����Ű �������� '��Ȱ��ȭ'
ALTER TABLE employee
disable constraint SYS_C007011; --constraint_type�� R(=FK)

select constraint_name, constraint_type, status
from USER_constraints
where table_name in ('EMPLOYEE');

--[2] �ڽĿ��� ����
insert into employee(eno, ename, dno) values(9000, 'ȫ�浿', 50);

--[3] �ٽ� Ȱ��ȭ
ALTER TABLE employee
enable constraint SYS_C007011; --constraint_type�� R(=FK)
--���� : ORA-02298: cannot validate (SYSTEM.SYS_C007011) - parent keys not found

--���� �ذ� ���-1(��, �ٽ� Ȱ��ȭ��Ű�� ���� dno�� 50�� row �����ϰų� dno�� ''�� ����)
delete from employee where dno = 50;
update employee set dno = '' where dno = 50;--''(null) ��� �� ��밡��
--�ٽ� Ȱ��ȭ
ALTER TABLE employee
enable constraint SYS_C007011;
--Ȱ��ȭ ���� Ȯ��
select constraint_name, constraint_type, status
from USER_constraints
where constraint_name in ('SYS_C007011');

--���� �ذ� ���-2 : �� ��, �̹� ���� row�� �߰��ߴٸ� ã�Ƽ� ���� �Ǵ� ����
--[1]
select dno --{10,20,30,50,null}
from department;

--[2]
select dno --{10,20,30}
from employee NATURAL JOIN department;--dno�� �ڿ�����

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

--[4-1]���� : dno�� 50�� ����� ã�Ƽ� ����
delete from employee
where dno=50;
--���� ��, dno�� 50�� ����� �̸� �����Ŵ

--[4-2]���� : dno�� 50�� ����� ã�Ƽ� ''(null)�� ���� �� ���� �μ��� �������� �ٽ� �ش�μ���ȣ�� ����
UPDATE employee
set dno = ''
where dno=50;

UPDATE employee
set dno = 40 --������ �μ���ȣ
where dno is null;

--[���� ���-2 ����] : �������� ��� ��Ȱ��ȭ���� ���ϴ� �����͸� �����ϴ��� �ٽ� �������� Ȱ��ȭ��Ű�� ������ �߻��Ͽ�
--				   ������ �����͸� �����ϰų� �����ؾ� �ϴ� ���ŷο� ���� �߻���

--<�ڡ� ����(�θ��� �μ� ���̺���)�ϴ� ���>
drop table department;
--���� : ORA-02449: unique/primary keys in table referenced by foreign keys
--�ڽ��� EMPLOYEE���̺��� �����ϴ� ��Ȳ������ ���� �ȵ�

--1. �θ� ���̺���� ���� : �ǽ����� department ���̺� ������ ������ �����Ͽ� department2���̺� ����
--�� ���� : ���������� ����ȵ�
--DROP table department2;--����(?�θ� ���̺�� �����ǰ� �־)
--DROP table department2 CASCADE constraints; --�׷��� ������̺��� ����Ű ���������� �Բ� ����

create table department2--�� ���� : ���������� ����ȵ�
AS
select * from department;

----�������� Ȯ���غ��� ��� ����
select constraint_name, constraint_type, status
from USER_constraints
where table_name in ('DEPARTMENT2');

------PRIMARY KEY �������� �߰��ϱ�(��, �������Ǹ��� ���� ����� �߰�) : ���������� ����ȵǹǷ�
ALTER TABLE department2
ADD constraint department2_dno_pk primary key(dno);

----�������� Ȯ���غ���
select constraint_name, constraint_type, status
from USER_constraints
where table_name in ('DEPARTMENT2');

--2. �ڽ� ���̺� ����
drop table emp_second;

create table emp_second(
	eno number(4) constraint emp_second_eno_pk PRIMARY KEY,
	ename varchar2(10),
	job varchar2(9),
	salary number(7,2) default 1000 CHECK(salary > 0),
	dno number(2), --constraint emp_second_dno_fk FOREIGN KEY references department2 ON DELETE CASCADE --�÷�����
	
	--'���̺� ����'������ ���� : ON DELETE �ɼ�
	constraint emp_second_dno_fk FOREIGN KEY(dno) references department2(dno)
	ON DELETE CASCADE
);

/*
== ON DELETE �ڿ� ==
1. no action(�⺻��) : �θ� ���̺� �⺻Ű ���� �ڽ����̺��� �����ϰ� ������ �θ� ���̺��� �࿡ ���� ���� �Ұ�
	�� restrict(MySQL���� �⺻��, MySQL���� restrict�� no action�� ���� �ǹ̷� ����)
	
	�� ����Ŭ������ restrict�� no action�� �ణ�� ���̰� ����
	
2. cascade : �����Ǵ� '�θ� ���̺��� �⺻Ű ���� ����'�Ǹ� ���������� '�ڽ� ���̺��� �����ϴ� �� ���� ����'
			 �μ� ���̺��� �μ���ȣ 40 ������ �� ��� ���̺��� �μ���ȣ 40�� �����Ͽ� '���� ���Ἲ ������'
			 
3. set null : �����Ǵ� '�θ� ���̺��� �⺻Ű ���� ����'�Ǹ� �� Ű�� �����ϴ� '�ڽ� ���̺��� �����ϴ� ������ NULL������ ����'
			 (��, null ����� ���)
			 
4. set default : �ڽ� ���̺��� �̸� default���� ���� 
				�����Ǵ� '�θ� ���̺��� �⺻Ű ���� ����'�Ǹ� �� Ű�� �����ϴ� '�ڽ� ���̺��� �����ϴ� ������ default������ ����'
				�� �� ���������� �����Ϸ��� ��� ����Ű(=FK) �÷�(������̺��� dno)�� default�� ���ǰ� �־�� ��
				�÷��� null�� ����ϰ� ����� DEFAULT���� �����Ǿ� ���� ���� ��� null�� �ش� �÷��� �Ͻ��� DEFAULT���� ��

 */

--������ : �μ����̺� ������ �μ����̺��� �����ϴ� "������̺��� ����Ű ��������"�� �Բ� ����
--drop table DEPARTMENT2 cascade constraints;--����, ������̺��� ����Ű �������� ���� �� �μ����̺� ���ŵ�

insert into emp_second values(1, '��', '����', null, 30);
insert into emp_second values(2, '��', '����', 2000, 20);
insert into emp_second values(3, '��', '�', 3000, 40);
insert into emp_second values(4, '��', '���', 3000, 20);

--1.5 check �������� : ���� ������ ���� ����
--currval, nextval, rownum ���Ұ�
--sysdate �Լ� ���Ұ�

--CHECK(salary > 0)
insert into emp_second values(5, '��', '���', -4000, 20);
--����? ORA-02290: check constraint (SYSTEM.SYS_C007090) violated
insert into emp_second values(5, '��', '���', 4000, 20);

--1.6 DEFAULT ����
--default �� �ִ� 2���� ���
--salary�� DEFAULT 1000
insert into emp_second(eno, ename, job, dno) values(6, '��', '�λ�', 30);--������ salary�� 1000 �Էµ�
insert into emp_second values(6, '��', '�λ�', default, 30);--default ��� 1000 �Էµ�

select * from emp_second;
select * from department2;

--���ݺ��� �θ��� �μ����̺��� dno=20 �� row �����ϸ� �ڽ����̺��� ������̺��� dno=20�� row�� �Բ� ������.
--����? FOREIGN KEY(dno) references department2(dno) ON DELETE CASCADE
delete from department2 where dno = 20;

select * from department2; --�θ𿡼� �����ϸ�
select * from emp_second;  --�ڽĿ����� ������

delete from department where dno = 20;
--���� : ORA-02292: integrity constraint (SYSTEM.SYS_C007011) violated - child record found
--����?�ڽĿ��� �����ϰ� ������ �θ��� ���ڵ�(=row=��)�� �����Ұ�(no action (=�⺻��))

--���̺� ��ü(���̺� ����+������) ����
drop table department2; --����?���� ������̺��� ����Ű�� �����ϰ� �����Ƿ� ���̺� ��ü ���žȵ�

--���̺� �����͸� ����(���̺� ������ �����)
truncate table department2;
delete from department2; --rollback �����ϹǷ�(Ȥ�� �߸� ���� �� �ٽ� ��������)

select * from department2;

---------------------------------------------------------------------------------------------------------
--2. ���� ���� �����ϱ�
--2.1 ���� ���� �߰� : ALTER table ���̺�� + ADD constraint �������Ǹ� + ��������
--��, 'null ���Ἲ ��������'�� alter table ���̺�� + ADD~�� �߰����� ����
--						 alter table ���̺�� + modify~�� null ���·� ���� ����
--	  'default ������ ��'�� alter table ���̺�� + modify~��

--[test ����]
--drop table dept_copy;
create table dept_copy
AS
select * from department; --�������� ����ȵ�

--drop table emp_copy;
create table emp_copy
AS
select * from employee;

--user_�������� ������ ������ ��ȸ�Ͽ� �������� Ȯ���ϱ�
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPARTMENT', 'EMPLOYEE', 'DEPT_COPY', 'EMP_COPY'); --�ݵ�� '�빮��'

--(��1)�⺻Ű �������� �߰��ϱ�
alter table emp_copy
add constraint emp_copy_eno_pk primary key(eno);

alter table dept_copy
add constraint dept_copy_dno_pk primary key(dno);

--�⺻Ű ���������� �߰��Ǿ����� Ȯ���ϱ�(constraint_type�� P)
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --�ݵ�� '�빮��'


--(��2)'�ܷ�Ű=����Ű' �������� �߰��ϱ�
alter table emp_copy
add constraint emp_copy_dno_fk foreign key(dno) references dept_copy(dno);
--[ON DELETE �ɼ��� �ʿ�� �߰�]
--ON DELETE cascade | ON DELETE set null(��, emp_copy���̺��� dno�� null���� ����� ��)
--ON DELETE set default(��, emp_copy���̺��� dno�� default���� ����. default���� ���Ǿ��ϰ� null�� ����Ѵٸ� null�� default�� ��ü��)

--(��3) NOT NULL �������� �߰��ϱ�(������ : ADD ��� MODIFY�����ϱ�)
alter table emp_copy
modify ename constraint emp_copy_ename_nn NOT NULL;

--'NOT NULL' ���������� �߰��Ǿ����� Ȯ���ϱ�(constraint_type�� C)
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --�ݵ�� '�빮��'

--(��4) DEFAULT ���� �߰��ϱ�(������ : ADD ��� MODIFY�����ϱ�)
--�ڡ�CONSTRAINT �������Ǹ� �Է��ϸ� �ȵ�. (����? DEFAULT�� '���������� �ƴ϶�' �����̹Ƿ�)
alter table emp_copy
modify salary constraint emp_copy_salary_d DEFAULT 500;
--����?ORA-02253: constraint specification not allowed here

alter table emp_copy
modify salary DEFAULT 500;--����

--'DEFAULT ����' �߰��Ǿ����� Ȯ���ϱ� => ���������� �ƴϹǷ� ����� ����
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --�ݵ�� '�빮��'

--(��5) CHECK �������� �߰��ϱ�
select salary from emp_copy where salary <= 1000; --800 950 (CHECK ���ǿ� ����Ǵ� �����Ͱ� �ִ��� Ȯ��)

alter table emp_copy
ADD constraint emp_copy_salary_check CHECK(salary > 1000);
--����? ORA-02293: cannot validate (SYSTEM.EMP_COPY_SALARY_CHECK) - check constraint violated
--��������?�̹� insert�� ������ �� salary�� 1000���� ���� �޿��� �����Ƿ� '���ǿ� ����Ǿ� ���� �߻�'

---select salary from emp_copy where salary <= 1000; --800 950 (CHECK ���ǿ� ����Ǵ� �����Ͱ� �ִ��� Ȯ��)

alter table emp_copy
ADD constraint emp_copy_salary_check CHECK(500 <= salary AND salary < 10000);

alter table dept_copy
ADD constraint dept_copy_dno_check CHECK(dno IN(10,20,30,40,50));--�ݵ�� dno�� �� 5���� �� �� �ϳ��� insert����

--'CHECK' ���������� �߰��Ǿ����� Ȯ���ϱ�(constraint_type�� C)
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --�ݵ�� '�빮��'

---------------------------------------------------------------------------------------------------------
--2.2 �������� ����
--'�ܷ�Ű(=����Ű) ��������'�� �����Ǿ� �ִ� �θ� ���̺��� �⺻Ű ���������� �����Ϸ���
--�ڽ����̺��� '���� ���Ἲ ���������� ���� ����'�� �� �����ϰų�
--CASCADE �ɼ� ��� : �����Ϸ��� �÷��� �����ϴ� ���� ���Ἲ �������ǵ� �Բ� ����

--(��1) ����, �θ� ���̺��� �⺻Ű �������� ���� => ����
alter table dept_copy
drop primary key;
--����?ORA-02273: this unique/primary key is referenced by some foreign keys
--��������? �ڽ����̺��� �����ϰ� �����Ƿ�...

--[�ذ��]
alter table dept_copy
drop primary key CASCADE;
--����?�����Ϸ��� '�⺻Ű���������� ���� �÷�'�� �����ϴ� '���� ���Ἲ ��������'�� �Բ� ���ŵǹǷ�

--[���ŵǾ����� Ȯ��] DEPT_COPY���̺����� P�� ���� EMP_COPY���̺����� R�� ������
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --�ݵ�� '�빮��'

--(��2) NOT NULL �������� ����
alter table emp_copy
DROP CONSTRAINT emp_copy_ename_nn;

--[���ŵǾ����� Ȯ��]
select table_name, constraint_name, constraint_type
from user_constraints
where table_name IN ('DEPT_COPY', 'EMP_COPY'); --�ݵ�� '�빮��'

---------------------------------------------------------------------------------------------------------

--3. �������� Ȱ��ȭ �� ��Ȱ��ȭ
--alter table ���̺�� + DISABLE constraint �������Ǹ� [cascade];
--���� ������ �������� �ʰ� �Ͻ������� ��Ȱ��ȭ
--alter table ���̺�� + ENABLE constraint �������Ǹ� [cascade];
--��Ȱ��ȭ�� ���� ������ Ȱ��ȭ
--�� �� ���� �����ϱ�

---------------------------------------------------------------------------------------------------------

--<10�� ������ ���Ἲ�� ��������-ȥ�� �غ���>
--1.employee���̺��� ������ �����Ͽ� emp_sample ���̺� ����
--��� ���̺��� �����ȣ �÷��� ���̺� ������ primary key ���������� �����ϵ�
--�������Ǹ��� my_emp_pk�� ����
--[1] ���̺� ������ �����ͼ� ���̺� ����
create table emp_sample
AS
select * from employee
where 1=0; --������ ������ ���� -> ������ ������ ����

--[2] �������� �߰�
alter table emp_sample
add constraint my_emp_pk primary key(eno);

--2.�μ����̺��� �μ���ȣ �÷��� ���̺� ������ primary key �������� �����ϵ�
--�������Ǹ��� my_dept_pk�� ����
create table dept_sample
AS
select * from DEPARTMENT
where 1=0;

alter table dept_sample
add constraint my_dept_pk primary key(dno);

--3.������̺��� �μ���ȣ �÷��� �������� �ʴ� �μ��� ����� �������� �ʵ���
--�ܷ�Ű(=����Ű) ��������(=���� ���Ἲ)�� �����ϵ�
--���� ���� �̸��� my_emp_dept_fk�� ����
--[1] �������� �߰�
alter table emp_sample
add constraint my_emp_dept_fk foreign key(dno) references dept_sample(dno);
--���� �߻� ���� ���� : �ڽ� ���̺� ������ ����(��, �ڽĿ��� �θ� �����ϴ� �����Ͱ� �����Ƿ�..)
--�ݵ�� �θ��� �����͸� ���� insert�� �� -> �ڽ��� �����ϴ� ������ insert�ϱ�

--4.��� ���̺��� Ŀ�̼� �÷��� 0���� ū ���� �Է��� �� �ֵ��� �������� ����
--[1] �������� �߰�
alter table emp_sample
add constraint emp_sample_commission_min CHECK(commission > 0);



