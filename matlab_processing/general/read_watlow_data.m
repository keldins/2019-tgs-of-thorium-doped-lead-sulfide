function [time_stamp,temp_out]=read_watlow_data(temp_file,plotty)
%Read out the watlow data that is recorded by the temperature controller on
%the Sandia beamline

if nargin<2
    plotty=0;
end

temp_log=textscan(fopen(temp_file),'%s %s %s','Delimiter','\t');

time_cell=temp_log{1};
temp_cell=temp_log{3};

temp_hr=zeros(1,length(time_cell)-1);
temp_min=zeros(1,length(time_cell)-1);
temp_sec=zeros(1,length(time_cell)-1);
temp_record=zeros(1,length(temp_cell)-1);

for jj=1:length(time_cell)-1
    if length(time_cell{jj+1})==11
        ampm=time_cell{jj+1}(10:11);
        hr_storage=str2double(time_cell{jj+1}(1:2));
        if (strcmp(ampm,'PM') && floor(hr_storage)<12) || (strcmp(ampm,'AM') && floor(hr_storage)==12)
            temp_hr(jj)=hr_storage+12;
        else
            temp_hr(jj)=hr_storage;
        end
        temp_min(jj)=str2double(time_cell{jj+1}(4:5));
        temp_sec(jj)=str2double(time_cell{jj+1}(7:8));
    else
        ampm=time_cell{jj+1}(9:10);
        hr_storage=str2double(time_cell{jj+1}(1));
        if strcmp(ampm,'PM')
            temp_hr(jj)=hr_storage+12;
        else
            temp_hr(jj)=hr_storage;
        end
        temp_min(jj)=str2double(time_cell{jj+1}(3:4));
        temp_sec(jj)=str2double(time_cell{jj+1}(6:7));
    end
    
    temp_record(jj)=str2double(temp_cell{jj+1});
end

absolute_time=temp_hr*3600+temp_min*60+temp_sec;

time_stamp=absolute_time;
temp_out=temp_record;

if plotty
    plot_time=(absolute_time-absolute_time(1))/60; %to plot out time in minutes
%     plot_time=(absolute_time)/60; %to plot out time in minutes
    figure()
    plot(plot_time,temp_record,'k-','LineWidth',1.25);
    set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25)
    ylabel(strcat('Temp. [',char(176),'C]'),...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    xlabel({'Time [min]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
end

fclose('all');

end