--APARTADO A.

create or replace NONEDITIONABLE PROCEDURE  REGALACOMISIONES  (DNICliente CHAR, NombreE CHAR,  cantidad FLOAT, TIPO CHAR)  AUTHID CURRENT_USER AS 

    numAleatorio INT; 
    bloquesUsuario INT;
    numerosUsuario VARCHAR(20); --cuatro ultimas cifras del usuario
    numUsuario INT; --ultima cifra del usuario
    exiteNotificacion INT; --booleano que comprueba si existe la tabla notificaciones en el usuario
    fecha DATE;
    nombreUsuarioActual VARCHAR(20);
    COMISION NUMBER;
    CURSOR USUARIOS IS (SELECT USERNAME, DEFAULT_TABLESPACE FROM SYS.DBA_USERS
        WHERE USERNAME LIKE 'ABD%'); --cursor que recorre todos los usarios con nombre que comience por "ABD"
BEGIN
    FOR USUARIO IN USUARIOS --Bucle que recorre todos los usarios que cumplan las condiciones del cursor
    LOOP
    DBMS_OUTPUT.PUT_LINE('El nombre de usuario es ' ||USUARIO.USERNAME);

-- ---------------------------------------------Existe la tabla notificaciones -------------------------------------------------
    select COUNT(*) INTO exiteNotificacion from ALL_TABLES 
        where OWNER LIKE USUARIO.USERNAME and TABLE_NAME like '%NOTIFICACIONES%'; --Esta consulta nos muestra el numero de tablas que se llamen notoficaciones.
        --De esta manera si obtenemos 0 sabremos que no existe la tabla para ese usuario.
    SELECT SUBSTR(USUARIO.USERNAME,4,5) INTO numerosUsuario FROM DUAL; --Dividimos el nombre para coger solo la ultima cifra del nombre de usuario

    IF exiteNotificacion > 0 THEN --Comprobamos si tiene la tabla "NOTIFICACIONES"
        DBMS_OUTPUT.PUT_LINE('La tabla notificacion del usuaio existe');
-- ----------------------------------------------------Bloques libres-----------------------------------------------------------
        SELECT SUM(BLOCKS) bloques_libres INTO bloquesUsuario  --Esta consulta devuelve el numero de bloques libres en el tablespace del usario
            FROM
             SYS.DBA_FREE_SPACE
            WHERE
             TABLESPACE_NAME LIKE 'ESPABD'||numerosUsuario --Consultamos el Tablespace con los numeros obtenidos en la consulta anterior
            GROUP BY TABLESPACE_NAME, FILE_ID
            order by bloques_libres ; 
        DBMS_OUTPUT.PUT_LINE('El ususario tiene '|| bloquesusuario|| ' bloques libres');

        IF bloquesUsuario < 1800 THEN --Comprobamos que el usuario tiene mas de 1800 bloques libres

-- --------------------------------El numero aleatorio coincide con el ultimo del usuario---------------------------------------
            DBMS_OUTPUT.PUT_LINE('El numero aleatorio generado es: ');
            select MOD(ABS(DBMS_RANDOM.RANDOM),10) INTO numAleatorio from dual; --Generamos un numero aleatorio del 0 al 9
            SELECT SUBSTR(USUARIO.USERNAME,7,1) INTO numUsuario FROM DUAL; --Dividimos el nombre del usuario para coger la ultima cifra
            DBMS_OUTPUT.PUT_LINE('El numero aleatorio generado es: '|| numAleatorio);
            DBMS_OUTPUT.PUT_LINE('El numero usuario generado es: '|| numUsuario);

                IF numAleatorio = numUsuario THEN --Si el numero aleatorio y el ultimo numero del usuario coinciden
                    DBMS_OUTPUT.PUT_LINE('El numero aleatorio coincide con la ultima cifra del usuario');
                    select username INTO nombreUsuarioActual from USER_USERS; --Usuario desde el que ejecutamos el procedimiento
                    SELECT SYSDATE "NOW" INTO fecha FROM DUAL; --Fecha en que ejecutamos el procedimiento
                    COMISION := cantidad * 0.02; --2% de comision
                    EXECUTE IMMEDIATE 'INSERT INTO ' || USUARIO.USERNAME || '.NOTIFICACIONES VALUES (:a, :b, :c, :d, :e, :f)' USING nombreUsuarioActual, fecha, DNICliente, NombreE, TIPO, COMISION; --Inserccion en la tabla
                    DBMS_OUTPUT.PUT_LINE('La fila se ha insertado y la comision es: ' ||COMISION);

                ELSE DBMS_OUTPUT.PUT_LINE('El numero aleatorio no coincide con la ultima cifra del usuario');

                END IF;

        ELSE DBMS_OUTPUT.PUT_LINE('El usuario tiene mas de 1800 bloques');
        END IF;

    ELSE DBMS_OUTPUT.PUT_LINE('La tabla notificacion deL usuaio NO existe.');

END IF;
END LOOP;--Fin del bucle
END;
