------Practica 4 - Semana 9
------Alejandro Ruiz Martin

--------------------------------- Apartado A -------------------------------------

create table DICCION
	(PalID	VARCHAR2(20),
	 Descripcion VARCHAR2(50),
     PadreID    VARCHAR2(20),
	 PRIMARY KEY    (PalID)
		);
        
     
--------------------------------- Apartado B -------------------------------------
   
        INSERT INTO DICCION 
  VALUES ('select jerarquica','estructura tabla en arbol', 'select compuesta');
    INSERT INTO DICCION 
  VALUES ('fecha sistema','es la fecha que tiene el ordenador','fecha');
     INSERT INTO DICCION 
  VALUES ('fecha','tipo de dato , en oracle : DATE','nada'); 
    INSERT INTO DICCION 
  VALUES ('select compuesta', 'consultas con varias partes', 'select');
    INSERT INTO DICCION 
  VALUES ('select simple', 'consultas con una sola instruccion', 'select');
    INSERT INTO DICCION 
  VALUES ('select', 'hacer consulta', 'nada');
    INSERT INTO DICCION 
  VALUES ('sql','lenguaje de consultas estructuradas', 'nada');
    INSERT INTO DICCION 
  VALUES ('select correlativa', 'coordina resultado subconsulta', 'select compuesta');

  
  
--------------------------------- Apartado C -------------------------------------

SELECT PalID , Descripcion , PadreID
FROM DICCION
-- Conectamos el palID con el PadreID, es decir, conectamos a los padres con los hijos
CONNECT BY PRIOR PalID = PadreID
-- indicamos el comienzo de la selección jerarquica en el "select"
START WITH PalID = 'select' 
-- Ordenamos los los PalID (nodos) por su PadreID
ORDER BY PadreID;

        
        
--------------------------------- Apartado D -------------------------------------        
  
  INSERT INTO DICCION 
  SELECT 'select anidada','consulta dentro de consulta','select compuesta' 
  FROM DUAL WHERE EXISTS (SELECT * FROM DICCION WHERE PadreID = 'select compuesta'); 
  
  
--------------------------------- Apartado E -------------------------------------    

SELECT PalID , Descripcion , PadreID
FROM DICCION
-- Conectamos el palID con el PadreID, es decir, conectamos a los padres con los hijos
CONNECT BY PRIOR PalID = PadreID
-- indicamos el comienzo de la selección jerarquica en el "select"
START WITH PalID = 'select' 
-- Ordenamos los los PalID (nodos) por su PadreID
ORDER BY PadreID;

        