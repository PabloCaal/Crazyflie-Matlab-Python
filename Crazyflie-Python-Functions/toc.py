import logging
import time
from threading import Event

import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.log import LogConfig
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.positioning.motion_commander import MotionCommander
from cflib.crazyflie.high_level_commander import HighLevelCommander

# Inicializar los drivers
cflib.crtp.init_drivers()

scf = SyncCrazyflie('radio://0/80/2M/E7E7E7E7E7', cf=Crazyflie(rw_cache='./cache'))
scf.open_link()

# List all parameters in the TOC
for param in scf.cf.param.toc.toc.keys():
    print(param)

try:
    xKp_value = scf.cf.param.get_value('posCtlPid.xKp')
    print(f'Valor actual de posCtlPid.xKp: {xKp_value}')
except Exception as e:
    print(f'Error al acceder a posCtlPid.xKp: {str(e)}')

# Intentar modificar el valor de posCtlPid.xKp
try:
    scf.cf.param.set_value('posCtlPid.xKp', 2.5)
    scf.cf.param.request_param_update('posCtlPid.xKp')
    xKp_value = scf.cf.param.get_value('posCtlPid.xKp')
    print(f'Nuevo valor de posCtlPid.xKp: {xKp_value}')
except Exception as e:
    print(f'Error al modificar posCtlPid.xKp: {str(e)}')

scf.close_link()