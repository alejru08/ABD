--APARTADO C.
create or replace NONEDITIONABLE PROCEDURE  REGALACOMISIONES  (DNICliente CHAR, NombreE CHAR,  cantidad FLOAT, TIPO CHAR)  AUTHID CURRENT_USER AS 

    numAleatorio INT;
    bloquesUsuario INT;
    numerosUsuario VARCHAR(20);
    numUsuario INT;
    exiteNotificacion INT;
    fecha DATE;
    nombreUsuarioActual VARCHAR(20);
    COMISION NUMBER;
    SUMA NUMBER;
    TOTALINVERSIONES INT; --Variable que indica la suma total del inversiones de todos los usuarios
    contador INT; --Numero de veces que hemos intentado que la inversion total sea inferior a 1000
    CURSOR USUARIOS IS (SELECT USERNAME, DEFAULT_TABLESPACE FROM SYS.DBA_USERS
        WHERE USERNAME LIKE 'ABD%');
BEGIN
    CONTADOR:=0;--Inicializamos a 0
    WHILE CONTADOR<3 LOOP --El maximo de veces que podemso intentar el proceso es 3
    TOTALINVERSIONES:=0;--Inicializamos a 0
    FOR USUARIO IN USUARIOS
    LOOP
    DBMS_OUTPUT.PUT_LINE('El nombre de usuario es ' ||USUARIO.USERNAME);

-- ---------------------------------------------Existe la tabla notificaciones -------------------------------------------------
    select COUNT(*) INTO exiteNotificacion from ALL_TABLES 
        where OWNER LIKE USUARIO.USERNAME and TABLE_NAME like '%NOTIFICACIONES%'; 
    SELECT SUBSTR(USUARIO.USERNAME,4,5) INTO numerosUsuario FROM DUAL; 

    IF exiteNotificacion > 0 THEN
        DBMS_OUTPUT.PUT_LINE('La tabla notificacion del usuaio existe');
-- ----------------------------------------------------Bloques libres-----------------------------------------------------------
        SELECT SUM(BLOCKS) bloques_libres INTO bloquesUsuario  
            FROM
             SYS.DBA_FREE_SPACE
            WHERE
             TABLESPACE_NAME LIKE 'ESPABD'||numerosUsuario
            GROUP BY TABLESPACE_NAME, FILE_ID
            order by bloques_libres ; 
        DBMS_OUTPUT.PUT_LINE('El ususario tiene '|| bloquesusuario|| ' bloques libres');

        IF bloquesUsuario < 1800 THEN
            DBMS_OUTPUT.PUT_LINE('El usuario tiene menos de 1800 bloques');

-- --------------------------------El numero aleatorio coincide con el ultimo del usuario---------------------------------------

            select MOD(ABS(DBMS_RANDOM.RANDOM),10) INTO numAleatorio from dual; 
            SELECT SUBSTR(USUARIO.USERNAME,7,1) INTO numUsuario FROM DUAL; 
            DBMS_OUTPUT.PUT_LINE('El numero aleatorio generado es: '|| numAleatorio);
            DBMS_OUTPUT.PUT_LINE('El numero usuario generado es: '|| numUsuario);

                IF numAleatorio = numUsuario THEN 
                    DBMS_OUTPUT.PUT_LINE('El numero aleatorio coincide con la ultima cifra del usuario');
                    select username INTO nombreUsuarioActual from USER_USERS;
                    SELECT SYSDATE "NOW" INTO fecha FROM DUAL;
                    COMISION := cantidad * 0.02;
                    TOTALINVERSIONES:= TOTALINVERSIONES+COMISION; --Sumamos la comision de este usuario al total
                    DBMS_OUTPUT.PUT_LINE('La suma hasta ahora de inversiones es ' || TOTALINVERSIONES);
                    EXECUTE IMMEDIATE 'INSERT INTO ' || USUARIO.USERNAME || '.NOTIFICACIONES VALUES (:a, :b, :c, :d, :e, :f)' USING nombreUsuarioActual, fecha, DNICliente, NombreE, TIPO, COMISION;
                    DBMS_OUTPUT.PUT_LINE('La fila se ha insertado y la comision es: ' ||COMISION);

                    EXECUTE IMMEDIATE 'SELECT SUM (COMISION) FROM ' ||USUARIO.USERNAME||'.NOTIFICACIONES' INTO SUMA;
                    IF SUMA >100 THEN
                        DBMS_OUTPUT.PUT_LINE('El usuario tiene mas de 100 euros en comisiones');
                        ROLLBACK;
                        DBMS_OUTPUT.PUT_LINE('Hemos hecho un rollback');
                    END IF;
                    
-- -----------------------------------------------------------------------------------------------------------------------------

                ELSE DBMS_OUTPUT.PUT_LINE('El numero aleatorio no coincide con la ultima cifra del usuario');

                END IF;

        ELSE DBMS_OUTPUT.PUT_LINE('El usuario tiene mas de 1800 bloques');
        END IF;

    ELSE DBMS_OUTPUT.PUT_LINE('La tabla notificacion deL usuaio NO existe.');

END IF;
END LOOP;
-- -------------------------------------------------APARTADO C------------------------------------------------------
DBMS_OUTPUT.PUT_LINE('La suma total entre todos los usuarios es ' || totalinversiones);
    IF totalinversiones>100 THEN --Si el total de inversiones supera los 1000 euros, haremos otra vuleta.
    CONTADOR:=CONTADOR+1; --Sumamos una vuelta
    ROLLBACK; --Deshacemos el proceso para volver a empezar
    ELSE --Si el total de inversiones es inferior a 1000
    CONTADOR:=3; --Colocamos en 3 el numero de vuletas dadas para no volver a ejecutar el bucle
    COMMIT;--Guardamos los cambios
    END IF;
END LOOP;

END;