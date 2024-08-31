function robotat_update_crazyflie_position(scf, tcp_obj, agents_ids)
    timeout_count = 0;
    timeout_in100ms = 1 / 0.1;
    read(tcp_obj); % Limpia el buffer de lecturas

    if((min(agents_ids) > 0) && (max(agents_ids) <= 100))
        s.dst = 1; % DST_ROBOTAT
        s.cmd = 1; % CMD_GET_POSE
        s.pld = round(agents_ids);
        write(tcp_obj, uint8(jsonencode(s)));  

        while((tcp_obj.BytesAvailable == 0) && (timeout_count < timeout_in100ms))
            timeout_count = timeout_count + 1;
            pause(0.1);
            drawnow; % Permite que MATLAB procese otros eventos
        end

        if(timeout_count == timeout_in100ms)
            disp('ERROR: Could not receive data from server.');
            return;
        else
            
            absolute_position = jsondecode(char(read(tcp_obj)));
            absolute_position = reshape(absolute_position, [7, numel(agents_ids)])';

            x = absolute_position(1);
            y = absolute_position(2);
            z = absolute_position(3);

            disp(x);
            disp(y);
            disp(" ");
            drawnow; % Otra llamada para procesar eventos durante la pausa

            % Attempt to update the external position of the Crazyflie (returns an error code)
            % update_code = py.crazyflie_commands.update_position(scf, x, y, z);
            % Check the result of the update position command
            % if update_code == 0
            %     disp('Pose actualizada.');
            % elseif update_code == 1
            %     error('ERROR: Invalid position parameters.');
            % elseif update_code == 2
            %     error('ERROR: An error occurred during the position update.');
            % else
            %     error('ERROR: Unexpected result from Python during the position update.');
            % end
            
        end
    else
        disp('ERROR: Invalid ID(s).');
    end