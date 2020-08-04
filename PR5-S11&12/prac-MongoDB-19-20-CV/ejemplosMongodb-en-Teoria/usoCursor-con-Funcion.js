var cursor = db.ultimasAventuras.find({ },{})

cursor.forEach( 
  function(item) 
      { print(tojson(item))  }
 );

 cursor.hasNext() // "false"  si ya no hay más elementos
cursor.hasNext() // "true" s todavía quedan elementos por recorrer

