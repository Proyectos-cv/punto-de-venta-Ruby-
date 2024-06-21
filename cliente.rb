require 'fox16'
require 'sqlite3'

include Fox

class ClientWindow < FXMainWindow
  def initialize(app)
    super(app, "Productos Disponibles", :width => 300, :height => 200)

    # Lista para mostrar los productos disponibles
    @product_list = FXList.new(self, :opts => LIST_BROWSESELECT | FRAME_SUNKEN | FRAME_THICK | LAYOUT_FILL_X)

    # Caja de texto para ingresar la cantidad de productos a comprar
    @quantity_text = FXTextField.new(self, 10)

    # Botón para calcular el total a pagar
    calculate_button = FXButton.new(self, "Calcular Total")
    calculate_button.connect(SEL_COMMAND) do
      calculate_total
    end

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
      @product_list.appendItem("#{id}: #{nombre}: #{descripcion}, Precio: #{precio}, Stock: #{stock}")
    end
  end

  def calculate_total
    # Obtener la cantidad ingresada en la caja de texto
    quantity = @quantity_text.text.to_i
  
    # Validar que la cantidad sea un número entero y mayor que cero
    if quantity <= 0 || !quantity.to_s.match?(/^\d+$/)
      FXMessageBox.error(self, MBOX_OK, "Error", "Por favor, ingrese una cantidad válida mayor que cero.")
      return
    end
  
    # Obtener la fila seleccionada en la lista de productos
    selected_row = @product_list.currentItem
    if selected_row == -1
      FXMessageBox.error(self, MBOX_OK, "Error", "Por favor, seleccione un producto.")
      return
    end
  
    # Obtener la información del producto seleccionado
    product_info = @product_list.getItemText(selected_row)
    precio = product_info.split(":")[-2].strip.to_f
    stock = product_info.split(":")[-1].strip.to_i
  
    # Verificar si hay suficiente stock disponible
    if quantity > stock
      FXMessageBox.error(self, MBOX_OK, "Error", "No hay suficiente stock disponible para la cantidad seleccionada.")
      return
    end
  
    # Calcular el total a pagar
    total = precio * quantity
  
    # Restar la cantidad comprada del stock en la tabla de productos
    new_stock = stock - quantity
    product_id = product_info.split(":")[0].strip.to_i
    @db.execute("UPDATE productos SET stock=? WHERE id=?", new_stock, product_id)
  
    # Mostrar el total a pagar
    FXMessageBox.information(self, MBOX_OK, "Total a Pagar", "Total a Pagar: $#{total}")

    show_products
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
