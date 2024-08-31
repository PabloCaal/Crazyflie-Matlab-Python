"""
Script de Python con la librería Cflib de Bitcraze y funciones básicas 
para el control de los drones Crazyflie. Esto forma parte del trabajo de 
graduación titulado "Desarrollo de herramientas de software para el 
control individual y seguro del cuadricóptero Crazyflie 2.1 utilizando 
la placa de expansión de posicionamiento con odometría visual Flow
Deck".
"""

import logging
import time
from threading import Event

import cflib.crtp
from cflib.crazyflie import Crazyflie
from cflib.crazyflie.log import LogConfig
from cflib.crazyflie.syncCrazyflie import SyncCrazyflie
from cflib.positioning.motion_commander import MotionCommander
from cflib.crazyflie.high_level_commander import HighLevelCommander

cflib.crtp.init_drivers(enable_debug_driver=False)

logging.basicConfig(level=logging.CRITICAL)
   
def error_callback(error):
    print(f"Link error: {error}")

def connect(uri):
    """
    Connects to the Crazyflie at the specified URI.
    
    Parameters:
    uri (str): The URI of the Crazyflie to connect to.
    
    Returns:
    scf (SyncCrazyflie): The connected SyncCrazyflie object if successful.
    int: A numeric code indicating the error if the connection fails.
         0 - General error
         1 - Crazyradio Dongle not found
         2 - Connection timed out
         3 - Connection timed out
    """
    try:
        # Attempt to create a SyncCrazyflie instance and open a link to the Crazyflie
        scf = SyncCrazyflie(uri, cf=Crazyflie(rw_cache='./cache'))
        scf.open_link()
        return scf
    except Exception as e:
        # Handle specific error cases and return a corresponding numeric code
        if 'Cannot find a Crazyradio Dongle' in str(e):
            return 1  # Error code 1: Crazyradio Dongle not found
        elif 'Connection refused' in str(e):
            return 2  # Error code 2: Connection refused
        elif 'Timeout' in str(e):
            return 3  # Error code 3: Connection timed out
        else:
            return 0  # Error code 0: General error

def disconnect(scf):
    scf.close_link()

def takeoff(scf, height, duration):
    """
    Commands the Crazyflie to take off to a specified height.
    
    Parameters:
    scf (SyncCrazyflie): The SyncCrazyflie object representing the connection to the Crazyflie.
    height (float): The target height in meters.
    duration (float): The duration of the takeoff in seconds.
    
    Returns:
    int: A numeric code indicating the result of the takeoff attempt.
         0 - Successful takeoff
         1 - Crazyflie was already in the air
         2 - General error occurred during takeoff
    """
    try:
        # Get the current position using the get_position function
        position = get_position(scf)
        current_z = position[2]  # Extract the current altitude (z)

        # Check if the Crazyflie is already in the air (e.g., above 0.1 meters)
        if current_z > 0.1:
            return 1  # Crazyflie is already in the air

        # Command the takeoff
        commander = HighLevelCommander(scf.cf)
        commander.takeoff(absolute_height_m=height, duration_s=duration)

        # Wait for the takeoff to complete
        time.sleep(duration)

        return 0  # Success: Takeoff completed successfully

    except Exception as e:
        # Handle any unexpected errors during takeoff
        print(f"ERROR: An error occurred during takeoff: {str(e)}")
        return 2  # Error code 2: General error

def land(scf, height, duration):
    """
    Commands the Crazyflie to land from the current height to a specified height.
    
    Parameters:
    scf (SyncCrazyflie): The SyncCrazyflie object representing the connection to the Crazyflie.
    height (float): The target height in meters (should typically be 0 for a complete landing).
    duration (float): The duration of the landing in seconds.
    
    Returns:
    int: A numeric code indicating the result of the landing attempt.
         0 - Successful landing
         1 - Crazyflie was already on the ground
         2 - General error occurred during landing
    """
    try:
        # Get the current position using the get_position function
        position = get_position(scf)
        current_z = position[2]  # Extract the current altitude (z)

        # Check if the Crazyflie is already on the ground (e.g., below 0.1 meters)
        if current_z <= 0.1:
            return 1  # Crazyflie is already on the ground

        # Command the landing
        commander = HighLevelCommander(scf.cf)
        commander.land(absolute_height_m=height, duration_s=duration)

        # Wait for the landing to complete
        time.sleep(duration)

        # Stop the commander after landing
        commander.stop()

        return 0  # Success: Landing completed successfully

    except Exception as e:
        # Handle any unexpected errors during landing
        print(f"ERROR: An error occurred during landing: {str(e)}")
        return 2  # Error code 2: General error

def move_to(scf, x, y, z, velocity=0.5):
    """
    Move the Crazyflie to the specified position (x, y, z) using MotionCommander.
    
    Parameters:
    scf (SyncCrazyflie): The SyncCrazyflie object representing the connection to the Crazyflie.
    x (float): The target x-coordinate in meters.
    y (float): The target y-coordinate in meters.
    z (float): The target z-coordinate in meters.
    velocity (float): The velocity of the movement in meters per second (default is 0.5 m/s).
    
    Returns:
    int: A numeric code indicating the result of the position command.
         0 - Successful position command
         1 - Invalid position or velocity parameters
         2 - General error occurred during movement
    """
    try:
        # Validate input parameters
        if not all(isinstance(coord, (int, float)) for coord in [x, y, z]) or velocity <= 0.0:
            return 1  # Error code 1: Invalid input parameters

        # Use MotionCommander to move to the specified position
        with MotionCommander(scf) as mc:
            mc.move_distance(x, y, z, velocity)

        return 0  # Success: Position command completed successfully

    except Exception as e:
        # Handle any unexpected errors during the position command
        print(f"ERROR: An error occurred during the position command: {str(e)}")
        return 2  # Error code 2: General error

def get_position(scf):
    """
    Retrieves the current position of the Crazyflie.
    
    Parameters:
    scf (SyncCrazyflie): The SyncCrazyflie object representing the connection to the Crazyflie.
    
    Returns:
    list: A list containing the pose of the Crazyflie as [x, y, z].
          x, y, z are the coordinates in meters.
    int: A numeric code indicating an error if retrieval fails.
         1 - Error in retrieving data
         2 - General error occurred
    """
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

def get_pose(scf):
    """
    Retrieves the current pose (position and orientation) of the Crazyflie.
    
    Parameters:
    scf (SyncCrazyflie): The SyncCrazyflie object representing the connection to the Crazyflie.
    
    Returns:
    list: A list containing the pose of the Crazyflie as [x, y, z, roll, pitch, yaw].
          x, y, z are the coordinates in meters.
          roll, pitch, yaw are the angles in radians.
    int: A numeric code indicating an error if retrieval fails.
         1 - Error in retrieving data
         2 - General error occurred
    """
    try:
        # Set up the log configuration to get position and orientation data
        pose_log_config = LogConfig(name='Pose', period_in_ms=100)
        pose_log_config.add_variable('stateEstimate.x', 'float')
        pose_log_config.add_variable('stateEstimate.y', 'float')
        pose_log_config.add_variable('stateEstimate.z', 'float')
        pose_log_config.add_variable('stateEstimate.roll', 'float')
        pose_log_config.add_variable('stateEstimate.pitch', 'float')
        pose_log_config.add_variable('stateEstimate.yaw', 'float')

        pose = {'x': 0.0, 'y': 0.0, 'z': 0.0, 'roll': 0.0, 'pitch': 0.0, 'yaw': 0.0}
        new_data = Event()

        def pose_callback(timestamp, data, logconf):
            pose['x'] = data['stateEstimate.x']
            pose['y'] = data['stateEstimate.y']
            pose['z'] = data['stateEstimate.z']
            pose['roll'] = data['stateEstimate.roll']
            pose['pitch'] = data['stateEstimate.pitch']
            pose['yaw'] = data['stateEstimate.yaw']
            new_data.set()

        pose_log_config.data_received_cb.add_callback(pose_callback)

        try:
            existing_configs = scf.cf.log.log_blocks
            for config in existing_configs:
                if config.name == 'Pose':
                    config.stop()
                    config.delete()
        except AttributeError:
            pass  

        scf.cf.log.add_config(pose_log_config)
        pose_log_config.start()
        new_data.wait()
        pose_log_config.stop()

        # Return the pose as a list
        return [pose['x'], pose['y'], pose['z'], pose['roll'], pose['pitch'], pose['yaw']]

    except Exception as e:
        # print(f"ERROR: An error occurred while retrieving the pose: {str(e)}")
        return 2  # General error code

def update_position(scf, x, y, z):
    """
    Updates the external position of the Crazyflie with the provided coordinates.
    
    Parameters:
    scf (SyncCrazyflie): The SyncCrazyflie object representing the connection to the Crazyflie.
    x (float): The x-coordinate in meters.
    y (float): The y-coordinate in meters.
    z (float): The z-coordinate in meters.
    
    Returns:
    int: A numeric code indicating the result of the update position command.
         0 - Successful position update
         1 - Invalid position parameters
         2 - General error occurred during the update
    """
    try:
        # Validate input parameters
        if not all(isinstance(coord, (int, float)) for coord in [x, y, z]):
            return 1  # Error code 1: Invalid input parameters

        # Send the external position update to the Crazyflie
        scf.cf.extpos.send_extpos(x, y, z)
        
        # Small delay to ensure the update is processed
        time.sleep(0.01)

        return 0  # Success: Position update completed successfully

    except Exception as e:
        # Handle any unexpected errors during the update
        # print(f"ERROR: An error occurred during the position update: {str(e)}")
        return 2  # Error code 2: General error
    
def get_pid_values(scf):
    """
    Retrieves the current PID controller parameters from the Crazyflie for X, Y, Z axes.
    
    Parameters:
    scf (SyncCrazyflie): The SyncCrazyflie object representing the connection to the Crazyflie.
    
    Returns:
    dict: A dictionary containing the PID values for X, Y, Z as {'X': [P, I, D], 'Y': [P, I, D], 'Z': [P, I, D]}.
    int: A numeric code indicating an error if retrieval fails.
         1 - General error occurred
    """
    try:
        # Obtener los valores PID para los ejes X, Y, Z
        pid_values = {
            'X': [
                float(scf.cf.param.get_value('posCtlPid.xKp')),
                float(scf.cf.param.get_value('posCtlPid.xKi')),
                float(scf.cf.param.get_value('posCtlPid.xKd'))
            ],
            'Y': [
                float(scf.cf.param.get_value('posCtlPid.yKp')),
                float(scf.cf.param.get_value('posCtlPid.yKi')),
                float(scf.cf.param.get_value('posCtlPid.yKd'))
            ],
            'Z': [
                float(scf.cf.param.get_value('posCtlPid.zKp')),
                float(scf.cf.param.get_value('posCtlPid.zKi')),
                float(scf.cf.param.get_value('posCtlPid.zKd'))
            ]
        }

        # Retornar los valores PID organizados por ejes
        return pid_values
    
    except Exception as e:
        # Retornar un código de error general
        return 1  # Código de error general

def modify_pid(scf, p_gains, i_gains, d_gains):
    """
    Modifies the PID controller parameters on the Crazyflie using an existing connection.
    
    Parameters:
    scf (SyncCrazyflie): The SyncCrazyflie object representing the connection to the Crazyflie.
    p_gains (dict): A dictionary with proportional gains for X, Y, Z axes.
    i_gains (dict): A dictionary with integral gains for X, Y, Z axes.
    d_gains (dict): A dictionary with derivative gains for X, Y, Z axes.
    
    Returns:
    int: A numeric code indicating the result of the operation.
         0 - Success
         1 - Parameter setting failed
    """
    try:       
        # X Axis
        scf.cf.param.set_value('posCtlPid.xKp', p_gains['X'])
        scf.cf.param.set_value('posCtlPid.xKi', i_gains['X'])
        scf.cf.param.set_value('posCtlPid.xKd', d_gains['X'])
        
        # Y Axis
        scf.cf.param.set_value('posCtlPid.yKp', p_gains['Y'])
        scf.cf.param.set_value('posCtlPid.yKi', i_gains['Y'])
        scf.cf.param.set_value('posCtlPid.yKd', d_gains['Y'])
        
        # Z Axis
        scf.cf.param.set_value('posCtlPid.zKp', p_gains['Z'])
        scf.cf.param.set_value('posCtlPid.zKi', i_gains['Z'])
        scf.cf.param.set_value('posCtlPid.zKd', d_gains['Z'])
        
        return 0  # Success
    
    except Exception as e:
        # Handle any unexpected errors during PID modification
        return 1  # Error code 1: Parameter setting failed
