import time
import cflib.crtp
from cflib.crazyflie import Crazyflie

# Inicializar los drivers
cflib.crtp.init_drivers()

# Crear el objeto Crazyflie
cf = Crazyflie(rw_cache='./cache')

try:
    # Intentar conectar al Crazyflie
    cf.open_link('radio://0/80/2M/E7E7E7E7E7')
    print("Crazyflie conectado.")
    time.sleep(5)  # Espera 5 segundos
    
except Exception as e:
    print(f"Ocurrió un error al intentar conectar o durante la operación: {e}")
    
finally:
    # Asegurar la desconexión del Crazyflie
    cf.close_link()
    print("Crazyflie desconectado.")