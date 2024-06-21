require 'sqlite3'

# Establecer la conexión a la base de datos
db = SQLite3::Database.new 'empresa.db'

# Crear tabla de usuarios
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    rol_id INTEGER,
    FOREIGN KEY (rol_id) REFERENCES roles(id)
  );
SQL

# Crear tabla de roles
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS roles (
    id INTEGER PRIMARY KEY,
    nombre TEXT
  );
SQL

# Insertar roles
db.execute("INSERT INTO roles (nombre) VALUES ('Administrador')")
db.execute("INSERT INTO roles (nombre) VALUES ('Cliente')")

# Crear tabla de permisos
db.execute <<-SQL
  CREATE TABLE IF NOT EXISTS permisos (
    id INTEGER PRIMARY KEY,
    rol_id INTEGER,
    permiso TEXT,
    FOREIGN KEY (rol_id) REFERENCES roles(id)
  );
SQL

# Asignar permisos
db.execute("INSERT INTO permisos (rol_id, permiso) VALUES (1, 'administrar')")
db.execute("INSERT INTO permisos (rol_id, permiso) VALUES (2, 'ver_productos')")

# Consulta de usuarios con sus roles y permisos (solo para propósito de ejemplo)
usuarios = db.execute <<-SQL
  SELECT u.nombre, r.nombre AS rol, p.permiso
  FROM usuarios u
  INNER JOIN roles r ON u.rol_id = r.id
  LEFT JOIN permisos p ON u.rol_id = p.rol_id;
SQL

# Mostrar resultados
usuarios.each do |usuario|
  puts "Usuario: #{usuario[0]}, Rol: #{usuario[1]}, Permiso: #{usuario[2]}"
end

# Cerrar la conexión a la base de datos
db.close
