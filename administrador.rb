require 'fox16'
require 'sqlite3'

include Fox

class AdminWindow < FXMainWindow
  def initialize(app)
    super(app, "Administrador", :width => 400, :height => 300)

    # Lista para mostrar los productos disponibles
    @product_list = FXList.new(self, :opts => LIST_BROWSESELECT | FRAME_SUNKEN | FRAME_THICK | LAYOUT_FILL_X)


    # Conectar a la base de datos SQLite
    @db = SQLite3::Database.new 'tienda.db'

    # Cuadros de texto para ingresar nombre del producto
    FXHorizontalSeparator.new(self)
    text_boxes_frame = FXVerticalFrame.new(self, :opts => LAYOUT_CENTER_X)
    @name_label = FXLabel.new(text_boxes_frame, "Nombre del Producto:")
    @name_field = FXTextField.new(text_boxes_frame, 20)


# Cuadro de texto para ingresar descripción del producto
@description_label = FXLabel.new(text_boxes_frame, "Descripción del Producto:")
@description_field = FXTextField.new(text_boxes_frame, 20)

# Cuadro de texto para ingresar precio del producto
@price_label = FXLabel.new(text_boxes_frame, "Precio del Producto:")
@price_field = FXTextField.new(text_boxes_frame, 20)

# Cuadro de texto para ingresar stock del producto
@stock_label = FXLabel.new(text_boxes_frame, "Stock del Producto:")
@stock_field = FXTextField.new(text_boxes_frame, 20)


    # Botones para registrar, modificar y eliminar productos
    buttons_frame = FXHorizontalFrame.new(self)
    register_button = FXButton.new(buttons_frame, "Registrar")
    modify_button = FXButton.new(buttons_frame, "Modificar")
    delete_button = FXButton.new(buttons_frame, "Eliminar")
    

    
    # ---------------------------------------------------------------------------------------------
    register_button.connect(SEL_COMMAND) { register_product }
    modify_button.connect(SEL_COMMAND) { modify_product }
    delete_button.connect(SEL_COMMAND) { delete_product }

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

  def register_product
    # Capturar los valores de los campos desde los cuadros de texto
    nombre_producto = @name_field.text.strip
    descripcion_producto = @description_field.text.strip
    precio_producto = @price_field.text.strip
    stock_producto = @stock_field.text.strip
  
    # Validar que los campos no estén vacíos
    if nombre_producto.empty? || descripcion_producto.empty? || precio_producto.empty? || stock_producto.empty?
      FXMessageBox.error(self, MBOX_OK, "Error", "Por favor, complete todos los campos.")
    else
      # Validar que el precio y el stock sean valores numéricos
      if !precio_producto.match?(/\A\d+(\.\d+)?\z/) || !stock_producto.match?(/\A\d+\z/)
        FXMessageBox.error(self, MBOX_OK, "Error", "Por favor, ingrese un valor numérico válido para precio y stock.")
      else
        # Insertar el nuevo producto en la base de datos
        @db.execute("INSERT INTO productos (nombre, descripcion, precio, stock) VALUES (?, ?, ?, ?)", nombre_producto, descripcion_producto, precio_producto.to_f, stock_producto.to_i)
  
        # Actualizar la lista de productos mostrada en la interfaz
        show_products
  
        # Limpiar los cuadros de texto después de registrar el producto
        @name_field.text = ""
        @description_field.text = ""
        @price_field.text = ""
        @stock_field.text = ""

        # Mostrar alerta de registro exitoso
      FXMessageBox.information(self, MBOX_OK, "Éxito", "El producto ha sido registrado con éxito.")
      end
    end
  end
  

  def modify_product
    # Obtener el índice del producto seleccionado en la lista
    selected_index = @product_list.currentItem
  
    # Verificar si se ha seleccionado un producto
    if selected_index >= 0
      selected_product = @product_list.getItemText(selected_index)
      selected_product_id = selected_product.split(":").first.strip
  
      # Capturar los nuevos valores del producto desde los cuadros de texto
      nuevo_nombre_producto = @name_field.text.strip
      nueva_descripcion_producto = @description_field.text.strip
      nuevo_precio_producto = @price_field.text.strip
      nuevo_stock_producto = @stock_field.text.strip
  
      # Construir la consulta SQL dinámica
      sql_query = "UPDATE productos SET "
  
      # Validar y agregar campos actualizables a la consulta SQL
      if !nuevo_nombre_producto.empty?
        sql_query += "nombre='#{nuevo_nombre_producto}', "
      end
  
      if !nueva_descripcion_producto.empty?
        sql_query += "descripcion='#{nueva_descripcion_producto}', "
      end
  
      if !nuevo_precio_producto.empty?
        if nuevo_precio_producto.match?(/\A\d+(\.\d+)?\z/)
          sql_query += "precio=#{nuevo_precio_producto.to_f}, "
        else
          FXMessageBox.error(self, MBOX_OK, "Error", "Por favor, ingrese un valor numérico válido para precio.")
          return
        end
      end
  
      if !nuevo_stock_producto.empty?
        if nuevo_stock_producto.match?(/\A\d+\z/)
          sql_query += "stock=#{nuevo_stock_producto.to_i}, "
        else
          FXMessageBox.error(self, MBOX_OK, "Error", "Por favor, ingrese un valor numérico válido para stock.")
          return
        end
      end
  
      # Eliminar la coma final de la consulta SQL
      sql_query.chomp!(", ")
  
      # Agregar la condición WHERE
      sql_query += " WHERE id=#{selected_product_id}"
  
      # Ejecutar la consulta SQL
      @db.execute(sql_query)
  
      # Actualizar la lista de productos mostrada en la interfaz
      show_products
  
      # Limpiar los cuadros de texto después de modificar el producto
      @name_field.text = ""
      @description_field.text = ""
      @price_field.text = ""
      @stock_field.text = ""
  
      # Mostrar alerta de modificación exitosa
      FXMessageBox.information(self, MBOX_OK, "Éxito", "El producto ha sido modificado con éxito.")
    else
      FXMessageBox.error(self, MBOX_OK, "Error", "Por favor, seleccione un producto para modificar.")
    end
  end
  
  def delete_product
    # Obtener el índice del producto seleccionado en la lista
    selected_index = @product_list.currentItem
  
    # Verificar si se ha seleccionado un producto
    if selected_index >= 0
      # Obtener el nombre del producto seleccionado
      selected_product = @product_list.getItemText(selected_index)
      selected_product_id = selected_product.split(":").first.strip
  
      # Mostrar advertencia para confirmar la eliminación
      confirm_result = FXMessageBox.question(self, MBOX_YES_NO, "Confirmación", "¿Realmente desea eliminar el producto '#{selected_product}'?")
  
      # Si el usuario confirma la eliminación, proceder
      if confirm_result == MBOX_CLICKED_YES
        # Eliminar el producto de la base de datos
        @db.execute("DELETE FROM productos WHERE id=?", selected_product_id)
  
        # Actualizar la lista de productos mostrada en la interfaz
        show_products
  
        # Mostrar alerta de eliminación exitosa
        FXMessageBox.information(self, MBOX_OK, "Éxito", "El producto ha sido eliminado con éxito.")
      end
    else
      FXMessageBox.error(self, MBOX_OK, "Error", "Por favor, seleccione un producto para eliminar.")
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

  # Crear la ventana del administrador
  AdminWindow.new(application)

  # Ejecutar la aplicación
  application.create
  application.run
end
