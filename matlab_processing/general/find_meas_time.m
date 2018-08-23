function [meas_time]=find_meas_time(file)
% Function to read out the time stamp of a in situ beamline TGS measurement
% made at sandia

txtread=textscan(fopen(file),'%s %s','Delimiter','\t');
timestamp=txtread{2}{14};

if length(timestamp)==11
    ampm=timestamp(10:11);
    hr_storage=str2double(timestamp(1:2));
    if (strcmp(ampm,'PM') && floor(hr_storage)<12) || (strcmp(ampm,'AM') && floor(hr_storage)==12)
        hr_stamp=hr_storage+12;
    else
        hr_stamp=hr_storage;
    end
    min_stamp=str2double(timestamp(4:5));
    sec_stamp=str2double(timestamp(7:8));
else
    ampm=timestamp(9:10);
    hr_storage=str2double(timestamp(1));
    if strcmp(ampm,'PM')
        hr_stamp=hr_storage+12;
    else
        hr_stamp=hr_storage;
    end
    min_stamp=str2double(timestamp(3:4));
    sec_stamp=str2double(timestamp(6:7));
end

meas_time=hr_stamp*3600+min_stamp*60+sec_stamp;

fclose('all');
end