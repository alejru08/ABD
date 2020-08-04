--APARTADO D
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
    TOTALINVERSIONES INT;
    contador INT;
    CURSOR USUARIOS IS (SELECT USERNAME, DEFAULT_TABLESPACE FROM SYS.DBA_USERS
        WHERE USERNAME LIKE 'ABD%');
BEGIN
    TOTALINVERSIONES:=0;
    CONTADOR:=0;
    WHILE CONTADOR<3 LOOP 
    TOTALINVERSIONES:=0;
    FOR USUARIO IN USUARIOS
    LOOP
    DBMS_OUTPUT.PUT_LINE('El nombre de usuario es ' ||USUARIO.USERNAME);

-- ---------------------------------------------Existe la tabla notificaciones -------------------------------------------------
    select COUNT(*) INTO exiteNotificacion from ALL_TABLES 
        where OWNER LIKE USUARIO.USERNAME and TABLE_NAME like '%NOTIFICACIONES%'; 
    SELECT SUBSTR(USUARIO.USERNAME,4,5) INTO numerosUsuario FROM DUAL; --DIVIDIMOS EL NOMBRE PARA COGER SOLO LA ULTIMA CIFRA

    IF exiteNotificacion > 0 THEN
        DBMS_OUTPUT.PUT_LINE('La tabla notificacion del usuaio existe');
-- ----------------------------------------------------Bloques libres-----------------------------------------------------------
        SELECT SUM(BLOCKS) bloques_libres INTO bloquesUsuario--CONSULTA DE BLOQUES LIBRES
            FROM
             SYS.DBA_FREE_SPACE
            WHERE
             TABLESPACE_NAME LIKE 'ESPABD'||numerosUsuario
            GROUP BY TABLESPACE_NAME, FILE_ID
            order by bloques_libres ; 
        DBMS_OUTPUT.PUT_LINE('El ususario tiene '|| bloquesusuario|| ' bloques libres');

        IF bloquesUsuario < 18000 THEN
            DBMS_OUTPUT.PUT_LINE('El usuario tiene menos de 1800 bloques');

-- --------------------------------El numero aleatorio coincide con el ultimo del usuario---------------------------------------

            select MOD(ABS(DBMS_RANDOM.RANDOM),1) INTO numAleatorio from dual; --GENERAMOS UN NUMERO ALEATORIO DEL 0 AL 9999
            SELECT SUBSTR(USUARIO.USERNAME,7,1) INTO numUsuario FROM DUAL; --DIVIDIMOS EL NOMBRE PARA COGER SOLO LA ULTIMA CIFRA
            DBMS_OUTPUT.PUT_LINE('El numero aleatorio generado es: '|| numAleatorio);
            DBMS_OUTPUT.PUT_LINE('El numero usuario generado es: '|| numUsuario);

                IF numAleatorio = numUsuario THEN 
                    DBMS_OUTPUT.PUT_LINE('El numero aleatorio coincide con la ultima cifra del usuario');
                    select username INTO nombreUsuarioActual from USER_USERS;
                    SELECT SYSDATE "NOW" INTO fecha FROM DUAL;
                    COMISION := cantidad * 0.02;
                    TOTALINVERSIONES:= TOTALINVERSIONES+COMISION;
                    DBMS_OUTPUT.PUT_LINE('La suma hasta ahora de inversiones es ' || TOTALINVERSIONES);
-- ------------------------------------------------APARTADO D ------------------------------------------------------------------

                    EXECUTE IMMEDIATE 'LOCK TABLE ' || USUARIO.USERNAME ||'.NOTIFICACIONES IN EXCLUSIVE MODE';--Bloqueamos la tabla en exclusive mode para que nadie pueda modificarla mientras estamos insertando
                    DBMS_OUTPUT.PUT_LINE('Hemos bloqueado la tabla de ' || USUARIO.USERNAME);
                    EXECUTE IMMEDIATE 'INSERT INTO ' || USUARIO.USERNAME || '.NOTIFICACIONES VALUES (:a, :b, :c, :d, :e, :f)' USING nombreUsuarioActual, fecha, DNICliente, NombreE, TIPO, COMISION;
                    DBMS_OUTPUT.PUT_LINE('La fila se ha insertado y la comision es: ' ||COMISION);
                    EXECUTE IMMEDIATE 'SELECT SUM (COMISION) FROM ' ||USUARIO.USERNAME||'.NOTIFICACIONES' INTO SUMA; --Podemos acceder porque hemos bloqueado nosostros la tabla
                    IF SUMA >1000 THEN 
                        DBMS_OUTPUT.PUT_LINE('El usuario tiene mas de 100 euros en comisiones');
                        ROLLBACK;--Deshacemos los cambios y desbloqueamos la tabla
                    ELSE
                        COMMIT; --usamos commit para confirmar los cambios y desbloquear la tabla y siga con el procedure.

                    END IF;
-- -----------------------------------------------------------------------------------------------------------------------------

                ELSE DBMS_OUTPUT.PUT_LINE('El numero aleatorio no coincide con la ultima cifra del usuario');

                END IF;

        ELSE DBMS_OUTPUT.PUT_LINE('El usuario tiene mas de 1800 bloques');
        END IF;

    ELSE DBMS_OUTPUT.PUT_LINE('La tabla notificacion deL usuaio NO existe.');

END IF;
END LOOP;

DBMS_OUTPUT.PUT_LINE('La suma total entre todos los uusarios es ' || totalinversiones);
    IF totalinversiones>1000 THEN
    CONTADOR:=CONTADOR+1;
    ROLLBACK;
    ELSE 
    CONTADOR:=3;
    COMMIT;
    END IF;
END LOOP;

END;