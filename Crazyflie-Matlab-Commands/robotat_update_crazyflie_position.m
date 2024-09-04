function robotat_update_crazyflie_position(scf, tcp_obj, agents_ids)
    max_retries = 3; % Número máximo de reintentos en caso de fallo
    for attempt = 1:max_retries
        try
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
                end

                if(timeout_count == timeout_in100ms)
                    disp('ERROR: Could not receive data from server.');
                    % Intentar de nuevo
                    continue;
                else
                    data = char(read(tcp_obj));
                    if isempty(data)
                        disp('ERROR: Received empty data.');
                        continue;
                    end
                    % Intentar decodificar el JSON recibido
                    absolute_position = jsondecode(data);
                    
                    if numel(absolute_position) < 7
                        disp('ERROR: Incomplete JSON data.');
                        continue;
                    end

                    absolute_position = reshape(absolute_position, [7, numel(agents_ids)])';

                    x = absolute_position(1);
                    y = absolute_position(2);
                    z = absolute_position(3);

                    % Intentar actualizar la posición del Crazyflie
                    % Check the result of the update position command

                    update_code = py.crazyflie_commands.update_position(scf, x, y, z);
                    if update_code == 0
                        disp('Pose actualizada.');
                    elseif update_code == 1
                        error('ERROR: Invalid position parameters.');
                    elseif update_code == 2
                        error('ERROR: An error occurred during the position update.');
                    else
                        error('ERROR: Unexpected result from Python during the position update.');
                    end

                    % Si llegaste aquí, la actualización fue exitosa
                    break;
                end
            else
                disp('ERROR: Invalid ID(s).');
                return;
            end
        catch ME
            disp(['ERROR: ', ME.message]);
            % Si hay un error, intentamos de nuevo hasta max_retries
            if attempt == max_retries
                disp('Max retries reached, exiting.');
            else
                disp('Retrying...');
            end
        end
    end
end
