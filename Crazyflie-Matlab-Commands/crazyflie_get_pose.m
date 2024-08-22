function pose = crazyflie_get_pose(scf)
    % Validate the SyncCrazyflie object
    if ~isa(scf, 'py.cflib.crazyflie.syncCrazyflie.SyncCrazyflie')
        error('ERROR: Invalid SyncCrazyflie object.');
    end

    % Attempt to retrieve the pose of the Crazyflie (returns a list or an error code)
    pose_result = py.crazyflie_commands.get_pose(scf);
    
    % Check if the result is a list (successful retrieval) or an int (error code)
    if isa(pose_result, 'py.list')
        % Convert Python list to MATLAB array
        pose = double(pose_result);
        fprintf('Pose retrieved successfully:\n');
        fprintf('x: %.2f, y: %.2f, z: %.2f, roll: %.2f, pitch: %.2f, yaw: %.2f\n', ...
                pose(1), pose(2), pose(3), pose(4), pose(5), pose(6));
    else
        % Convert Python int to MATLAB double
        error_code = int64(pose_result);
        if error_code == 1
            error('ERROR: Error in retrieving pose data.');
        elseif error_code == 2
            error('ERROR: General error occurred while retrieving pose.');
        else
            error('ERROR: Unexpected result from Python during pose retrieval.');
        end
    end
end