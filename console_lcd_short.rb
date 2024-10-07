require 'i2c/drivers/lcd'

lcd = I2C::Drivers::LCD::Display.new('/dev/i2c-1', 0x27, rows=4,cols= 20)



for i in 0...4
  lcd.text(gets.chomp,i)   
end
