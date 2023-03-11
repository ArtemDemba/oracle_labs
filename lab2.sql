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

CREATE OR REPLACE TRIGGER cascade_students_deleting
AFTER DELETE ON TESTSCHEMA.Groups 
FOR EACH ROW
DECLARE 
	CURSOR students_of_deleting_group_cursor IS 
	SELECT id FROM TESTSCHEMA.Students 
	WHERE group_id = :OLD.id;
	current_student_id NUMBER;
BEGIN 
	OPEN students_of_deleting_group_cursor;
	LOOP
		FETCH students_od_deleting_group_cursor INTO current_student_id;
		DELETE FROM TESTSCHEMA.Students WHERE id = current_student_id;
		EXIT WHEN students_od_deleting_group_cursor%NOTFOUND;
	END LOOP;
	CLOSE students_of_deleting_group_cursor;
END;

DELETE FROM TESTSCHEMA.Groups WHERE id = 2;

------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER update_c_val
AFTER INSERT OR DELETE OR UPDATE OF group_id ON TESTSCHEMA.STUDENTS 
FOR EACH ROW 
DECLARE 
	old_group_id NUMBER;
	new_group_id NUMBER;
BEGIN 
	IF Inserting THEN
		new_group_id := :NEW.group_id;
		UPDATE TESTSCHEMA.GROUPS 
		SET c_val = c_val + 1
		WHERE id = new_group_id;
	ELSIF Deleting THEN
		old_group_id := :OLD.group_id;
		UPDATE TESTSCHEMA.GROUPS 
		SET c_val = c_val - 1
		WHERE id = old_group_id;
	ELSIF Updating('group_id') THEN 
		old_group_id := :OLD.group_id;
		new_group_id := :NEW.group_id;
		UPDATE TESTSCHEMA.GROUPS 
		SET c_val = c_val - 1
		WHERE id = old_group_id;
		
		UPDATE TESTSCHEMA.GROUPS 
		SET c_val = c_val + 1
		WHERE id = new_group_id;
	END IF;
END;

INSERT INTO TESTSCHEMA.GROUPS VALUES
(1, 'vmodjv', 0);
INSERT INTO TESTSCHEMA.STUDENTS VALUES
(1, 'DSOPVJD', 1);

DELETE FROM TESTSCHEMA.Groups 
WHERE id = 1;

UPDATE TESTSCHEMA.STUDENTS 
SET group_id = 2
WHERE id = 1;
DELETE FROM TESTSCHEMA.STUDENTS WHERE id = 1;

------------------------------------------------------------------------------------


