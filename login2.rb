require 'fox16'

include Fox

class MainWindow < FXMainWindow
  def initialize(app)
    super(app, "Ventana Principal", :width => 300, :height => 200)

    # Layout vertical para el contenido
    content_frame = FXVerticalFrame.new(self, LAYOUT_FILL_X | LAYOUT_FILL_Y)

    # Botón para ejecutar el archivo
    execute_button = FXButton.new(content_frame, "Ejecutar archivo")
    execute_button.connect(SEL_COMMAND) do
      execute_file()
    end
  end

  def execute_file()
    # Cargar y ejecutar el archivo
    system("ruby administrador.rb")
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

if __FILE__ == $0
  # Crear la aplicación
  application = FXApp.new

  # Crear la ventana principal
  MainWindow.new(application)

  # Ejecutar la aplicación
  application.create
  application.run
end
