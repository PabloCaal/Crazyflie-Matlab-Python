function crazyflie_modify_pid(scf, p_gains, i_gains, d_gains)
    % Validate the SyncCrazyflie object
    if ~isa(scf, 'py.cflib.crazyflie.syncCrazyflie.SyncCrazyflie')
        error('ERROR: Invalid SyncCrazyflie object.');
    end

    % Convert MATLAB structures to Python dictionaries
    py_p_gains = py.dict(p_gains);
    py_i_gains = py.dict(i_gains);
    py_d_gains = py.dict(d_gains);

    % Call the Python function to modify the PID values
    pid_result = py.crazyflie_commands.modify_pid(scf, py_p_gains, py_i_gains, py_d_gains);
    
    % Check the result of the PID modification attempt
    if pid_result == 0
        disp('PID modification successful.');
    elseif pid_result == 1
        error('ERROR: Failed to set PID parameters.');
    else
        error('ERROR: Unexpected result from Python during PID modification.');
    end
end