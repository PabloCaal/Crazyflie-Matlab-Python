function crazyflie_land(scf, height, duration)
    % Set default values if height or duration are not provided
    if nargin < 2 || isempty(height)
        height = 0.0;  % Default height in meters for landing (typically 0 for full landing)
    end
    if nargin < 3 || isempty(duration)
        duration = 2.0;  % Default duration in seconds
    end

    % Validate the SyncCrazyflie object
    if ~isa(scf, 'py.cflib.crazyflie.syncCrazyflie.SyncCrazyflie')
        error('ERROR: Invalid SyncCrazyflie object.');
    end
    
    % Validate the height input and the duration input
    if ~isnumeric(height) || height < 0.0
        warning('Height must be 0 or greater for landing. Using default height of 0.0 meters.');
        height = 0.0;  % Use default height if validation fails
    end
    if ~isnumeric(duration) || duration < 2.0
        warning('Duration must be at least 2 seconds. Using default duration of 2.0 seconds.');
        duration = 2.0;  % Use default duration if validation fails
    end

    % Attempt to command the Crazyflie to land (returns an error code)
    land_code = py.crazyflie_commands.land(scf, height, duration);
    
    % Check the result of the landing attempt
    if land_code == 0
        disp('Landing successful.');
    elseif land_code == 1
        disp('The Crazyflie was already on the ground.');
    elseif land_code == 2
        error('ERROR: An error occurred during landing.');
    else
        error('ERROR: Unexpected result from Python during landing.');
    end
end