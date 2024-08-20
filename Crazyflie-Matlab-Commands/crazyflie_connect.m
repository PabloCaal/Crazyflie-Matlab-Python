function scf = crazyflie_connect(drone_number)   
    % Validate the drone_number input
    if drone_number < 1 || drone_number > 12
        error('ERROR: Invalid drone number.');
    end

    % Define URIs for each drone number
    uris = {
        'radio://0/80/2M/E7E7E7E7E0',
        'radio://0/80/2M/E7E7E7E7E1',
        'radio://0/80/2M/E7E7E7E7E2',
        'radio://0/80/2M/E7E7E7E7E3',
        'radio://0/80/2M/E7E7E7E7E4',
        'radio://0/80/2M/E7E7E7E7E5',
        'radio://0/80/2M/E7E7E7E7E6',
        'radio://0/80/2M/E7E7E7E7E7',
        'radio://0/80/2M/E7E7E7E7D0',
        'radio://0/80/2M/E7E7E7E7D1',
        'radio://0/80/2M/E7E7E7E7D2',
        'radio://0/80/2M/E7E7E7E7D3'
    };

    % Form the URI corresponding o the drone number
    uri = uris{drone_number};

    % Get the directory of the current file
    [currentFilePath,~,~] = fileparts(mfilename('fullpath'));

    % Add the Python file path to the Python path if not already added
    if count(py.sys.path,currentFilePath) == 0
        insert(py.sys.path,int32(0),currentFilePath);
    end
    
    % Import and reload the Python module to ensure Matlab sees the changes
    crazyflie_commands = py.importlib.import_module('crazyflie_commands');
    py.importlib.reload(crazyflie_commands);
    
    % Connect to the Crazyflie (scf = SyncCrazyflie object)
    scf = crazyflie_commands.connect_crazyflie(uri);
        
    if(scf == 0)
        error('ERROR: Could not connect to the Crazyflie.');
    elseif (scf == 1)
        error('ERROR: Cannot find a Crazyradio Dongle.');
    else
        disp('Connection established.');
    end
end