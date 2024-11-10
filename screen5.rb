require 'gtk3'
require 'i2c/drivers/lcd'
lcd = I2C::Drivers::LCD::Display.new('/dev/i2c-1', 0x27, rows=4,cols= 20)



def lcd_print(lcd,text)
  lcd.clear
  l=text.split("\n")
  for i in 0...l.length
    lcd.text(l[i][0..19],i)
  end
  
end



# Crear una nova finestra

window = Gtk::Window.new
window.set_title("Exemple amb Text Multilínia")
window.set_border_width(10)


# Crear una caixa vertical per organitzar els widgets

vbox = Gtk::Box.new(:vertical, 5)

# Crear un Gtk::TextView per permetre l'entrada de text multilínia

textview = Gtk::TextView.new
textview.set_wrap_mode(:word)  # Ajustar text a la línia si és massa llarg
textview.set_editable(true)     # Permetre l'edició de text
textview.set_cursor_visible(true)  # Mostrar el cursor

# Crear una clase CSS que aplique una fuente monoespaciada
css = <<-CSS
  textview {
    font-family: "monospace";
    font-size: 12px;
  }
CSS

# Aplicar el estilo CSS al TextView
provider = Gtk::CssProvider.new
provider.load(data: css)

# Usar el CSS provider para el widget
textview.style_context.add_provider(provider, Gtk::StyleProvider::PRIORITY_USER)


# Afegir el Gtk::TextView a un Gtk::ScrolledWindow per poder fer scroll si hi ha molt de text

scrolled_window = Gtk::ScrolledWindow.new
scrolled_window.set_policy(:automatic, :automatic)  # Scroll automàtic
scrolled_window.add(textview)


# Crear un botó

button = Gtk::Button.new(label: "Mostra el text")


# Definir l'acció a fer quan es prem el botó

button.signal_connect "clicked" do

  # Obtenir el buffer del textview i l'extracte de text

  buffer = textview.buffer
  text = buffer.text
  lcd_print(lcd,text)
  puts "#{text}"
end


# Afegir l'scroll amb el textview i el botó a la caixa vertical

vbox.pack_start(scrolled_window, expand: true, fill: true, padding: 0)
vbox.pack_start(button, expand: false, fill: false, padding: 10)


# Afegir la caixa a la finestra

window.add(vbox)


# Connectar la finestra amb l'event de tancament

window.signal_connect("destroy") { Gtk.main_quit }


# Mostrar tots els elements de la finestra

window.show_all


# Iniciar el bucle principal de GTK


Gtk.main
