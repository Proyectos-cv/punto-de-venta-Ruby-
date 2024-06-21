require 'sqlite3'

# Conexión a la base de datos (si no existe, se creará)
db = SQLite3::Database.new 'tienda.db'

# Crear tabla productos
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS productos (
    id INTEGER PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion TEXT,
    precio FLOAT,
    stock INTEGER
  );
SQL



# Crear tabla administrador
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS administrador (
    id INTEGER PRIMARY KEY,
    email VARCHAR(255),
    password VARCHAR(255)
  );
SQL

# Crear tabla cliente
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS cliente (
    id INTEGER PRIMARY KEY,
    email VARCHAR(255),
    password VARCHAR(255)
  );
SQL



# Insertar datos en la tabla administrador
db.execute("INSERT INTO administrador (id, email, password) VALUES (?, ?, ?)", 1, 'admin@gmail.com', '1234')

# Insertar datos en la tabla cliente
db.execute("INSERT INTO cliente (id, email, password) VALUES (?, ?, ?)", 1, 'client@gmail.com', '1234')


db.close


