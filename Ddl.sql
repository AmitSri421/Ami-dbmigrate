-- Grant necessary privileges (execute as DBA if required)
BEGIN
    EXECUTE IMMEDIATE 'GRANT CREATE TABLE TO your_user';
    EXECUTE IMMEDIATE 'GRANT CREATE SEQUENCE TO your_user';
    EXECUTE IMMEDIATE 'GRANT CREATE VIEW TO your_user';
    EXECUTE IMMEDIATE 'GRANT CREATE TRIGGER TO your_user';
    EXECUTE IMMEDIATE 'GRANT CREATE SYNONYM TO your_user';
    EXECUTE IMMEDIATE 'GRANT DROP ANY TABLE TO your_user';
    EXECUTE IMMEDIATE 'GRANT DROP ANY SEQUENCE TO your_user';
    EXECUTE IMMEDIATE 'GRANT DROP ANY VIEW TO your_user';
    EXECUTE IMMEDIATE 'GRANT DROP ANY TRIGGER TO your_user';
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Privilege grant failed: ' || SQLERRM);
END;
/

-- Drop existing objects gracefully
BEGIN
    FOR obj IN (SELECT OBJECT_NAME, OBJECT_TYPE FROM USER_OBJECTS WHERE OBJECT_TYPE IN ('TABLE', 'VIEW', 'SEQUENCE', 'TRIGGER')) 
    LOOP
        BEGIN
            IF obj.OBJECT_TYPE = 'TABLE' THEN
                EXECUTE IMMEDIATE 'DROP TABLE ' || obj.OBJECT_NAME || ' CASCADE CONSTRAINTS';
            ELSIF obj.OBJECT_TYPE = 'VIEW' THEN
                EXECUTE IMMEDIATE 'DROP VIEW ' || obj.OBJECT_NAME;
            ELSIF obj.OBJECT_TYPE = 'SEQUENCE' THEN
                EXECUTE IMMEDIATE 'DROP SEQUENCE ' || obj.OBJECT_NAME;
            ELSIF obj.OBJECT_TYPE = 'TRIGGER' THEN
                EXECUTE IMMEDIATE 'DROP TRIGGER ' || obj.OBJECT_NAME;
            END IF;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Failed to drop ' || obj.OBJECT_NAME || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/

-- Create table (only if it doesn’t exist)
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM USER_TABLES WHERE TABLE_NAME = 'MY_TABLE';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE TABLE MY_TABLE (
                ID NUMBER PRIMARY KEY,
                NAME VARCHAR2(100)
            )';
    END IF;
END;
/

-- Create sequence (only if it doesn’t exist)
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'MY_SEQ';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE MY_SEQ START WITH 1 INCREMENT BY 1';
    END IF;
END;
/

-- Create view (only if it doesn’t exist)
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM USER_VIEWS WHERE VIEW_NAME = 'MY_VIEW';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE VIEW MY_VIEW AS SELECT * FROM MY_TABLE';
    END IF;
END;
/

-- Create trigger (only if it doesn’t exist)
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM USER_TRIGGERS WHERE TRIGGER_NAME = 'MY_TRIGGER';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE '
            CREATE OR REPLACE TRIGGER MY_TRIGGER
            BEFORE INSERT ON MY_TABLE
            FOR EACH ROW
            BEGIN
                SELECT MY_SEQ.NEXTVAL INTO :NEW.ID FROM DUAL;
            END;';
    END IF;
END;
/
