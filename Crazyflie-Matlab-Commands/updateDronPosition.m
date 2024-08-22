function updateDronPosition(tcp_obj, agent_id, scf)
    try 
        pos_OptiTrack = robotat_get_pose(tcp_obj, agent_id);
        crazyflie_update_position(scf, ...
            pos_OptiTrack(1), ...
            pos_OptiTrack(2), ...
            pos_OptiTrack(3));
        disp(['Robotat: ',num2str(pos_OptiTrack(1)),' ', num2str(pos_OptiTrack(2)),' ', num2str(pos_OptiTrack(3)-0.28734)]);
    catch ME
        disp('Error al actualizar position del marker.');
        disp(ME.message);
    end 
end