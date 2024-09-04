function crazyflie_send_position(scf, x, y, z)    
    % Validate the x, y, z inputs
    if ~isnumeric(x) || ~isnumeric(y) || ~isnumeric(z)
        error('ERROR: x, y, and z must be numeric values.');
    end

    % Attempt to send the Crazyflie to the specified position (returns an error code)
    position_code = py.crazyflie_commands.send_position(scf, x, y, z);
    disp(position_code);
end