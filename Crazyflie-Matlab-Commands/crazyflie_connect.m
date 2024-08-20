function scf = crazyflie_connect(drone_number)
    % Validate the drone_number input
    if ~isnumeric(drone_number) || mod(drone_number, 1) ~= 0 || drone_number < 1 || drone_number > 12
        error('ERROR: Invalid drone number. It must be an integer between 1 and 12.');
    end

    % Define URIs for each drone number
    uris = {
        'radio://0/80/2M/E7E7E7E7E0', % Drone 1
        'radio://0/80/2M/E7E7E7E7E1', % Drone 2
        'radio://0/80/2M/E7E7E7E7E2', % Drone 3
        'radio://0/80/2M/E7E7E7E7E3', % Drone 4
        'radio://0/80/2M/E7E7E7E7E4', % Drone 5
        'radio://0/80/2M/E7E7E7E7E5', % Drone 6
        'radio://0/80/2M/E7E7E7E7E6', % Drone 7
        'radio://0/80/2M/E7E7E7E7E7', % Drone 8
        'radio://0/80/2M/E7E7E7E7D0', % Drone 9
        'radio://0/80/2M/E7E7E7E7D1', % Drone 10
        'radio://0/80/2M/E7E7E7E7D2', % Drone 11
        'radio://0/80/2M/E7E7E7E7D3'  % Drone 12
    };

    % Form the URI corresponding to the specified drone number
    uri = uris{drone_number};

    % Get the full path of the current MATLAB script
    current_folder = fileparts(mfilename('fullpath'));

    % Construct the path to the Python functions folder
    python_folder = fullfile(current_folder, '..', 'Crazyflie-Python-Functions');
    
    % Add the Python functions folder to the Python sys.path
    if count(py.sys.path, python_folder) == 0
        insert(py.sys.path, int32(0), python_folder);
    end
    
    % Attempt to connect to the Crazyflie (scf = SyncCrazyflie object or error code)
    scf = py.crazyflie_commands.connect(uri);
    
    % Check if the result is an int (error code) or an object (successful connection)
    if isa(scf, 'py.int')
        % Convert Python int to MATLAB double
        error_code = int64(scf);
        if error_code == 1
            error('ERROR: Crazyradio Dongle not found. Please check the USB connection.');
        elseif error_code == 2
            error('ERROR: Connection refused. The Crazyflie might be busy or unavailable.');
        elseif error_code == 3
            error('ERROR: Connection timed out. The Crazyflie did not respond.');
        else
            error('ERROR: An unspecified error occurred during connection.');
        end
    elseif isa(scf, 'py.cflib.crazyflie.syncCrazyflie.SyncCrazyflie')
        disp('Connection established successfully.');
    else
        error('ERROR: Unexpected result from Python. Connection might have failed.');
    end
end
