CREATE TABLE TESTSCHEMA.Students
(
	id NUMBER,
	name VARCHAR2(100),
	group_id NUMBER,
	CONSTRAINT fk_froup_id FOREIGN KEY(group_id) REFERENCES TESTSCHEMA.Groups(id) 
);


CREATE TABLE TESTSCHEMA.Groups
(
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    c_val NUMBER
);

------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER check_id_uniqueness
BEFORE INSERT OR UPDATE ON TESTSCHEMA.Students
FOR EACH ROW
DECLARE 
	CURSOR all_id_cursor IS 
	SELECT id FROM TESTSCHEMA.Students;
	current_id NUMBER;
BEGIN 
	OPEN all_id_cursor;
	LOOP
		FETCH all_id_cursor INTO current_id;
		IF current_id = :NEW.id THEN 
			RAISE_APPLICATION_ERROR(-20001, 'This id is not unique');
		END IF;
		EXIT WHEN all_id_cursor%NOTFOUND;
	END LOOP;
	CLOSE all_id_cursor;	
END;

SELECT * FROM TESTSCHEMA.Students;
INSERT INTO TESTSCHEMA.Students VALUES 
(1, 'MVFJOD', 1);
TRUNCATE TABLE TESTSCHEMA.Students;

UPDATE TESTSCHEMA.Students
SET id = 1
WHERE id = 2;

------------------------------------------------------------------------------------
