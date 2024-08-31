function pid_values = crazyflie_get_pid(scf)
    % Validate the SyncCrazyflie object
    if ~isa(scf, 'py.cflib.crazyflie.syncCrazyflie.SyncCrazyflie')
        error('ERROR: Invalid SyncCrazyflie object.');
    end

    % Attempt to retrieve the PID values from the Crazyflie (returns a list or an error code)
    pid_result = py.crazyflie_commands.get_pid_values(scf);
    
    % Check if the result is a Python dict (successful retrieval) or an int (error code)
    if isa(pid_result, 'py.dict')
        % Convert Python dictionary to MATLAB structure
        pid_values.X = [double(pid_result{'X'}{1}), double(pid_result{'X'}{2}), double(pid_result{'X'}{3})];
        pid_values.Y = [double(pid_result{'Y'}{1}), double(pid_result{'Y'}{2}), double(pid_result{'Y'}{3})];
        pid_values.Z = [double(pid_result{'Z'}{1}), double(pid_result{'Z'}{2}), double(pid_result{'Z'}{3})];
        
        fprintf('PID values retrieved successfully:\n');
        fprintf('X: P=%.2f, I=%.2f, D=%.2f\n', pid_values.X(1), pid_values.X(2), pid_values.X(3));
        fprintf('Y: P=%.2f, I=%.2f, D=%.2f\n', pid_values.Y(1), pid_values.Y(2), pid_values.Y(3));
        fprintf('Z: P=%.2f, I=%.2f, D=%.2f\n', pid_values.Z(1), pid_values.Z(2), pid_values.Z(3));
    else
        % Convert Python int to MATLAB double
        error_code = int64(pid_result);
        if error_code == 1
            error('ERROR: Error in retrieving PID data.');
        else
            error('ERROR: Unexpected result from Python during PID retrieval.');
        end
    end
end
