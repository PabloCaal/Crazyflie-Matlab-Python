function print_test()
    % Disconnect from Crazyflie and clear the scf from the workspace
    % Attempt to disconnect from Crazyflie with error handling
    try
        r = py.crazyflie_commands.print_test();
    catch ME
        error('Error using crazyflie_commands>print_test: %s', ME.message);
    end
end 