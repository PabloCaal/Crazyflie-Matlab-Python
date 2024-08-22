function crazyflie_takeoff(scf, height, duration)
    % Set default values if height or duration are not provided
    if nargin < 2 || isempty(height)
        height = 0.5;  % Default height in meters
    end
    if nargin < 3 || isempty(duration)
        duration = 2.0;  % Default duration in seconds
    end

    % Validate the SyncCrazyflie object
    if ~isa(scf, 'py.cflib.crazyflie.syncCrazyflie.SyncCrazyflie')
        error('ERROR: Invalid SyncCrazyflie object.');
    end
    
    % Validate the height input and the duration input
    if ~isnumeric(height) || height <= 0.1
        warning('Height must be greater than 0.1 meters. Using default height of 1.0 meter.');
        height = 0.5;  % Use default height if validation fails
    end
    if ~isnumeric(duration) || duration < 1.0
        warning('Duration must be at least 1 second. Using default duration of 2.0 seconds.');
        duration = 2.0;  % Use default duration if validation fails
    end

    % Attempt to command the Crazyflie to take off (returns an error code)
    takeoff_code = py.crazyflie_commands.takeoff(scf, height, duration);
    
    % Check the result of the takeoff attempt
    if takeoff_code == 0
        disp('Takeoff successful.');
    elseif takeoff_code == 1
        disp('The Crazyflie was already in the air.');
    elseif takeoff_code == 2
        error('ERROR: An error occurred during takeoff.');
    else
        error('ERROR: Unexpected result from Python during takeoff.');
    end
end
