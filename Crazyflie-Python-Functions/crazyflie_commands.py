#  UNIVERSIDAD DEL VALLE DE GUATEMALA
#  Proyecto de Graduación
#  Pablo Javier Caal Leiva
#
#  crazyflie_commands.py

"""
Script de Python con la librería Cflib de Bitcraze y funciones básicas 
para el control de los drones Crazyflie. Esto forma parte del trabajo de 
graduación titulado "Desarrollo de herramientas de software para el 
control individual y seguro del cuadricóptero Crazyflie 2.1 utilizando 
la placa de expansión de posicionamiento con odometría visual Flow
Deck".
"""

import logging
import sys
import time
from threading import Event

import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.log import LogConfig
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.positioning.motion_commander import MotionCommander
from cflib.crazyflie.high_level_commander import HighLevelCommander

# Inicializa los controladores de la radio
cflib.crtp.init_drivers(enable_debug_driver=False)

# Redefinición del logger para que no muestre el traceback
logging.basicConfig(level=logging.CRITICAL)
   
def error_callback(error):
    print(f"Link error: {error}")

def connect_crazyflie(uri):
    try:
        scf = SyncCrazyflie(uri, cf=Crazyflie(rw_cache='./cache'))
        scf.open_link()
        return scf
    except Exception as e:
        if 'Cannot find a Crazyradio Dongle' in str(e):
            return 1
        else:
            return 0

def disconnect_crazyflie(scf):
    scf.close_link()

def get_position(scf):
    position_log_config = LogConfig(name='Position', period_in_ms=100)
    position_log_config.add_variable('stateEstimate.x', 'float')
    position_log_config.add_variable('stateEstimate.y', 'float')
    position_log_config.add_variable('stateEstimate.z', 'float')

    position = {'x': 0.0, 'y': 0.0, 'z': 0.0}
    new_data = Event()

    def position_callback(timestamp, data, logconf):
        position['x'] = data['stateEstimate.x']
        position['y'] = data['stateEstimate.y']
        position['z'] = data['stateEstimate.z']
        new_data.set()

    position_log_config.data_received_cb.add_callback(position_callback)

    try:
        existing_configs = scf.cf.log.log_blocks
        for config in existing_configs:
            if config.name == 'Position':
                config.stop()
                config.delete()
    except AttributeError:
        pass  

    scf.cf.log.add_config(position_log_config)
    position_log_config.start()
    new_data.wait()
    position_log_config.stop()

    return [position['x'], position['y'], position['z']]

def send_position(scf, x, y, z):
    commander = scf.cf.high_level_commander
    commander.go_to(x, y, z, 0.0, 3.0)  
    time.sleep(1) 
    return True

def send_position_2(scf, x, y, z, duration):
    commander = scf.cf.high_level_commander
    commander.go_to(x, y, z, 0.0, duration)  
    time.sleep(duration) 
    return True

def update_position(scf, x, y, z):
    scf.cf.extpos.send_extpos(x, y, z)
    time.sleep(0.1) 
    return True

def takeoff(scf, height, duration):
    commander = HighLevelCommander(scf.cf)
    commander.takeoff(absolute_height_m=height, duration_s=duration)
    time.sleep(duration) 
    return True

def takeoff2(scf, height, velocity):
    with MotionCommander(scf) as mc:
        mc.move_distance(0, 0, height, velocity)
    return True

def land(scf, height, duration):
    commander = HighLevelCommander(scf.cf)
    commander.land(absolute_height_m=height, duration_s=duration)

    time.sleep(duration)

    commander.stop()
    return True

def motor_health_test(scf):
    log_config = LogConfig(name='PropellerTest', period_in_ms=100)
    log_config.add_variable('motor.m1_variance', 'float')
    log_config.add_variable('motor.m2_variance', 'float')
    log_config.add_variable('motor.m3_variance', 'float')
    log_config.add_variable('motor.m4_variance', 'float')
    log_config.add_variable('motor.m1_voltage_sag', 'float')
    log_config.add_variable('motor.m2_voltage_sag', 'float')
    log_config.add_variable('motor.m3_voltage_sag', 'float')
    log_config.add_variable('motor.m4_voltage_sag', 'float')


    # Diccionario para almacenar los resultados del test
    motor_results = {
        'Motor M1': {'variance': 0.0, 'voltage_sag': 0.0},
        'Motor M2': {'variance': 0.0, 'voltage_sag': 0.0},
        'Motor M3': {'variance': 0.0, 'voltage_sag': 0.0},
        'Motor M4': {'variance': 0.0, 'voltage_sag': 0.0}
    }
    log_event = Event()

    def log_callback(timestamp, data, logconf):
        motor_results['Motor M1']['variance'] = data['motor.m1_variance']
        motor_results['Motor M2']['variance'] = data['motor.m2_variance']
        motor_results['Motor M3']['variance'] = data['motor.m3_variance']
        motor_results['Motor M4']['variance'] = data['motor.m4_variance']
        motor_results['Motor M1']['voltage_sag'] = data['motor.m1_voltage_sag']
        motor_results['Motor M2']['voltage_sag'] = data['motor.m2_voltage_sag']
        motor_results['Motor M3']['voltage_sag'] = data['motor.m3_voltage_sag']
        motor_results['Motor M4']['voltage_sag'] = data['motor.m4_voltage_sag']
        log_event.set()   
    
    try:
        scf.cf.log.add_config(log_config)
        log_config.data_received_cb.add_callback(log_callback)

        commander = scf.cf.high_level_commander
        log_config.start()
        print("Iniciando el propeller test...")
        for thrust in range(20000, 50001, 10000):
            print(f"Estableciendo thrust a: {thrust}")
            commander.send_setpoint(0, 0, 0, thrust)
            time.sleep(1)  

        commander.send_setpoint(0, 0, 0, 0) 
        log_event.wait(2) 

        log_config.stop()

    except Exception as e:
        print(f'Error: {str(e)}')

    return motor_results








# FUNCIONES POR PROBAR

def update_position2(scf, x, y, z):
    """
    Envía una nueva posición externa al Crazyflie.

    Args:
        scf (SyncCrazyflie): Objeto de la conexión sincronizada.
        x (float): Coordenada X de la nueva posición.
        y (float): Coordenada Y de la nueva posición.
        z (float): Coordenada Z de la nueva posición.

    Returns:
        bool: True si se envió correctamente.
    """
    position_updated = Event()

    def position_sent_callback():
        """
        Callback que se llama cuando la posición ha sido enviada.
        """
        position_updated.set()

    scf.cf.extpos.send_extpos(x, y, z)
    scf.cf.extpos.set_send_extpos_cb(position_sent_callback)
    position_updated.wait(timeout=1.0)  # Espera hasta 1 segundo para la confirmación

    return position_updated.is_set()