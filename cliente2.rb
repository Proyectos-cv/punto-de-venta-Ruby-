



require 'fox16'
require 'sqlite3'

include Fox

class ClientWindow < FXMainWindow
  def initialize(app)
    super(app, "Productos Disponibles", :width => 300, :height => 200)

    # Lista para mostrar los productos disponibles
    @product_list = FXList.new(self, :opts => LIST_BROWSESELECT | FRAME_SUNKEN | FRAME_THICK | LAYOUT_FILL_X | LAYOUT_FILL_Y)

    # Conectar a la base de datos SQLite
    @db = SQLite3::Database.new 'tienda.db'

    # Mostrar los productos disponibles al iniciar la ventana
    show_products
  end

  def show_products
    # Limpiar la lista antes de mostrar los productos
    @product_list.clearItems

    # Consultar los productos disponibles en la base de datos
    @db.execute("SELECT * FROM productos") do |row|
      id, nombre, descripcion, precio, stock = row
      @product_list.appendItem("#{id}: #{nombre}: #{descripcion}: #{precio}: #{stock}")
    end
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

if __FILE__ == $0
  # Crear la aplicación
  application = FXApp.new

  # Crear la ventana del cliente
  ClientWindow.new(application)

  # Ejecutar la aplicación
  application.create
  application.run
end
