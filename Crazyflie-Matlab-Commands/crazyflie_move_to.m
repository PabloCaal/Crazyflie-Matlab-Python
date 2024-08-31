function crazyflie_move_to(scf, x, y, z, velocity)
    % Set default values if velocity is not provided
    if nargin < 5 || isempty(velocity)
        velocity = 0.5;  % Default velocity in meters per second
    end

    % Validate the SyncCrazyflie object
    if ~isa(scf, 'py.cflib.crazyflie.syncCrazyflie.SyncCrazyflie')
        error('ERROR: Invalid SyncCrazyflie object.');
    end
    
    % Validate the x, y, z inputs and the velocity input
    if ~isnumeric(x) || ~isnumeric(y) || ~isnumeric(z)
        error('ERROR: x, y, and z must be numeric values.');
    end
    if ~isnumeric(velocity) || velocity <= 0.0
        warning('Velocity must be a positive number. Using default velocity of 0.5 meters per second.');
        velocity = 0.5;  % Use default velocity if validation fails
    end

    % Attempt to send the Crazyflie to the specified position (returns an error code)
    position_code = py.crazyflie_commands.move_to(scf, x, y, z, velocity);
    
    % Check the result of the position command
    if position_code == 0
        disp('Position command successful.');
    elseif position_code == 1
        error('ERROR: Invalid position or velocity parameters.');
    elseif position_code == 2
        error('ERROR: An error occurred during the position command.');
    else
        error('ERROR: Unexpected result from Python during the position command.');
    end
end