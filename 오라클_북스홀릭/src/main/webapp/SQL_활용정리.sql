--[SQL Ȱ��] ����

--<DDL:������ ���Ǿ�>
--1. ���̺� ����
[���̺�� test]
----------------------------------------
�ʵ�(=�÷���) Type           null      key   
----------------------------------------
id         varchar2(20)   no           
password   varchar2(30)   no            
name       varchar2(25)   no            
����        char(2)        yes           
birth      date           yes          
age        number(4)      yes       
----------------------------------------

--drop table test;
create table test(
	id varchar2(20) not null,
	password varchar2(30) not null,
	name varchar2(25) not null,
	���� char(2),
	birth date,
	age number(4)
);


--2. �÷� �̸�(=�� �̸�) ���� : ���� -> gender 
alter table test
rename column ���� TO gender;

--3. �÷� �̸�(=��) �߰�:address varchar2(60) �߰�
alter table test
add address varchar2(60);

--4. birth �� ����
alter table test
drop column birth;

/*
 * [�÷��� ���� ����(���� ��) ���ǻ���]
 * �÷��� ���̸� ���� ��� �̹� insert�� �ش� �÷��� �� �� ������ ���̺��� ū ���� ������ ������ �߻��Ѵ�.
 * ORA-01441: cannot decrease column length because some value is too big 
 * 
 * �̷� ���� �ش� �÷��� ���̸� ��ȸ�Ͽ� ������ ���̺��� ū ���� �ִ��� Ȯ���� �� ���� �����ؾ� �Ѵ�.
 * 
 * select id, age -- select *
 * from test
 * where length(age) > 3;
 */

--5. �� ���� : ���� insert�� row(=���ڵ�)�� �����Ƿ� �÷� ũ�⸦ �����Ӱ� ���� �� �ִ�.
--(1) age : number(3), null:NO, Default��:0
alter table test
modify age number(3) default 0 not null; --�ڡ� ���� ���� : not null default 0 (����)

--(2) gender : char(1), Default��:'M'
alter table test
modify gender char(1) default 'M';

--�ټ��� �÷� ������ ��
alter table test
modify (age number(3) default 0 not null,
		gender char(1) default 'M');	

--�� '���̺� ��������'�� Ȯ���Ϸ��� 'USER_CONSTRAINTS'������ ���� �����
select constraint_name, constraint_type --P, R, C, U
from user_constraints
where table_name in ('TEST');

--6. id�� '�⺻Ű ��������' �߰�
--[���-1]
--�ڵ����� ������ '�������Ǹ�(=constraint_name)'
alter table test
add primary key(id);

--����ڰ� �Է��� '�������Ǹ�(=constraint_name)'
alter table test
add constraint test_id_pk primary key(id);

--[���-2] �÷� id ����
alter table test
MODIFY id varchar2(20) primary key;--primary key = not null + unique(index �ڵ�������)

--7. ���̺� ���� Ȯ��
desc test;
--SQL PLUS ��ɾ�� ��Ŭ���������� ����ȵ�(ORA-00900: invalid SQL statement)
--(RUN SQL~���� ���� ����)

--8. TEST ���̺��� �������� Ȯ��(���̺��, �������Ǹ�, ��������Ÿ��)
--[1] �÷����� �𸣰����� *�� ��ȸ�Ͽ� �̸�Ȯ���� ��
select *
from user_constraints
where table_name in ('TEST');

--[2] ���̺��, �������Ǹ�, ��������Ÿ�� ��ȸ
select table_name, constraint_name, constraint_type --P(=PK), R(=FK), C(=not null), U(Unique)
from user_constraints
where table_name in ('TEST');--�ݵ�� �빮��


-------------------------------------------------------------------------------------------------------------------

--<DML:������ ���۾�(insert, update, delete) -> TCL:Ʈ����� ó����(commit, rollback, savepoint)
--9. insert : ������ �Է�
id     password   name   gender    age    address
---------------------------------------------------
yang1  !1111      �翵��     M       27     ���̽�
yoon2  $2222      ��ȣ��     M       19     �뱸������
lee3   #3333      �̼���     M       30     ����Ư����
an4    &4444      �ȿ���     F       24     �λ걤����

insert into test values('yang1', '!1111', '�翵��', 'M', 27, '���̽�');
insert into test values('yoon2', '$2222', '��ȣ��', 'M', 19, '�뱸������');
insert into test values('lee3', '#3333', '�̼���', 'M', 30, '����Ư����');
insert into test values('an4', '&4444', '�ȿ���', 'F', 24, '�λ걤����');

select * from test;
/** ���� - �����ϱ��� Ǯ����� **/
--10�� 10�� �������� => ���� ------------------------------
--10. update : '������' -> '��'�� ������ ����
--(��, �Լ� ����Ͽ� �ذ��ϱ�)

--[���-1]�� [���-2] : '������' ���� ���ڰ� 2���� ������ �� ��
--[���-1]
--substr(�������ڿ�, ����index, ������ ����) : ���ڿ��� �Ϻθ� �����Ͽ� �κй��ڿ� ����
--����index : �����̸� ���ڿ��� �������� �������� �Ž��� �ö�
--�ε���(index) : 1 2 3...(���ڹ� index : 0 1 2...)
update test
set address = substr(address, 1, 2) || '��' --'�λ�' || '��' => '�λ��'
where address like '%������';

--[���-2]
--concat('���ڿ�1', '���ڿ�2') : '�� ���ڿ�'�� �ϳ��� ���ڿ��� ����(=����)
--		�ڹݵ�� 2 ���ڿ��� ���� ���� = �Ű����� 2����
--�Ű�����=�μ�=����=argument
--�׷���, '���ڿ�1' || '���ڿ�2' || '���ڿ�3' || ... ||�� ���� ���ڿ� ���ᰡ��
update test
set address = concat(substr(address, 1, 2), '��')--CONCAT('�뱸', '��')
where address like '%������';
-----------------------------------------------------------------------------------------------------------
--[���-3]�� [���-4] : '������' ���� ���ڰ� �� �������� �� �� => ��Ȯ�� Ǯ��
--[���-3]
--replace(�÷���, 'ã������', '��ȯ����') : ã�� ���ڸ� �����ϰų� ����
--(��)ã�� ���ڸ� ����
update test
set address = REPLACE(address, '������', '��')
where address like '%������';

--(��)ã�� ���ڸ� ����
update test
set address = REPLACE(address, '����', '')
where address like '%������';

--[���-4] : INSTR() + [���-1] SUBSTR() => '������' ���� ���ڰ� �� �������� �� �� ���
--instr(����ڿ�, ã�� ���ڿ�, ���� index, �� ��° �߰�) : '����ڿ�' ������ '����index'���� �����ؼ� '�� ��° �߰�'�ϴ� '�ش� ���ڿ�'�� ã�� index��ȣ ����
--��, ã�� ���ڿ��� ��� '��ġ(=index��ȣ)'�� �ִ����� ����ڿ��� �����ϴ����� ���θ� �� �� �ִ�.
--'���� index, �� ��° �߰�' �����ϸ� ��� 1�� ����
--(��)instr('����ڿ�', 'ã������') == instr('����ڿ�', 'ã������', 1, 1)
--ã�� ���ڰ� ������ 0�� ����� ������(���ڹٿ����� -1�� ������)
--�ڹٿ����� "�ູ,���".indexOf("���") == 3(���ڹ��� index�� 0���� ����)

--INSTR() : '������' ���� ���ڰ� �� �������� �� �� ���
update test
set address = substr(address, 1, instr(address, '������',1, 1) - 1) || '��'
where address like '%������';

--10�� ��������. update : '������' -> '��'�� ������ ����
--(��, �������� ����Ͽ� �ذ��ϱ�)

--[���-1] REPLACE() ���
--[1]
select replace(address, '������', '��')
from test
where address like '%������';

--[2]
update test
set address = (
				select replace(address, '������', '��')
				from test
				where address like '%������')
where address like '%������';

--[���-2] substr() ���
--[1] '������'�� index-1 = ������ �� ������ �ܾ� ����
select instr(address, '������', 1, 1) - 1
from test
where address like '%������';

--[2] 
select substr(address, 1, (select instr(address, '������', 1, 1) - 1
							from test
							where address like '%������')) || '��'
from test
where address like '%������';

--[3]
update test
set address = (select substr(address, 1, (select instr(address, '������', 1, 1) - 1
							from test
							where address like '%������')) || '��'
				from test
				where address like '%������')
where address like '%������';

/*
update test
set address = replace(address, '������', '��')
where id in (select id
                from test
                where instr(address, '������') != 0);
                
update test
set address = substr(address, 1, instr(address, '������',1, 1) - 1) || '��'
where id in (select id
                from test
                where instr(address, '������') != 0);
*/
---------------------------------------------------------
--11. delete : ���̰� 20�̸��� ������ ����
--�̸� <20, ���� <=20, �ʰ� >20, �̻�>=20
delete test--from test
where age < 20;

--12. ������ �Է��� �� ��������(Ʈ����� �Ϸ�) : RUN SQL~���� ����
----->��� Ȯ�� : ��Ŭ�������� ��� Ȯ��
--������ ������ : jun5 *5555 ����ȣ  M 28 NULL

--[1] RUN SQL~���� ����
insert into test values('jun5', '*5555', '����ȣ', 'M', 28, null);
commit;

--[2] ��Ŭ�������� ��� Ȯ��
select * from test;

--13. ������ ������ �� ���� ���·� ����(Ʈ����� ���) : RUN SQL~���� ����
----->��� Ȯ�� : ��Ŭ�������� ��� Ȯ��
--[����] �ּҰ� '���̽�'�� row ���� �� Ʈ����� ��� -> Ȯ��
--[1] RUN SQL~���� ����
delete test
where address = '���̽�';

--[2] Ʈ����� ���(���� ���·� ����)
rollback;

--[3] ��Ŭ�������� ��� Ȯ��
select * from test;

--������ ����(8��-6. ������ ���� ����)
--14. ����ڰ� ������ ���̺� �̸� ��ȸ => USER_������ ����
select table_name
from USER_TABLES;

--15. ���̺� ���� Ȯ��
desc test;----SQL PLUS��ɾ�� ��Ŭ�������� ����ȵ�(RUN SQL~���� ����)

--16. index ����(index �� : name_idx)
--�ε��� : �˻� �ӵ��� ����Ű�� ���� ���
--     	������� �ʿ信 ���ؼ� ���� ������ ���� ������
--     	������ ���Ἲ�� Ȯ���ϱ� ���ؼ� ���÷� �����͸� �˻��ϴ� �뵵�� ���Ǵ� 
--     	'�⺻Ű�� ����Ű�� �ε��� �ڵ� ����'
create index name_idx
ON test(name);

--�ڡ�index ���� Ȯ�� ���-1
select index_name
from USER_indexes
where table_name = 'TEST'; --�ݵ�� ���̺���� �빮�ڷ�
--where table_name IN ('TEST');

select *
from user_indexes;

--�� index ���� Ȯ�� ���-2
select index_name, column_name
from USER_ind_columns--column_name �˷��� 
where table_name = 'TEST'; --�ݵ�� ���̺���� �빮�ڷ�

--17. view ����(�� �̸� : viewTest)
--��? �ϳ� �̻��� ���̺��̳� �ٸ� �並 �̿��Ͽ� �����Ǵ� �������̺�
--��� ������ ������ �ܼ�ȭ ��ų�� �ִ�.
--��� ����ڿ��� �ʿ��� ������ �����ϵ��� ������ ������ �� �ִ�.
create view viewTest
AS
select id, name, gender
from test;

--�� ���� Ȯ�� ���-1
select * from viewTest;

-- �� ���� Ȯ�� ���-2
select view_name
from USER_views
where view_name = 'VIEWTEST';

--����ڰ� ������ �� �̸� ��ȸ
select view_name
from USER_views;

--------------------------------------------------------------------------------------------
--18. test2 ���̺� ����
[���̺�� test2]
-------------------------------------
�ʵ�       Type           null   key 
-------------------------------------
id        varchar2(20)   no     PK  
major     varchar2(20)   yes  
-------------------------------------

create table test2(
	id varchar2(20) primary key,
	major varchar2(20)
);

insert into test2 values('yang1', '��ǻ�� ����');
insert into test2 values('lee3', '���� ����');
insert into test2 values('an4', 'ȯ�� ����');
insert into test2 values('jun5', 'ȭ�� ����');

select * from test2;

--test, test2 EQUI ����(=�������=��������) : ������ Ÿ���� ���ƾ� ��
--[���-1] : �ߺ��÷� �������� �����Ƿ� �����ϱ� ���� '��Ī �ʿ�'
--			�÷����� �޶� ���ΰ���

--[���-1] : , where - (+)�ٿ��� �ܺ�����(���ʰ� �����ʸ� ����, ����(Full)�ܺ����� ����)
select *
from test t1, test2 t2
where t1.id = t2.id;--��������
--AND (�˻�����)

--[���-2] : JOIN ~ ON => ����O - Left Outer Join, Right Outer Join, Full Outer Join
select *
from test t1 JOIN test2 t2
ON t1.id = t2.id;--��������
--WHERE �˻�����

--[���-3][���-4] : �ؿ���Ŭ������ ��밡��
--				   �ߺ��÷� �����ϹǷ� '��Ī �ʿ�X'
--				   �÷����� �ݵ�� ���ƾ� ������ �� �ִ�.

--[���-3] : natural join - ���� �̸�, Ÿ��, "�ǹ�"�� ���� �÷��� "�ϳ�"�� �� ��� ����
select *
from test natural join test2;
--�������� �ʿ����

--[���-4] : JOIN ~ USING - ���� �̸�, Ÿ��, "�ǹ�"�� ���� �÷��� "2�� �̻�"�� �� ��� ����
select *
from test JOIN test2
USING(id);

/*
 * �� NATURAL ���ΰ� USING ���� �̿��� ������ ������
 * ���εǴ� ���̺� ����� �÷��� 2�� �̻��̶�� ���� ����� ������ �ٸ� �� �ִ�.
 * 
 * select *
 * from employee 
 * join department USING(dno)--������ �����
 * join test3 USING(manager_id);--����.(manager_id�� �̸�, Ÿ��, �ǹ̴� ����.)
 * 
 * select *
 * from employee 
 * NATURAL join department;--�ڵ����� dno�� ������ �����
 * NATURAL join test3;--����.
 * --(manager_id�Ӹ� �ƴ϶� '���� �̸��� ���� Ÿ���� �ϳ� �� ����'�Ѵٸ� 2���� ����� �÷����� ������ �Ǿ�)
 * -->���� ����� ������ �ٸ� �� �ִ�.
 * 
 * �� ����, ���� �̸�, Ÿ��, �ǹ��� �÷��� �ϳ��̸�  NATURAL ������ ����ϰ�
 * 2�� �̻��̸�'�������� ���� USING ��'�� �̿��� ����� ���Ѵ�.
 */

--------------------------------------[18. join ���� ���� ��]--------------------------------------

--19. ���������� �̿��Ͽ� major�� '��ǻ�� ����'�� ����� �̸� ��ȸ(test�� test2 ���̺� ��밡��)
--[1] test2 ���̺��� major�� '��ǻ�� ����'�� ����� id �˻�(���� �� �˻� ���ɼ��� ����)
select id
from test2
where major = '��ǻ�� ����';

--[2]
select name
from test
where id in (
	select id
	from test2
	where major = '��ǻ�� ����');

--20. ���տ����� : �� ������ '�÷� ����'�� '������ Ÿ��'�� ��ġ
--20.1 UNION : �� ������ ����� ���� ��ȯ�ϴ� '������'(�ߺ�����)
--             ������ ����� ��ģ �� '�ߺ��� ����'�ϴ� �۾��� �߰��� ����ǹǷ� ������ �ӵ� �� ���ϰ� �߻��Ѵ�.
--             �ߺ��� ������ �ʿ䰡 ������ UNION ALL�� ����ϴ� ���� �ո����̴�.

--(��) employee ���̺� ���
--[1] ������̺��� �޿��� 3000�̻��� ����� ������ �μ���ȣ ��ȸ
select job, dno
from employee
where salary >= 3000;--��� : �ߺ� �����Ͽ� 3�� ROW

--[2] ������̺��� �μ���ȣ�� 10�� ����� ������ �μ���ȣ ��ȸ             
select job, dno
from employee
where dno = 10;--��� : 3�� ROW

--[3-1] �� 2�� ������ ����� �ϳ��� ��(�ߺ� ����)
select job, dno
from employee
where salary >= 3000

UNION

select job, dno
from employee
where dno = 10;--��� : �ߺ� ���ŵǾ� 4�� ROW

--[3-2] �� 2�� ������ ����� �ϳ��� ��(�ߺ� ����X)
select job, dno
from employee
where salary >= 3000

UNION ALL

select job, dno
from employee
where dno = 10;--��� : �ߺ� ����X�Ǿ� 6�� ROW

--20.2 INTERSECT : �� ������ ��� �� '���� ����� ��ȯ'�ϴ� '������'(INTERSECTION)
select job, dno
from employee
where salary >= 3000

INTERSECT

select job, dno
from employee
where dno = 10;

--20.3 MINUS : �� ������ ��� - �� ������ ���  ('������')(�ߺ�����)
--             �� ������ ��� - �յ� �������� ���
--�� EXCEPT : �Ϻ�DBMS������ MINUS ��� ���
select job, dno
from employee
where salary >= 3000

MINUS

select job, dno
from employee
where dno = 10;

----------------------------------------------------------------------------------------------------

--UNION : Ư¡���� ���� ����
--(��1) job���� �޿��� ���հ� Ŀ�̼��� ���� ���ϱ�
select job as "����", SUM(salary) as total_sum, SUM(NVL(commission,0)) as total_sum2
from employee
group by job
--order by job asc;--"�÷���"���� ���� ���� 
--order by "����" asc;--"�÷���Ī"���� ���� ����
order by 1 asc;--"�÷�����"���� ���� ����

--UNION�� ����� ���--"�÷���"���� ���� �Ұ���
--(��1 ����-1)
--[1] �� ���̺� ��Ī ���
select 'salary' as kind1, e1.job as job1, SUM(e1.salary) as total_sum
from employee e1
group by e1.job

UNION

select 'commission' as kind2, e2.job as job2, SUM(NVL(e2.commission,0)) as total_sum2
from employee e2
group by e2.job;

--[2] ���̺� ��Ī ���� ����
select 'salary' as kind, job as "����1", SUM(salary) as total_sum
from employee
group by job

UNION

select 'commission' as kind, e2.job as "����2", SUM(NVL(e2.commission,0)) as total_sum
from employee e2
group by e2.job

ORDER BY kind desc, "����1" asc;--"�� ���̺� �÷���Ī"���� ���� ����
--ORDER BY kind desc, "����2" asc;--"�Ʒ� ���̺� �÷���Ī"���� ���� "�Ұ���"
--ORDER BY 1 desc, 2 asc;--"�÷�����"���� ���� ����

--�ڡ� ORDER BY�� �������� �������� �� 1���� ��밡��
--�ڡ� ORDER BY�� + "�� ���̺��� �÷� ��Ī" �Ǵ� "�÷� ����"�� ��밡��(�ڡ� "�÷���"�� ���� �Ұ���)

--(��1 ����-2) ��� �÷��� ���̺� ��Ī �����ϸ� '1��° �÷� ��ü'�� '�÷���'���� ǥ�õ�
select 'salary', job, SUM(salary)
from employee
group by job

UNION

select 'commission', job, SUM(NVL(commission,0))
from employee
group by job

ORDER BY 1 desc, 2 asc;--"�÷�����"���θ� ���� ����(����?�÷���Ī �����Ƿ�)

--(��2) ��� ���̺�� �μ� ���̺��� �����Ͽ� �μ���ȣ�� �μ��̸��� ��ȸ(�ߺ� ����)
select DISTINCT dno, dname--10 20 30
from employee NATURAL JOIN department;--���� dno�� �ڿ������� ����

--[����] ��� ���̺�� �μ� ���̺� '���ÿ� ���� �μ���ȣ, �μ��̸�' ��ȸ
--(employee�� dno�� department�� dno�� references�� �ƴ� ���� �Ͽ���
--��,'employee�� dno�� �����ϴ� dno�� �ݵ�� department�� dno�� �����Ѵ�'�� ����� �ƴ� ���� �Ͽ��� ���� �ذ���) 

--[���-1] IN ������ �̿�
--[1]
select e.dno--10 20 30
from EMPLOYEE e JOIN DEPARTMENT d
ON e.dno = d.dno;
--[2]
select dno, dname--40 OPERATIONS
from department
where dno NOT IN (select e.dno--10 20 30
			      from EMPLOYEE e JOIN DEPARTMENT d
			      ON e.dno = d.dno);
			      
--[���-2] join���-1 �̿�   
--[1] �� ���̺� �����ϴ� �μ� ��ȣ Ȯ��  
select distinct dno-- 10 20 30
from employee; 

select distinct dno-- 10 20 30 40
from department; 

--[2] e.dno�� d.dno�� ����.
select DISTINCT e.dno, dname--10 20 30(���ÿ�)
from employee e, department d
where e.dno = d.dno; 

--[3] ��e.dno�� d.dno�� �ٸ���.
select * --���̺��� ��� ������ �� �� �˻������� �����ϱ�
from employee e, department d
where e.dno(+) = d.dno;

--[4] ��e.dno�� d.dno�� �ٸ���.
select *  --DISTINCT d.dno, dname 
from employee e, department d
WHERE e.dno(+) = d.dno--��������
AND e.dno IS NULL;    --�˻�����-���-1
--AND eno IS NULL;  --�˻�����-���-2 ���
--outer join�� ������ null�� ����Ͽ� employee ���̺� �������� �ʴ� �μ���ȣ ���		

--[5]
select DISTINCT d.dno, dname 
from employee e, department d
WHERE e.dno(+) = d.dno--��������
AND ename IS NULL; 

--[���-3] join���-1 �̿�
select DISTINCT d.dno, dname 
from employee e, department d
WHERE e.dno(+) = d.dno--��������
--(10 20 30 40) NOT IN (10 20 30)  => 40�� true
AND d.dno NOT IN(select distinct dno
				 from employee); 
--�˻�����(�μ����̺��� �μ���ȣ�� ������̺��� �μ���ȣ �� ������ ���� ���� TRUE)

--[���-4] join���-1 �̿�
select DISTINCT d.dno, dname 
from employee e, department d
WHERE e.dno(+) = d.dno--��������
--(10 20 30 40) != ALL(10 20 30)  => 40�� true
AND d.dno != ALL(select distinct dno
			     from employee); 				
                 
--[���-4] join���-2 �̿� 
select DISTINCT d.dno, dname 
from employee e RIGHT OUTER JOIN department d
ON e.dno = d.dno--��������
WHERE e.dno IS NULL;  

--< ���� : ����Ŭ ���� ���� >
--from -> where -> group by -> having -> select �÷����� ��Ī -> order by
--[���-5] EXISTS �̿�
select dno, dname
from department d
where NOT EXISTS (select dno -- 40=>true
                  from employee --��Ī �����ص� ��
                  where d.dno = dno);                  
                
                  
--[���-6] : MINUS + JOIN �̿� {10, 20, 30, 40} - {10, 20, 30} = {40}
select dno, dname
from department

MINUS

select dno, dname
from employee JOIN department
USING(dno);

--[���-7] : INTERSECT �̿� {10, 20, 30, 40} - {10, 20, 30} = {40}
--[1] 
select dno from employee
INTERSECT
select dno from department;

--[2]
select dno, dname
from department
WHERE dno NOT IN (select dno from employee
				  INTERSECT
				  select dno from department);
---------------------------------------------------------------------------------------------------                                         

-- UNION ��� : ���� �ٸ� ���̺��� ����� ������ ����� ���ļ� ��ȸ
--             select���� �÷��� ������ �� �÷��� ������ Ÿ�Ը� ��ġ�ϸ� �ȴ�.   

--(��) �հ踦 ���� �����Ͽ� ��ȸ ����� ��ġ�� �뵵�� UNION ALL ���
--[1] �� ���� �� �޿� ���� ��ȸ
select job, SUM(salary)
from employee
group by job;

--[2] ��ü ����� �޿� ���� ��ȸ
select SUM(salary)
from employee;

--[1]+[2]		
select job, SUM(salary) as "�޿�"
from employee
group by job		  

UNION ALL

select '�հ�', SUM(salary)
from employee;

--(��)�ڡ� ������̺��� '���� ���� 3��'�� �̸�, �޿� ��ȸ(��, �޿��� ������ ����̸����� �������� ����)
--(�ذ� ��) UNION ALL �̿�
--delete employee where ename='ȫ�浿';
select ename, salary
from employee
where rownum <= 3
order by salary desc;--���ϴ� ����� �ȳ���(����:rownum��ȣ�� insert�� ������ �Ű���)

--[���-1] : 5000 3000 3000
--[1]
select ename, salary from employee where dno=10
UNION ALL
select ename, salary from employee where dno=20
UNION ALL
select ename, salary from employee where dno=30
UNION ALL
select ename, salary from employee where dno=40
ORDER BY 2 desc, 1 asc;--"�÷�����"���θ� ���� ����

--[2]
select *
from (  select ename, salary from employee where dno=10
		UNION ALL
		select ename, salary from employee where dno=20
		UNION ALL
		select ename, salary from employee where dno=30
		UNION ALL
		select ename, salary from employee where dno=40
		ORDER BY 2 desc, 1 asc)
where rownum <= 3;	

--[3-1]
select rownum, ename, salary
from (  select ename, salary from employee where dno=10
		UNION ALL
		select ename, salary from employee where dno=20
		UNION ALL
		select ename, salary from employee where dno=30
		UNION ALL
		select ename, salary from employee where dno=40
		ORDER BY 2 desc, 1 asc)
--where rownum <= 3;
--where rownum < 4;	
where rownum = 1 or rownum = 2 or rownum = 3;

--[3-2]
select rownum, ename, salary
from (  select ename, salary from employee where dno=10
		UNION ALL
		select ename, salary from employee where dno=20
		UNION ALL
		select ename, salary from employee where dno=30
		UNION ALL
		select ename, salary from employee where dno=40
		ORDER BY 2 desc, 1 asc)
where rownum IN (1,2,3);	

--[3-3] *�� ����Ϸ��� 
select rownum, e.*
from (  select ename, salary from employee where dno=10
		UNION ALL
		select ename, salary from employee where dno=20
		UNION ALL
		select ename, salary from employee where dno=30
		UNION ALL
		select ename, salary from employee where dno=40
		ORDER BY 2 desc, 1 asc) e--�ݵ�� ���̺� ��Ī ���
where rownum IN (1,2,3);	

--[���-2] rank() �Լ� + UNION ALL �̿�
--[1]
select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "���"
from employee;

--[2]
select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "���"
      from employee)
where "���"=1

UNION ALL

select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "���"
      from employee)
where "���"=2

UNION ALL

select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "���"
      from employee)
where "���"=3;
---------------------------------------------------------------------------------
--[�ذ� ��] UNION ALL �̿�X, ROWNUM�̳� RANK()�� ���
--[���-1] RANK()�� ���
select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "���"
      from employee)
where "���" <= 3;

--[���-2] ROWNUM�� ���
select *
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "���"
      from employee)
where ROWNUM <= 3;

--ROWNUM���� ����Ϸ���(*�� ���)
select ROWNUM, e.*
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) AS "���"
      from employee) e--�ݵ�� ���̺� ��Ī ���
where ROWNUM <= 3;

--[���-2-1] ROW_NUMBER()�� �̿��Ͽ� rownum ���� �����
--(=>��, insert�� ������ �ƴ϶� ���� ���� ������ rownum ��ȣ �����)
--[1]
select ROW_NUMBER() OVER(order by salary desc, ename asc) as ROW_NUM, ename, salary
from employee;

--[2] ����
select ROW_NUMBER() OVER(order by salary desc, ename asc) as ROW_NUM, ename, salary
from employee
where ROW_NUM <= 3;--���� ORA-00904: "ROW_NUM": invalid identifier (ROW_NUM ��Ī ���Ұ�)
--�ڡ� ��Ī ���Ұ� ����? '����Ŭ �������' ������
--(from -> where -> group by -> having -> select -> order by)

--[2]
select *
from (select ROW_NUMBER() OVER(order by salary desc, ename asc) as ROW_NUM, ename, salary
      from employee)
where ROW_NUM <= 3;

--[���-3] : ROWNUM�� RANK() �Բ� ���
--[1] ROWNUM : indert�� ����, RANK:salary ū ����->ename ���ĺ� ��
select ROWNUM, ename, salary, RANK() OVER(order by salary desc, ename asc) as "���"
from employee
where ROWNUM <= 3;--���ϴ� ����� �ƴ�
--���� ��� �ؼ� : ROWNUM 1,2,3�� �˻��� ���̺��� rank() �Լ� ������ ����� ����

--[2] ROWNUM�� RANK() ������ ���� �����.
--[2-1] 
select ROWNUM, ename, salary, "���"
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) as "���"
      from employee)
WHERE "���" <= 3;

--[2-2] 
select ROWNUM, e.*
from (select ename, salary, RANK() OVER(order by salary desc, ename asc) as "���"
      from employee) e
WHERE ROWNUM <= 3;



