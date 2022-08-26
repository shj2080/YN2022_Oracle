--<�Ͻ�-7��. ��������>
--[����] 'SCOTT'���� �޿��� ���� �޴� ����� ������ �޿� ��ȸ
--[1]. �켱 'SCOTT'�� �޿��� �˾ƾ� ��
select salary
from employee
where ename='SCOTT';--3000

--[2]. �ش�޿� 3000���� �޿��� ���� ����� ������ �޿� �˻�
select ename, salary
from employee
where salary > 3000;

--[3]. [2]�������� - [1]��������
select ename, salary
from employee
where salary > (select salary
				from employee
				where ename='SCOTT');
				--������������ ������ ���(3000)�� ���������� ���޵Ǿ� ���� ����� ���
				
--���� �� �������� : ���μ����������� ����� �� '1��'
--               ������ �񱳿�����(>,<,=,>=,<=), IN������
--               (��) salary > 3000
--                   salary = 3000�� salary IN(3000)�� ���� ǥ��

--���� �� �������� : ���μ����������� ����� �� '1�� �̻�'
--               ������ �񱳿�����(IN, any, some, all, exists)
--               (��) salary IN(1000, 2000, 3000)

--1. ���� �� ��������
--[����] 'SCOTT'�� ������ �μ����� �ٹ��ϴ� ����̸�, �μ���ȣ ��ȸ
--[1]. �켱 'SCOTT'�� �μ���ȣ �˱�
select dno
from EMPLOYEE
where ename='SCOTT';--20		
				
--[2]. �ش�μ���ȣ(=20)�� ���� ����̸�, �μ���ȣ �˻�
select ename, dno
from employee
where dno = (select dno
			from EMPLOYEE
			where ename='SCOTT');--�������� ��� : 1��	
			
select ename, dno
from employee
where dno IN (select dno
			from EMPLOYEE
			where ename='SCOTT');--�������� ��� : 1�� �̻�=�������� ����
			
--�� ������� 'SCOTT'�� �Բ� ��ȸ��. 'SCOTT'�� �����ϰ� ��ȸ�Ϸ���			
select ename, dno
from employee
where dno = (select dno
			from EMPLOYEE
			where ename='SCOTT')
AND ename != 'SCOTT';--���� �߰�
				
select ename, dno
from employee
where dno = 20 AND ename != 'SCOTT';	

--[����] ȸ�� ��ü���� '�ּ� �޿�'�� �޴� ����� �̸�, ������(job), �޿� ��ȸ
--[1]. �ּ� �޿� ���ϱ�
select MIN(salary)
from employee;--800

--[2]. ���� �ּұ޿�(800)�� �޴� ����� �̸�, ������(job), �޿� ��ȸ
select ename, job, salary
from employee
where salary = (select MIN(salary)--�������� ��� : 1��
				from employee);
--where salary = 800;
				
select ename, job, salary
from employee
where salary IN (select MIN(salary)
				 from employee);						
--where salary IN(800);	

--2. ���� �� ��������
--1) IN ������ : ���������� �����ǿ��� ���������� ��°���� '�ϳ��� ��ġ�ϸ�'
--             ���������� where���� true
--�� ���� �Ǵ� ���� �� �������� �Ѵ� ��밡����

--[����]�ڡڡ� "�μ��� �ּ� �޿�"�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ	
--[���-1]		
--[1]."�μ��� �ּ� �޿�"�� ���ϱ�
select min(salary)
from EMPLOYEE
group by dno;--���������� �� ����� ���ǹ��ϴ�.

--[2]."�μ��� �ּ� �޿�"�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
select dno, eno, ename, salary
from EMPLOYEE
WHERE salary IN (select min(salary)--dno ������
				 from EMPLOYEE
				 group by dno)--IN( 1300,800,950 )
order by 1;

select dno, eno, ename, salary
from EMPLOYEE
WHERE salary IN (950, 800, 1300)
order by 1;

--[���-2]
--[1]."�μ��� �ּ� �޿�"�� ���ϱ�(dno���� ǥ��)
select dno, min(salary)--3:3
from EMPLOYEE
group by dno;--��� : (10,1300),(20,800),(30,950)

--[2-1]��������  �̿�: �ڡڡ� "�μ��� �ּ� �޿�"�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
select dno, eno, ename, salary
from EMPLOYEE
WHERE (dno ,salary) IN (select dno, min(salary)--IN( (10,1300),(20,800),(30,950) )
				        from EMPLOYEE
				        group by dno)
order by 1;

select dno, eno, ename, salary
from EMPLOYEE
WHERE (dno, salary) IN ((10,1300),(20,800),(30,950))
order by 1;

--[2-2] join ���-1 �̿�
--[1]
select dno, min(salary)
from employee
group by dno;

--[2]
select *
from employee e1, (select dno, min(salary)
					from employee
					group by dno) e2
where e1.dno = e2.dno --��������
order by e1.dno;

--[3]
select e1.dno, eno, ename, salary
from employee e1, (select dno, min(salary) as "minSalary"
					from employee
					group by dno) e2
where e1.dno = e2.dno --��������
--AND salary = min(salary)  --�˻�����=>����?(where������ min()�Լ� ����Ͽ�)
--[�����ذ�]��Ī ���
AND salary = "minSalary"
order by e1.dno;

--[2-3] join ���-2 �̿�----
select e1.dno, eno, ename, salary
from employee e1 JOIN (select dno, min(salary) as "minSalary"
					from employee
					group by dno) e2
ON e1.dno = e2.dno --��������
WHERE salary = "minSalary"	--�˻�����
order by e1.dno;

--[2-4] join ���-3 �̿� : dno�� �ڿ����� -> ��������X, �ߺ�����->��ĪX
select dno, eno, ename, salary
from employee natural JOIN (select dno, min(salary) as "minSalary"
					from employee
					group by dno)
WHERE salary = "minSalary"	--�˻�����
order by dno;

--[2-5] join ���-4 �̿� : �ߺ�����->��ĪX
select dno, eno, ename, salary
from employee JOIN (select dno, min(salary) as "minSalary"
					from employee
					group by dno)
USING(dno)--��������
WHERE salary = "minSalary"	--�˻�����
order by dno;
----------------------------------------------------------------------------------------

--[�� ������ '���-1'�� �������� 'min(salary)�� ���'�Ϸ���]
select min(salary)
from employee; --��ü ��� ���̺��� ����̹Ƿ� 1�׷�

select dno, min(salary) -- 14:1 ��Ī�Ұ�=>����
from employee;

select dno, min(salary) --dno 3�׷� : 3
from employee
GROUP BY dno
order by 1;

select dno, eno, ename, salary, min(salary) --"�׷��Լ� ���"�Ϸ���
from employee
GROUP BY dno, eno, ename, salary--GROUP BY�� �ڿ� �ݵ�� ����� �÷��� ����(�׷��Լ� ����)
order by 1;

select dno, eno, ename, salary, min(salary)
from employee
WHERE salary IN (950, 800, 1300) --�˻�����
GROUP BY dno, eno, ename, salary
order by 1;
--[����]
select dno, eno, ename, salary, min(salary)
from employee
WHERE salary IN (select min(salary)
				from employee
				group by dno)
GROUP BY dno, eno, ename, salary
order by 1;
----------------------------------------------------------------------------

--2) ANY ������ : ���� ������ ��ȯ�ϴ� ������ ���� ��
--WHERE �÷��� = any(���������� ���1, ���2) => ����� �� '�ƹ��ų��� ����'�� TRUE.
--WHERE �÷��� IN(���������� ���1, ���2) => ����� �� '�ƹ��ų��� ����'�� TRUE.

--���� : A���� OR B����
--������ : ���� �����ϴ� ������ ����� �� ��ħ

--WHERE �÷��� < any(���������� ���1, ���2) => ����� �� "�ִ밪"���� ������ TRUE.
--WHERE �÷��� > any(���������� ���1, ���2) => ����� �� "�ּҰ�"���� ũ�� TRUE.

--[����]�ڡڡ� "�μ��� �ּ� �޿�"�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
--[2-6] =ANY �̿�
--[1]."�μ��� �ּ� �޿�"�� ���ϱ�(dno���� ǥ��)
select dno, min(salary)--3:3
from EMPLOYEE
group by dno;--��� : (10,1300),(20,800),(30,950)

--[2-1]��������  �̿�: �ڡڡ� "�μ��� �ּ� �޿�"�� �޴� ����� �μ���ȣ, �����ȣ, �̸�, �ּұ޿��� ��ȸ
select dno, eno, ename, salary
from EMPLOYEE
WHERE (dno ,salary) = any(select dno, min(salary)-- =ANY( (10,1300),(20,800),(30,950) )
				        from EMPLOYEE
				        group by dno)
order by 1;

--���� : WHERE (dno, salary) = ANY( (10,1300),(20,800),(30,950) )
--		WHERE (dno, salary)   IN ( (10,1300),(20,800),(30,950) )
--		���������� ��� �� '�ƹ��ų��� ����'�� TRUE

--���� : WHERE salary != ANY(1300, 800, 950)
--		WHERE salary <> ANY(1300, 800, 950)
--		WHERE salary ^= ANY(1300, 800, 950)

--		WHERE salary NOT IN(1300, 800, 950)
--		���������� ��� �� '��� �͵� �ƴϸ�' TRUE

--���� : WHERE salary < ANY(1300, 800, 950) �������� ����� �� "�ִ밪(1300)"���� ������ TRUE.
--		WHERE salary > ANY(1300, 800, 950) �������� ����� �� "�ּҰ�(800)"���� ũ�� TRUE.
--(��1)
select eno, ename, salary
from employee
where salary < ANY(1300, 800, 950)
order by 1;
--		salary < ANY(1300, 800, 950)
--		salary < 1300
--		salary < 800
--		salary < 950
--�ᱹ	salary < 1300(�ִ밪)�� ������ ������ ������ �� ������

--(��2)
select eno, ename, salary
from employee
where salary < ANY(1300, 800, 950)
order by 1;
--		salary > ANY(1300, 800, 950)
--		salary > 1300
--		salary > 800
--		salary > 950
--�ᱹ	salary > 800(�ּҰ�)�� ������ ������ ������ �� ������


--[����] ������ SALESMAN�� �ƴϸ鼭
--�޿��� ������ SALESMAN���� ���� ����� ����(����̸�, ����, �޿�) ���
--(�������� = '����'���� �ؼ�)
--[1]. ������ SALESMAN�� �޿� ���ϱ�
select DISTINCT salary	--��� :  1600 1250 1250 1500�ߺ�����
from employee
where job = 'SALESMAN'; --->��� : 1250 1600 1500

--[2]
select ename, job, salary
from employee
where job != 'SALESMAN'
AND salary < any(select distinct salary
				 from employee
				 where job = 'SALESMAN');
-- salary < ANY(1250 1600 1500)�� �������� ��� �� '�ִ밪'���� ������ ��

--�� ����� ����
--[1]. ������ SALESMAN�� �޿� ���ϱ�=>'������ SALESMAN�� �ִ�޿� ���ϱ�'
select MAX(salary)
from employee
where job = 'SALESMAN';--1600

--[2]
select ename, job, salary
from employee
where job != 'SALESMAN'
AND salary < (select MAX(salary)
				from employee
				where job = 'SALESMAN');
----------------------------------------------------------------------------

--3) ALL ������ : ���� �������� ��ȯ�Ǵ� ��� ���� ��
--���� : A���� and B����
--������ : ��� ������ ���ÿ� �����ϴ� ��
				
--���� : WHERE �÷��� < any(1300, 800, 950) => �������� �� "�ִ밪(1300)"���� ������ TRUE.
--		WHERE �÷��� > any(1300, 800, 950) => �������� �� "�ּҰ�(800)"���� ũ�� TRUE.
		
--���� : WHERE �÷��� < ALL(1300, 800, 950) => �������� �� "�ּҰ�(800)"���� ������ TRUE.
--		WHERE �÷��� > ALL(1300, 800, 950) => �������� �� "�ִ밪(1300)"���� ũ�� TRUE.		
				

--[����] ������ SALESMAN�� �ƴϸ鼭
--�޿��� ��� SALESMAN���� ���� ����� ����(����̸�, ����, �޿�) ���
--[1]. ������ SALESMAN�� �޿� ���ϱ�
select DISTINCT salary	--��� :  1600 1250 1250 1500�ߺ�����
from employee
where job = 'SALESMAN'; --->��� : 1250 1600 1500

--[2]
select ename, job, salary
from employee
where job != 'SALESMAN'
AND salary < ALL(select distinct salary
				 from employee
				 where job = 'SALESMAN');
-- salary < ALL(1250 1600 1500)�� �������� ��� �� '�ּҰ�(1250)'���� ������ ��

--�� ����� ����
select min(salary)
from employee
where job = 'SALESMAN';

select ename, job, salary
from employee
where job != 'SALESMAN' AND salary < (select min(salary)
									from employee
									where job = 'SALESMAN');

---------------------------------------------------------------------------
--4) EXISTS ������ : EXISTS=�����ϴ�.
select
from
where EXISTS (��������);
--������������ ������ �����Ͱ� 1���� �����ϸ� true -> �������� ����
--					  1���� �������� ������ false -> �������� ����X			

select
from
where NOT EXISTS (��������);
--������������ ������ �����Ͱ� 1���� �������� ������ true -> �������� ����
--					  1���� �����ϸ� false -> �������� ����X			

--[����-1] ������̺��� ������ 'PRESIDENT'�� ������ ��� ����̸��� ���, ������ ��¾���
--�� ������ �� : ������ �����ϴ� ����� ������ ���������� �����Ͽ� ����� ���

--[1] ������̺��� ������ 'PRESIDENT'�� ����� �����ȣ ��ȸ
select eno
from employee
where job = 'PRESIDENT';

--[2]
select ename
from employee
where EXISTS (select eno --7839
			from employee
			where job = 'PRESIDENT');

--�� ������ �׽�Ʈ�ϱ� ���� ������ 'PRESIDENT'�� ��� ���� �� �ٽ� [2]���� => ��� ����(�����ƴ�)
delete
from employee
where job = 'PRESIDENT';

--�ٽ� �ǵ����� ���� ������ 'PRESIDENT'�� ��� �߰��ϱ�
INSERT INTO EMPLOYEE
VALUES(7839,'KING','PRESIDENT', NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);

--[�� ������ "job�� 'SALESMAN'�̸鼭" ��� �˻������� �߰�]
--������ AND ���� : �� ������ ��� ���̸� ��
SELECT ENAME
from employee
where job='SALESMAN' AND EXISTS (select eno --7839
								from employee
								where job = 'PRESIDENT');
--��� : 4�� AND 14�� => ���ÿ� ���� 4�� 

--[�� ������ "job�� 'SALESMAN'�̰ų�" ��� �˻������� �߰�]
--������ OR ���� : �� ���� �� �ϳ��� ���̸� ��
SELECT ENAME
from employee
where job='SALESMAN' OR EXISTS (select eno --7839
								from employee
								where job = 'PRESIDENT');
--��� : 4�� OR 14�� => 14��

--[NOT EXISTS] 
--������ AND ���� : �� ������ ��� ���̸� ��
SELECT ENAME
from employee
where job='SALESMAN' AND NOT EXISTS (select eno --7839
								from employee
								where job = 'PRESIDENT');
--��� : 4�� AND 0�� => ���ÿ� ���� 0�� 
								
--������ OR ���� : �� ���� �� �ϳ��� ���̸� ��
SELECT ENAME
from employee
where job='SALESMAN' OR NOT EXISTS (select eno --7839
								from employee
								where job = 'PRESIDENT');
--��� : 4�� OR 0�� => 4��								

--[����-1] : ������̺�� �μ����̺��� ���ÿ� ����(�������� ����) �μ���ȣ, �μ��̸� ��ȸ
--(employee�� dno�� department�� dno�� references�� �ƴ� ���� �Ͽ���
--��, 'employee�� dno�� �����ϴ� dno�� �ݵ�� department�� dno�� �����Ѵ�'��
--����� �ƴ� ���� �Ͽ��� ���� �ذ���)
--[���-1] IN ������ ���
select dno, dname
from department
where dno NOT IN(select distinct dno --10 20 30
				from employee);
				
------------------------------------------------------------------		
--[���-2] join���-1 �̿�
--[1] �� ���̺� �����ϴ� �μ� ��ȣ Ȯ��
select distinct dno
from employee; -- 10 20 30

select distinct dno, dname
from department; -- 10 20 30 40

--[2] e.dno�� d.dno�� ����.
select distinct e.dno, dname--10 20 30(���ÿ�)
from employee e, department d
where e.dno = d.dno;

--[3] ��e.dno�� d.dno�� �ٸ���.
select *--���̺��� ��� ������ �� �� �˻������� �����ϱ�
from employee e, department d
where e.dno(+) = d.dno;

select distinct d.dno, dname--10 20 30(���ÿ�) + �μ����̺��� 40 ���� ǥ��
from employee e, department d
where e.dno(+) = d.dno;

--[4] ��e.dno�� d.dno�� �ٸ���.
select distinct d.dno as ddno, dname 
from employee e, department d
where e.dno(+)=d.dno	--��������
AND e.dno IS NULL;		--�˻�����-���-1
--AND eno is null;		--�˻�����-���-2 ���
--outer join�� ������ null�� ����Ͽ� employee ���̺� �������� �ʴ� �μ���ȣ ���

--[���-3] join���-1 �̿�
select distinct d.dno, dname 
from employee e, department d
where e.dno(+)=d.dno	--��������
--(10 20 30 40) NOT IN (10 20 30)  => 40�� TRUE
AND d.dno NOT IN(select distinct dno
				from employee);
--�˻�����(�μ����̺��� �μ���ȣ�� ������̺��� �μ���ȣ �� ������ ���� ���� TRUE)

--[���-4] join���-1 �̿�
select distinct d.dno, dname 
from employee e, department d
where e.dno(+)=d.dno	--��������
--(10 20 30 40) != ALL(10 20 30)  => 40�� TRUE
AND d.dno != ALL(select distinct dno
				from employee);
--�˻�����(�μ����̺��� �μ���ȣ�� ������̺��� �μ���ȣ �� ������ ���� ���� TRUE)

--[���-4] join���-2 �̿�
select distinct d.dno, dname 
from employee e RIGHT OUTER JOIN department d
ON e.dno = d.dno	--��������
WHERE e.dno IS NULL;

--< ���� : ����Ŭ ���� ���� >
--from -> where -> group by -> having -> select �÷����� ��Ī -> order by
--[���-5] EXISTS �̿�
select dno, dname
from department d
where NOT EXISTS (select dno	-- 40=>true
				 from employee--��Ī �����ص� ��
				 where d.dno = dno);

--[���-6] : MINUS �̿� {10, 20, 30, 40} - {10, 20, 30} = {40}
SELECT dno, dname
from department

MINUS

select dno, dname
from employee JOIN department
USING(dno);


-------------------------------------------------------------------

select d.dno, dname
from employee e, department d
where e.dno(+) = d.dno
AND e.dno IS NULL;

select d.dno, dname
from employee e RIGHT OUTER JOIN department d
ON e.dno = d.dno
where e.dno IS NULL;


--<7��.��������-ȥ���غ���>----------------------------------
--1.�����ȣ�� 7788�� ����� '�������� ����' ����� ǥ��(����̸��� ������)
--[1]. �����ȣ�� 7788�� ����� '������' ��ȸ
select job --��� 1��(ANALYST)
from employee
where eno = 7788;

--[2-1]
select ename, job
from employee
where job = (select job -- = : ����������� 1��(ANALYST)
			from employee
			where eno = 7788);

--[2-2]
select ename, job
from employee
where job IN (select job -- IN : ����������� 1�� �̻��� ��
			from employee
			where eno = 7788);

--[2-3]
select ename, job
from employee
where job = ANY (select job -- ANY : ����������� 1�� �̻��� ��
			from employee
			where eno = 7788);

--[2-4]
select ename, job
from employee
where job = ALL (select job -- ALL : ����������� 1�� �̻��� ��
			from employee
			where eno = 7788);

--2.�����ȣ�� 7499�� ������� �޿��� ���� ����� ǥ��(����̸��� ������)
--[1]. �����ȣ�� 7499�� ����� �޿� ��ȸ
select salary --1600
from employee
where eno = 7499;
			
--[2]
select ename, job
from employee
where salary > (select salary --1600
				from employee
				where eno = 7499);

--3.�ּұ޿��� �޴� ����� �̸�, ��� ���� �� �޿� ǥ��(�׷��Լ� ���)
--[1]. ������̺��� �ּұ޿��� ��ȸ
select min(salary) --800(��� 1��)
from employee;

--[2] 
select ename, job, salary
from employee
where salary = (select min(salary) --800(��� 1��) =��� IN, =ANY, =ALL ��밡��
				from employee);

--4.'���޺�' ��� �޿��� ���� ���� ��� ������ ã�� '����(job)'�� '��� �޿�' ǥ��
--��, ����� �ּұ޿��� �ݿø��Ͽ� �Ҽ�1°�ڸ����� ǥ��

--[���-1]
--[1]. '���޺�' ��� �޿� �� ���� ���� ��ձ޿��� ���Ѵ�.
--����, �����ü�� ��� �޿� ���ϱ�
select avg(salary), 
round(avg(salary), 1) -- �Ҽ� 2°�ڸ����� �ݿø��Ͽ� �Ҽ�1°�ڸ����� ǥ��
from employee;
				
--�����ü�� ��� �޿��� �ּҰ� ���ϸ�
select MIN(avg(salary))
from employee;--����?ORA-00978: nested group function without GROUP BY

select job, avg(salary) --job : avg(salary) = 5 : 5 ��ġ
from employee
group by job;--1037.5

select job, MIN(avg(salary)) --����?job : MIN(avg(salary)) = 5 : 1 ��ġ�ȵ�
from employee
group by job;--1037.5

--[�� ������ �ذ��ϱ� ���ؼ� job�� ��ȸ���� ����]
--�ڡ� �׷��Լ��� 2�������� ��ø���
--�׷��Լ� : MIN(), avg()
--�� ROUND�� �׷��Լ��� �ƴϴ�.
select ROUND(MIN(avg(salary)), 1) --1073.5
from employee
group by job;

--[2]. ����-1 : ��ձ޿��� 1037.5�� ���� job�� ���� �� �ִٸ� ���� �� ��µ�
select job, avg(salary), round(avg(salary), 1) as "��ձ޿�"
from employee
group by job
having round(avg(salary), 1) = (select round(min(avg(salary)), 1)
								 from employee
								 group by job);


 --[2]. ����-1 : HAVING���� ��Ī����ϸ� ����
select job, avg(salary), round(avg(salary), 1) as "��ձ޿�"
from employee
group by job
having "��ձ޿�" = (select round(min(avg(salary)), 1) --1037.5
				 from employee
				 group by job);
--����? ORA-00904: "��ձ޿�": invalid identifier
/*
 * < ���� : ����Ŭ ���� ���� >
 * from -> where -> group by -> having -> select �÷����� ��Ī -> order by
 */

--[���-2] : ��, ������ ��ձ޿��� �ٸ� ���� ����
--[1]
select job, avg(salary) as "��ձ޿�"--5:5
from employee
group by job
order by "��ձ޿�" asc; --���� : ���� ���� ��ձ޿��� 1��° �ٿ� �������� ����

--[2]. ����-2 : ��ձ޿��� 1037.5�� ���� job�� ���� �� �־ 1���� ��µ�
select *
from (select job, avg(salary) as "��ձ޿�"--5:5
		from employee
		group by job
		order by "��ձ޿�" asc)
where rownum = 1; --���� : 1��° �ٸ� ǥ��


--5.�� �μ��� �ּ� �޿��� �޴� ����� �̸�, �޿�, �μ� ��ȣ ǥ��
--[���-1]
--[1]. �μ��� �ּ� �޿� ���ϱ�
select dno, min(salary)--(10, ),(20, ),(30, ) ������ ���
from employee
group by dno;

--[2]
select ename, salary, dno
from employee
where (dno, salary) IN (select dno, min(salary)--(10, ),(20, ),(30, ) ������ ���
						from employee
						group by dno);

--[���-2]
--[1]. �μ��� '�ּ� �޿�'�� ���ϱ�
select min(salary)	--(950),(800),(1300) ������ ���
from employee
group by dno;

--[2]
select ename, salary, dno
from employee
where salary IN (select min(salary)	--(950),(800),(1300) ������ ���
						from employee
						group by dno);

--[����Ǯ��]
select ename, salary, e1.dno
from employee e1, (select dno, min(salary) as "minSalary"
					from employee
					group by dno) e2
where e1.dno = e2.dno
AND salary = "minSalary";


--6.'��� ������ �м���(ANALYST)�� ������� �޿��� �����鼭 ������ �м����� �ƴ�' 
--������� ǥ��(�����ȣ, �̸�, ��� ����, �޿�)
--[1]. '��� ������ �м���(ANALYST)�� ����� �޿� ���ϱ�
select salary
from employee
where job = 'ANALYST';

--[2]
select eno, ename, job, salary
from employee
where salary < ALL(select salary
					from employee
					where job = 'ANALYST')-- salary < ALL(3000, 3000)
AND job != 'ANALYST';
--AND job <> 'ANALYST';
--AND job ^= 'ANALYST';

--AND job NOT LIKE 'ANALYST';


--�ڡ�7.���������� ���� ����̸� ǥ��(���� '���� 8. ���������� �ִ� ����̸� ǥ��'���� Ǯ��)
select * from employee;

--[���-1] : ��������
--[���-1-1] : IN ������
--[���-1-1-1]
--[1]. ���������� �ִ� �����ȣ ã��
select manager--(�ߺ�)
from employee
where manager IS NOT NULL;

select distinct manager --13��(�ߺ�)->(�ߺ�����)6���� 1�� �̻��� ���������� ����
from employee
where manager IS NOT NULL;

--[2]. ���������� ���� ��� : 8��
select eno, ename
from employee
where eno NOT IN (select distinct manager
			 from employee
			 where manager IS NOT NULL);

select ename
from employee
where eno NOT IN (7839, 7782, 7698, 7902, 7566, 7788);

--[���-1-1-2]
--[1]. ���������� �ִ� �����ȣ ã�� : where�� ��� NVL()�Լ��� NULL�� 0���� ó��
select distinct manager
from employee;

select distinct NVL(manager, 0)
from employee;

--��������ȣ(manager �÷�)�� �ڽ��� �����ȣ(eno)�� ������ ���������� ���� ����� ��.
--�� ���������� ��� �� null�� ������ ����� �ȳ���
select ename
from employee
where eno NOT IN (select distinct manager
			 from employee);
			 
-->���� ������ �ذ��ϱ� ���� : ����, NVL()�Լ��� null���� ó��
select ename
from employee
where eno NOT IN (select distinct NVL(manager, 0)
			 from employee);

select ename
from employee
where eno NOT IN (7839, 7782, 7698, 7902, 7566, 7788, 0);	

--[���-1-2(�߸��� ���)] : !=ANY ������ (����� '14�� ���' ����)
--ANY ���� : �����ϴ� �� �ϳ��� ������ �� (�� ALL ���� : ��� ���� �����ؾ� ��)
-- eno {1,2,3,4,5}���
--(1)eno = ANY (1,2,3) : eno�� ANY���� ���� ���� �ϳ��� ������ true 
--   => ��ȸ��� : {eno �� ANY�� 1�� ���� ��} U {eno �� ANY�� 2�� ���� ��} U {eno �� ANY�� 3�� ���� ��}
--              = {1} U {2} U {3}
--              = ��, eno {1,2,3} ��ȸ

--(2)eno > ANY (1,2,3) : eno�� ANY������ ū ���� �ϳ��� ������ true
--   => ��ȸ��� : {eno �� ANY�� 1���� ū ��} U {eno �� ANY�� 2���� ū ��} U {eno �� ANY�� 3���� ū ��}
--             = {2,3,4,5} U {3,4,5} U {4,5}              
--               ��, eno {2,3,4,5}��ȸ =  eno���� "�ּҰ�1"���� ū eno ��ȸ

--(3)eno < ANY (1,2,3) : eno�� ANY������ ���� ���� �ϳ��� ������ true
--   => ��ȸ��� : {eno �� ANY�� 1���� ���� ��} U {eno �� ANY�� 2���� ���� ��} U {eno �� ANY�� 3���� ���� ��}
--             = ������ U {1} U {1,2}              
--               ��, eno {1,2}��ȸ = eno���� "�ִ밪3"���� ���� eno ��ȸ

--(4)eno != ANY (1,2,3) : eno�� ANY���� �ٸ����� �ϳ��� ������ true
--   => ��ȸ��� : eno���� 1�� �ٸ� eno ��ȸ {2,3,4,5} U
--               eno���� 2�� �ٸ� eno ��ȸ {1,3,4,5} U
--               eno���� 3�� �ٸ� eno ��ȸ {1,2,4,5} U
--               eno���� 4�� �ٸ� eno ��ȸ {1,2,3,5} U
--               eno���� 5�� �ٸ� eno ��ȸ {1,2,3,4} U
--      = {2,3,4,5} U {1,3,4,5} U {1,2,4,5} U {1,2,3,5} U {1,2,3,4} 
--      = {1,2,3,4,5} ANY�� ���� �� ��� ��ġ���� �ʴ� �����͸� ��ȸ�ȴ�.
-- �ص���, "�÷��� != ANY (��)"������ ANY�� ���� 2�� �̻��� ��� �ش� ������ �ǹ̰� ����, ��� �����Ͱ� ��ȸ�ȴ�.
-- ������ ���� "�÷��� !=ANY (��)" �� 
--  "��������������� �ϳ�"�� ���� ���(����?2�� �̻��� ���� ��� �����Ͱ� ��ȸ�ǹǷ�...)
select ename
from employee
where eno != ANY (select distinct NVL(manager, 0)
			 from employee);
-- 7369 != 7839�ƴ� ��� ?
-- ��ü 14�� �� != 7782�ƴ� ��� 13��...
-- ��ü 14�� �� != 0   �ƴ� ��� 14��
-- ������ : �ߺ� �����ϰ� ��� �����ϸ� 14���� ����� ����
select ename
from employee
where eno != ANY (7839, 7782, 7698, 7902, 7566, 7788, 0);
			 
select ename --��� ����̸� ����� ����
from employee
where eno != ANY (select distinct manager
			 from employee
			 where manager IS NOT null);			 

select ename
from employee
where eno != ANY (7839, 7782, 7698, 7902, 7566, 7788);

--[���-2] : self join
--[���-2-1] : , where
--[1]
select *
from employee e, employee m
where e.manager = m.eno;

select distinct m.eno, m.ename--���������� �ִ� ����� ���(�ߺ�����)
from employee e, employee m
where e.manager = m.eno;

--[2]. {���������� ���� ���} = {��� ���} - {���������� �ִ� ���}
select eno, ename --��� ���
from employee

MINUS

select distinct m.eno, m.ename--���������� �ִ� ���(�ߺ�����)
from employee e, employee m
where e.manager = m.eno

order by 1 asc;

--[���-2-2] : JOIN ~ ON
--[1]
select *
from employee e JOIN employee m
ON e.manager = m.eno;

select distinct m.eno, m.ename--���������� �ִ� ����� ���(�ߺ�����)
from employee e JOIN employee m
ON e.manager = m.eno;

--[2]. {���������� ���� ���} = {��� ���} - {���������� �ִ� ���}
select eno, ename --��� ���
from employee

MINUS

select distinct m.eno, m.ename--���������� �ִ� ���(�ߺ�����)
from employee e JOIN employee m
ON e.manager = m.eno

order by 1 asc;


--�ڡ�8.���������� �ִ� ����̸� ǥ��
select * from employee;

--[���-1] : ��������
--[���-1-1] : IN ������
--[1]. ���������� �ִ� �����ȣ ã��
select manager--13��(�ߺ�)
from employee
where manager IS NOT NULL;

select distinct manager --13��(�ߺ�)->(�ߺ�����)6���� 1�� �̻��� ���������� ����
from employee
where manager IS NOT NULL;

--[2]. ���������� �ִ� ��� : 6��
select ename
from employee
where eno IN (select distinct manager
			 from employee
			 where manager IS NOT NULL);

select ename
from employee
where eno IN (7839,7782,7698,7902,7566,7788);

--[���-1-2] : =ANY ������(eno=7839 ������ eno=7782 ������...)
--������ : �� ������ �����ϴ� ����� �� ��ħ(�ߺ� ����)
--[1]. ���������� �ִ� �����ȣ ã��
select manager--13��(�ߺ�)
from employee
where manager IS NOT NULL;

select distinct manager --13��(�ߺ�)->(�ߺ�����)6���� 1�� �̻��� ���������� ����
from employee
where manager IS NOT NULL;

--[2]. ���������� �ִ� ��� : 6��
select ename
from employee
where eno = ANY (select distinct manager
			 from employee
			 where manager IS NOT NULL);

select ename
from employee
where eno = ANY (7839,7782,7698,7902,7566,7788);
			 
--[���-2] : self join
--[���-2-1] : , where
--[1]
select *
from employee e, employee m
where e.manager = m.eno;

--[2]
select distinct m.eno, m.ename--���������� �ִ� ����� ���(�ߺ�����)
from employee e, employee m
where e.manager = m.eno
order by 1 asc;


--[���-2-2] : JOIN ~ ON
--[1]
select *
from employee e JOIN employee m
ON e.manager = m.eno;

select distinct m.eno, m.ename--���������� �ִ� ����� ���(�ߺ�����)
from employee e JOIN employee m
ON e.manager = m.eno;


--9.BLAKE�� ������ �μ��� ���� ����̸��� �Ի����� ǥ��(��,BLAKE�� ����)
--[1]. BLAKE�� �μ���ȣ ���ϱ�
select dno--30
from employee
where ename = 'BLAKE';

--[2]
select ename, hiredate
from employee
where dno = (select dno
			from employee
			where ename = 'BLAKE')
AND ename <> 'BLAKE'; --�ݵ�� 'BLAKE�� ����' ���� �߰�

--10.�޿��� ��� �޿����� ���� ������� �����ȣ�� �̸� ǥ��(����� �޿��� ���� �������� ����)
--[1]. ������̺��� ��� �޿� ���ϱ�
select avg(salary)
from employee; --2073.2142....

--[2]. 
select eno, ename
from employee
where salary > (select avg(salary)
				from employee)
order by salary; --order by���� asc ��������

--11.�̸��� K�� ���Ե� ����� ���� �μ����� ���ϴ� ����� �����ȣ�� �̸� ǥ��
--[1] �̸��� K�� ���Ե� ����� �μ���ȣ ���ϱ�
select dno
from employee
where ename like '%K%';

--[2]
select eno, ename
from employee
where dno IN(select distinct dno
			from employee
			where ename like '%K%');

			
--12.�μ���ġ�� DALLAS�� ����̸��� �μ���ȣ �� ��� ���� ǥ��
--[1]. �μ���ġ�� DALLAS �μ���ȣ ���ϱ�
select dno
from department
where loc = 'DALLAS';

--[2]		
select ename, dno, job
from employee
where dno IN (select dno
			from department
			where loc = 'DALLAS');
		
			
--[����-1]
--[12�� ���湮��]. �μ���ġ�� DALLAS�� ����̸�, �μ���ȣ, ��� ����, + '�μ���ġ' ǥ��
--'����̸�, �μ���ȣ, ��� ����' : ������̺� / '�μ���ȣ, '�μ���ġ' : �μ����̺�
-- �� ���̺� '�μ���ȣ'�� ���� -> ���� �μ���ȣ�� ����
--[���ι��-1] , WHERE (����:�˻����� �߰��� ��ȣ �ֱ�, ����:(+)�� �ܺ����� �����ϰ� ���� �� �ִ�. ���ʰ� �����ʸ� ����)
--��Ī��������
select e.ename, e.dno, e.job, d.loc
from employee e, department d
where e.dno = d.dno 	--��������
AND d.loc = 'DALLAS'; 	--�˻�����

--��Ī����
select ename, e.dno, job, loc
from employee e, department d
where e.dno = d.dno --��������
AND loc = 'DALLAS'; --�˻�����			

--[���ι��-2] JOIN ~ ON (����:�ܺ����� ����Ⱑ ���-1���� ����, ����:�˻����� �߰��� ���ϰ� ����(left)/������(right)/����(full)�ܺ�����(outer join) ����)
select ename, e.dno, job, loc
from employee e JOIN department d
ON e.dno = d.dno 	  --��������
WHERE loc = 'DALLAS'; --�˻�����		
			
--[��������1�� 2 ������] : �ߺ����� ����. �÷����� �޶� ���ΰ���(�̶�,Ÿ���� ���ƾ� ��)
--[��������3�� 4 ������] : �ߺ����� ��. 	 �÷����� �ٸ��� ���κҰ���

--[��������-3] NATURAL JOIN : �ڿ������� '������ Ÿ�԰� �̸��� ���� �÷�'���� ���� �� �ߺ� ����
select ename, dno, job, loc
from employee NATURAL JOIN department
--�������� �ʿ����(�ڿ����� ������:�����ϴ� �÷��� '�ǹ̰� �ٸ� ��' ���� �߻�)
WHERE loc = 'DALLAS'; --�˻�����

--[��������-4] JOIN ~ USING(�÷���) : '������ Ÿ�԰� ������ �̸��� ���� �÷�'���� ���� �� �ߺ� ����
select ename, dno, job, loc
from employee JOIN department
USING(dno) 	  		  --��������
WHERE loc = 'DALLAS'; --�˻�����	

--[��������-3] NATURAL JOIN�� '������ Ÿ�԰� �̸��� ���� �÷�'�� 1���� �� ���
--[��������-4] JOIN ~ USING(�÷���1,�÷���2)�� '������ Ÿ�԰� �̸��� ���� �÷�'�� 2�� �̻��� �� ���

/*
select ename, e1.dno, job, "�μ���ġ"
from employee e1 JOIN (select dno, loc as "�μ���ġ"
						from department
						where loc = 'DALLAS') e2 
ON e1.dno = e2.dno;
*/		
			

--13.KING���� �����ϴ� ����̸��� �޿� ǥ��(=> KING�� ����� ����̸��� �޿� ǥ��)
--[1] ����̸��� 'KING'�� �����ȣ ���ϱ�
select eno
from employee
where ename = 'KING';

--[2] KING���� �����ϴ� '��������' �̸��� �޿� ǥ��
select ename, salary
from employee
where manager IN (select eno --���
				from employee
				where ename = 'KING');

				
--14.RESEARCH �μ��� ����� ���� �μ���ȣ, ����̸�, ��� ���� ǥ��
--������̺� : �μ���ȣ, ����̸�, ��� ����		/ �μ����̺�:�μ���ȣ, �μ��̸�(RESEARCH)
--[1]. RESEARCH �μ���ȣ ���ϱ�
select dno	--20
from department
where dname = 'RESEARCH';

--[2] �� �μ��� �ٹ��ϴ� ��� ���� ���ϱ�
select dno, ename, job
from employee
where dno IN (select dno
			from department
			where dname = 'RESEARCH');
				
			
--15.��� �޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ����� ���� �μ����� �ٹ��ϴ� 
--�����ȣ,�̸�,�޿� ǥ��
--[���� �ؼ�-1]��� �޿����� ���� �޿��� �ް�(����-1) / �̸��� M�� ���Ե� ����� ���� �μ����� �ٹ�(����-2)
--[���-1]
--[1]. ��� �޿� ���ϱ�(����-1)
select avg(salary) --2073.2142...
from employee;

--[2]. �̸��� M�� ���Ե� ����� ���� �μ���ȣ ���ϱ�
select distinct dno 	--10, 20, 30
from employee
where ename like '%M%';

--[3]. 
select eno, ename, salary, dno
from employee
where salary > (select avg(salary) --2073.2142...
				from employee)
AND dno IN (select distinct dno
			from employee
			where ename like '%M%');	

--[4] ������ : �̸��� M�� ���Ե� ����� ����
select eno, ename, salary, dno
from employee
where salary > (select avg(salary) --2073.2142...
				from employee)
AND dno IN (select distinct dno
			from employee
			where ename like '%M%')
AND ename NOT LIKE '%M%';
--[3]�� [4]�� ����� ����.
--����? '��� �޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ���'�� �������� �����Ƿ�


--[���� �ؼ�-2]��� �޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ����� ���� �μ����� �ٹ�(����-1)

--�ڡ� [������ ������̺��� '��� �޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ���'�� �������� �����Ƿ�
------ �����͸� ������ �� �׽�Ʈ�غ��ڴ�.]
--[����] : �μ���ȣ�� 20�̰� �̸��� M�� ���Ե� ����� �޿��� 3000���� ����
update employee
set salary=3000
where dno = 20 AND ename like '%M%';

--�����Ǿ�����
select ename, dno, salary --SMITH, ADAMS
from employee
where dno = 20 AND ename like '%M%';

--[���-2]
--[1]. ��� �޿� ���ϱ�
select round(AVG(salary)) --2366
from employee;

--[2]. ���� ��ձ޿����� ���� �޿��� �ް� �̸��� M�� ���Ե� ����� �μ���ȣ ���ϱ� --����� 20
select dno
from employee
where ename like '%M%'
AND salary > (select round(AVG(salary),0) --2366
				from employee);


--[3]. ���� �μ���ȣ(20)�� ���� �μ����� �ٹ��ϴ� ����� �����ȣ, �̸�, �޿� ǥ��
select eno, ename, salary
from employee
where dno IN (select dno
			from employee
			where ename like '%M%'
			AND salary > (select round(AVG(salary),0) --2366
						 from employee))
AND ename NOT like '%M%'; --���̸��� M�� ���Ե� ����� ����

--[������ ������ �ٽ� ���� ������Ŵ]
update employee
set salary=800
where ename='SMITH';

update employee
set salary=1100
where ename='ADAMS';


--16.��� �޿��� ���� ���� ������ �� ��ձ޿� ǥ��
--[���-1]
--[1] ������ ��� �޿� �� ���� ���� �޿� ���ϱ�
--�� �׷��Լ� �ִ� 2������ ��ø
select min(AVG(salary)) --1037.5
from employee
group by job;

--[2]
select job, AVG(salary)
from employee
group by job;

--[3]
select job, AVG(salary)
from employee
group by job
--�׷��Լ��� ����
having AVG(salary) = (�ּ���ձ޿�);

--[4] ��� : CLERK 1037.5
select job, avg(salary)
from employee
group by job
--�׷��Լ��� ����
having avg(salary) = (select min(avg(salary)) --1037.5
					  from employee
					  group by job);

--[���-2]
--[1]. ������ ��� �޿��� ���� ��� �޿��� �������� ����
select job, avg(salary)
from employee
group by job
ORDER BY AVG(salary) ASC;

--[2]. ������ ���� ���̺�κ��� ROWNUM=1�� ���� �ٷ� ���� ���� ��ձ޿��� ��
select *
from (select job, avg(salary)
	 from employee
	 group by job
	 ORDER BY AVG(salary) ASC)
where rownum = 1; --ù��° �ุ
					  
--17.��� ������ MANAGER�� ����� �Ҽӵ� �μ��� ������ �μ��� ����̸� ǥ��
--[1] ��� ������ MANAGER�� ����� �Ҽӵ� �μ���ȣ ���ϱ�
select dno
from employee
where job = 'MANAGER';

--[2] 
select ename
from employee
where dno IN (select dno
			from employee
			where job = 'MANAGER');

--[3]. ���� �ؼ��� ���� '��� ������ MANAGER�� ���'�� ���ܽ�ų �� �ִ�.
select ename
from employee
where dno IN (select dno
			from employee
			where job = 'MANAGER')
AND job != 'MANAGER';

