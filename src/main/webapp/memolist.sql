# INSERT INTO 테이블이름 (필드명, ...) VALUES (저장할 데이터, ...);
INSERT INTO memolist (NAME, PASSWORD, memo, ip) VALUES ('홍길동', '1111', '1등 입니다.', '192.168.100.1');
INSERT INTO memolist (NAME, PASSWORD, memo, ip) VALUES ('임꺽정', '2222', '2등 입니다.', '192.168.100.2');
INSERT INTO memolist (NAME, PASSWORD, memo, ip) VALUES ('장길산', '3333', '3등 입니다.', '192.168.100.3');
INSERT INTO memolist (NAME, PASSWORD, memo, ip) VALUES ('일지매', '4444', '4등 입니다.', '192.168.100.4');

# select * from 테이블이름 order by idx desc
SELECT * FROM memolist ORDER BY idx DESC;
SELECT COUNT(*) FROM memolist;
# select * from memolist order by idx desc limit 시작인덱스, 글의개수
SELECT * FROM memolist ORDER BY idx DESC LIMIT 0, 10;
SELECT * FROM memolist WHERE idx = 230;

DELETE FROM memolist;
ALTER TABLE memolist AUTO_INCREMENT = 1;

DELETE FROM memolist WHERE idx = 2;
UPDATE memolist SET NAME="이브", memo="안녕" WHERE idx = 4;
SELECT * FROM memolist;