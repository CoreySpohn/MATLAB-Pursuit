% Serial Communication

% This program was created for the Group 5 ESM Capstone Design Project with
% Professor Nicole Abaid. It is just a simple serial communication code to 
% test how to use Matlab for serial communication.

%-----[ Main ]------------------------------------
%practice opening serial connection and sending data
try
    fclose(xBee);
    delete(xBee);
    clear xBee;
    fprintf('Old MATLAB serial port needed to be closed first\n');
catch
end

try
    xBee = serial('COM4', 'BaudRate', 115200, 'Parity', 'none', 'DataBits', 8);
    fopen(xBee);
    fprintf('Matlab serial port was created\n');
    
    pause(1);

    while 1
        try
            %read robot prompt   
            while(xBee.BytesAvailable > 0)
                read = fscanf(xBee);
                fprintf('"');
                fprintf(read); 
                fprintf('"');
            end

            %output to robot
            str = input('Input: ', 's');
            if(strcmp(str,'exit'))
                break
            end
            fprintf(xBee,'%s',str);

            pause(2);
            %read the value the arduino returned
            while(xBee.BytesAvailable > 0)
                read = fscanf(xBee);
                fprintf('"'); 
                fprintf(read); 
                fprintf('"\n'); 
            end
        catch ME
            fprintf('ERROR\n');
            fprintf(ME);
        end
    end
    
    %close serial port
    fclose(xBee);
    delete(xBee);
    clear arduino;
    fprintf('Matlab serial port was closed\n');
    fprintf('END\n');
catch
    fprintf('Matlab serial port failed to be created.\n');
end
