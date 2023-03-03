CREATE TABLE TESTSCHEMA.MyTable
(
    id NUMBER PRIMARY KEY,
    val NUMBER NOT NULL
);

--------------------------------------------------------------------------
BEGIN
    FOR i IN 1..10000
        LOOP
            INSERT INTO TESTSCHEMA.MyTable(id, val) VALUES (i, ROUND(dbms_random.value(1, 1000000));
        END LOOP;
END;

SELECT * FROM TESTSCHEMA.MyTable;

-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION even_or_odd
RETURN CHAR IS
    even_count NUMBER := 0;
    odd_count  NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO even_count FROM TESTSCHEMA.MyTable
    WHERE MOD(val, 2) = 0;

    SELECT COUNT(*) INTO odd_count FROM TESTSCHEMA.MyTable
    WHERE MOD(val, 2) != 0;

    IF even_count > odd_count THEN
        RETURN 'TRUE';
    ELSIF even_count < odd_count THEN
        RETURN 'FALSE';
    ELSE
        RETURN 'EQUAL';
    END IF;
END even_or_odd;


SELECT even_or_odd() FROM DUAL;


------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_insert_query(id_ NUMBER)
RETURN CHAR IS
    val_ NUMBER;
BEGIN
    SELECT val INTO val_ FROM TESTSCHEMA.MyTable
    WHERE id = id_;

    RETURN 'INSERT INTO TESTSCHEMA.MyTable VALUES(' || TO_CHAR(id_) || ',' || TO_CHAR(val_) || ');';
END get_insert_query;


SELECT get_insert_query(1) FROM DUAL;

------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE insert_procedure(id_ NUMBER, val_ NUMBER) IS
BEGIN
    INSERT INTO MyTable(id, val) VALUES (id_, val_);
END insert_procedure;

CREATE OR REPLACE PROCEDURE update_procedure(id_ NUMBER, new_val NUMBER) IS
BEGIN
    UPDATE TESTSCHEMA.MyTable
    SET val = new_val
    WHERE id = id_;
END my_update;

CREATE OR REPLACE PROCEDURE delete_procedure(id_ NUMBER) IS
BEGIN
    DELETE FROM TESTSCHEMA.MyTable
    WHERE id = id_;
END delete_procedure;

------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION compute_annual_fee(salary REAL, adding_percent POSITIVE) 
RETURN REAL IS
    wrong_adding_percent EXCEPTION;
    negative_salary_exception EXCEPTION;
BEGIN
    IF (adding_percent > 100 OR adding_percent < 0) THEN
        RAISE wrong_adding_percent;
    ELSIF salary < 0 THEN
        RAISE negative_salary_exception;
    END IF;
    RETURN (1 + adding_percent / 100) * 12 * salary;
EXCEPTION
    WHEN wrong_adding_percent THEN
        DBMS_OUTPUT.PUT_LINE('Adding percent must be between 0 and 100.');
        RETURN 0;
    WHEN negative_salary_exception THEN
        DBMS_OUTPUT.PUT_LINE('Salary must be a positive value.');
        RETURN 0;
END compute_annual_fee;

SELECT compute_annual_fee(100, 10) FROM DUAL;

