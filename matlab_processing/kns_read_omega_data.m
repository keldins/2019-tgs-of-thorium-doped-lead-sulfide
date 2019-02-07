function [time_stamp,T_out]=kns_read_omega_data(T_file)
% Designed to read the temperature vs. time file for data recorded on the
% Omega controller

T_log=textscan(fopen(T_file),'%s %s %s %s %s %s','Delimiter',',');

n = length(T_log{1}) - 1; % first entries are column headers
disp(  strcat("num of entries in temperature log: ", num2str(n))  );

[hrs mins secs T_record] = deal(zeros(1,n));

for ii = 1:n
    T_record(ii) = str2double(T_log{2}{ii+1});

    % example: '02:40:29.814 2018-11-07'
    time_str     = T_log{1}{ii+1};
    hrs(ii)      = str2double(time_str(1:2));
    mins(ii)     = str2double(time_str(4:5));
    secs(ii)     = str2double(time_str(7:12));

    % No will be collected between 9am and 9pm (21 to 9),
    % so anything less than 9 must be a PM time that needs 12 added to it.
    if hrs(ii) < 9
        hrs(ii) = hrs(ii) + 12;
    end 
end

%Chop off some weird entries right at the beginning of the record as the
%controller was initializing
%temp_hr=temp_hr(4:end);
%temp_min=temp_min(4:end);
%temp_sec=temp_sec(4:end);
%temp_record=temp_record(4:end);

%For comparison with time stamps from TGS measurements
T_absolute_time = (hrs .* 3600) + (mins .* 60) + (secs);

T_out = T_record';
time_stamp = T_absolute_time';

fclose('all');

end
