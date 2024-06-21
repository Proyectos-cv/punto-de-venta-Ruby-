require 'fox16'
require 'sqlite3'

include Fox

class LoginWindow < FXMainWindow
  def initialize(app)
    super(app, "Login", :width => 300, :height => 180)

    # Layout vertical para el contenido
    content_frame = FXVerticalFrame.new(self, LAYOUT_FILL_X | LAYOUT_FILL_Y)

    # Etiqueta de título
    title_label = FXLabel.new(content_frame, "Empresa", :opts => LAYOUT_CENTER_X | LAYOUT_CENTER_Y | LAYOUT_FILL_X)
    title_font = FXFont.new(app, "Arial", 20, FONTWEIGHT_BOLD)
    title_label.font = title_font

    # Caja horizontal para el correo
    email_box = FXHorizontalFrame.new(content_frame, LAYOUT_CENTER_X)
    FXLabel.new(email_box, "Correo:")
    @email_field = FXTextField.new(email_box, 20)

    # Caja horizontal para la contraseña
    password_box = FXHorizontalFrame.new(content_frame, LAYOUT_CENTER_X)
    FXLabel.new(password_box, "Contraseña:")
    @password_field = FXTextField.new(password_box, 20, :opts => TEXTFIELD_PASSWD)

    # Botón de inicio de sesión
    login_button = FXButton.new(content_frame, "Iniciar Sesión")
    login_button.connect(SEL_COMMAND) do
      login
    end
  end

  def login
    # Obtener el texto de los campos de correo y contraseña
    email = @email_field.text
    password = @password_field.text
  
    # Validar que los campos no estén vacíos
    if email.empty? || password.empty?
      FXMessageBox.error(self, MBOX_OK, "Error", "Por favor, complete todos los campos.")
      return
    end
    @db = SQLite3::Database.new 'tienda.db'
  
    # Realizar la consulta en la tabla administrador
    admin_query = "SELECT * FROM administrador WHERE email=? AND password=?"
    admin_result = @db.execute(admin_query, email, password)
  
    # Realizar la consulta en la tabla cliente
    client_query = "SELECT * FROM cliente WHERE email=? AND password=?"
    client_result = @db.execute(client_query, email, password)
  
    # Verificar el resultado de la consulta
    if !admin_result.empty?
      #FXMessageBox.information(self, MBOX_OK, "Inicio de Sesión", "¡Bienvenido Administrador!")
      system("ruby administrador.rb")
    elsif !client_result.empty?
     # FXMessageBox.information(self, MBOX_OK, "Inicio de Sesión", "¡Bienvenido Cliente!")
     system("ruby cliente.rb")
    else
      FXMessageBox.error(self, MBOX_OK, "Error", "La persona no está registrada en el sistema o los datos no son correctos.")
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

  # Crear la ventana de inicio de sesión
  LoginWindow.new(application)

  # Ejecutar la aplicación
  application.create
  application.run
end


















