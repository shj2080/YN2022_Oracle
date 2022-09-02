--응용SW 기초 기술활용 테스트 정리
--테이블 생성 -> 데이터 추가 -> 조회/수정/삭제

--drop table ADDRESS;
--delete address WHERE anum=5;

--1. 테이블 생성
create table ADDRESS(
	anum number primary key,	--중복 허용X + not null
	name varchar2(20) NOT NULL,
	gender char(1),
	tel varchar2(20),
	address varchar2(100) NOT NULL
);

--2. 데이터 추가
insert into address values(1,'강민재', 'M', '010-1111-1111', '대구');
insert into address values(2,'권은재', 'F', '010-2222-2222', '부산');
insert into address values(3,'김도영', 'M', '010-3333-3333', '서울');

--3. 데이터 조회 : ADDRESS 테이블의 모든 정보 조회
select * from address;

--4. 데이터 추가 (4, '김은경', 'F', '010-4444-4444', '대구')
insert into ADDRESS values(4, '김은경', 'F', '010-4444-4444', '대구');

--5. 데이터 변경=수정=갱신 : 강민재의 address값을 '서울'로 변경
UPDATE ADDRESS			--UPDATE [테이블이름]
SET address='서울'		--SET [속성]=<바꾸려는 값>
where name='강민재';		--WHERE [속성]=<찾는 값>   조건문
--where anum=1;

select * from address; --수정확인
