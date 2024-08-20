function prueba_callback()
    try 
        disp(['Prueba de función callback con timer.']);
    catch ME
        disp('Error.');
        disp(ME.message);
    end 
end