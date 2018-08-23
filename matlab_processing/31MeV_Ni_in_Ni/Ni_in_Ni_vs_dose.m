%script to plot the Ni into Ni data from 2018-02-02 as a function of dose
%received by the sample, calibrating to online BPM current measurements

%%%%%%%%%%%%%%%%%%
%Needs to be run from a directory containing the following files, do the processing of TGS data first before running this routine since processing is the longest step.
%beam_current_1.csv
%VACANCY.txt from the correct SRIM run
%Ni_in_Ni_data_w_therm_new.mat
%temp_log_31MeV_Ni_in_Ni_2018_02_02_002.txt
%%%%%%%%%%%%%%%%%%

cal_grat_units=4.5447e-6; %in m

average_dose=1;
stop_on_fail=1;

start_stamp=10*3600+50*60; %when cup was open, in seconds
grat=4.5447; %in um
spot_size=pi*(0.16/2)^2; %in cm^2
charge_state=5;
elementary_charge=1.6021766e-19;

%read in current_v_time data
[c_time,c_current]=read_current_data_2018_02_02('beam_current_1.csv',10,0);
c_current_units=c_current*10^-9; %in amps

%start cumulative total beginning at cup open time
[~,strt_idx]=min(abs(c_time-start_stamp));
c_time=c_time(strt_idx:end);
c_current_units=c_current_units(strt_idx:end);

%to use for plotting later
c_current_plot=c_current(strt_idx:end);

display('Average beam current:')
display(mean(c_current_plot))

cum_current_units=cumtrapz(c_time,c_current_units);

cum_fluence=cum_current_units/(spot_size*charge_state*elementary_charge); %in num/cm^2

[~,dpa_over_fluence,depth]=read_SRIM_vac('SRIM_profile/VACANCY.txt',grat,0);

if average_dose
    [~,stop_idx]=min(abs(depth-grat));
    dose_calibration=mean(dpa_over_fluence(1:stop_idx));
    
    [~,stop_idx_therm]=min(abs(depth-grat/pi));
    dose_calibration_therm=mean(dpa_over_fluence(1:stop_idx_therm));
else
    dose_calibration=max(dpa_over_fluence);
    dose_calibration_therm=max(dpa_over_fluence);
end

cum_dose=cum_fluence*dose_calibration;
cum_dose_therm=cum_fluence*dose_calibration_therm;

if average_dose
    display('Average dose received:')
else
    display('Peak dose received:')
end

display(cum_dose(end))

if average_dose
    display('Average dose rate:')
else
    display('Peak dose rate:')
end
display(cum_dose(end)/(c_time(end)-start_stamp))

load('Ni_in_Ni_data_w_therm_new.mat')
r_time=Ni_in_Ni_data_w_therm(:,1)';
r_freq=Ni_in_Ni_data_w_therm(:,2)';
r_speed=Ni_in_Ni_data_w_therm(:,3)';
r_diff=Ni_in_Ni_data_w_therm(:,4)';

r_diff=r_diff*10^4; %to put in cm^2/s

if stop_on_fail
    stop_time=1110*60; %in sec
    [~,stop_index]=min(abs(r_time-stop_time));
    
    r_time=r_time(1:stop_index);
    r_freq=r_freq(1:stop_index);
    r_speed=r_speed(1:stop_index);
    r_diff=r_diff(1:stop_index);
end

if r_time(end)>c_time(end)
    [~,stp_idx]=min(abs(r_time-c_time(end)));
    r_time=r_time(1:stp_idx);
    r_freq=r_freq(1:stp_idx);
    r_speed=r_speed(1:stp_idx);
    r_diff=r_diff(1:stp_idx);
end

r_speed_cal=r_freq*cal_grat_units;

r_doses=zeros(1,length(r_speed));
r_doses_therm=zeros(1,length(r_speed));
for jj=1:length(r_time)
    r_doses(jj)=interpolate_general(r_time(jj),c_time,cum_dose);
    r_doses_therm(jj)=interpolate_general(r_time(jj),c_time,cum_dose_therm);
end
 
%Temp data block
[t_time,t_temp]=read_watlow_data('temp_log_31MeV_Ni_in_Ni_2018_02_02_002.txt');

if t_time(end)>c_time(end)
    [~,stp_idx]=min(abs(t_time-c_time(end)));
    t_time=t_time(1:stp_idx);
    t_temp=t_temp(1:stp_idx);
end

t_doses=zeros(1,length(t_temp));
for jj=1:length(t_time)
    t_doses(jj)=interpolate_general(t_time(jj),c_time,cum_dose);
end
    
plot_lim=r_doses(end);
plot_lim_therm=r_doses_therm(end);
x_dose_tick=0:2:20;
x_dose_tick_therm=0:1:6;
x_time_labels=cell(1,length(x_dose_tick));
x_time_labels_therm=cell(1,length(x_dose_tick_therm));
t_naught=0;
t_naught_therm=0;
for jj=1:length(x_dose_tick)
    time_val=interpolate_general(x_dose_tick(jj),cum_dose,c_time)/60; %time in min
    if jj==1
        t_naught=time_val;
    end
    x_time_labels{jj}=num2str(round((time_val-t_naught)/60,1));
end
for jj=1:length(x_dose_tick_therm)
    time_val_therm=interpolate_general(x_dose_tick_therm(jj),cum_dose_therm,c_time)/60; %time in min
    if jj==1
        t_naught_therm=time_val_therm;
    end
    x_time_labels_therm{jj}=num2str(round((time_val_therm-t_naught_therm)/60,1));
end

figure('Position',[100 100 500 800])
%make subplots from the bottom up
subplot('Position',[0.14 0.08 0.83 0.17])
plot(t_doses,t_temp,'k-','LineWidth',1.25)
xlim([0 plot_lim])
ylim([548.5 551.5])
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'YTick',[549 550 551],...
        'XTick',x_dose_tick)
    ylabel(strcat('Temp. [',char(176),'C]'),...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    xlabel({'Average Dose [dpa]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
%middle plot
subplot('Position',[0.14 0.25 0.83 0.5])
plot(r_doses,r_speed_cal,'kx')
xlim([0 plot_lim])
ylim([2425 2437])
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'XTick',x_dose_tick,...
        'Xticklabel',{},...
        'YTick',[2426 2428 2430 2432 2434 2436])
    ylabel({'SAW Speed [m/s]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
%top plot
subplot('Position',[0.14 0.75 0.83 0.17])
plot(cum_dose,c_current_plot,'k-','LineWidth',1.25)
xlim([0 plot_lim])
ylim([30 38])
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'XTick',x_dose_tick,...
        'Xticklabel',x_time_labels,...
        'YTick',[31 34 37],...
        'XAxisLocation','top')
    ylabel({'Current [nA]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    xlabel({'Irradiation Time [hr]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    
figure('Position',[100 100 500 350])
subplot('Position',[0.14 0.15 0.83 0.7])
plot(r_doses_therm,r_diff,'kx')
xlim([0 plot_lim_therm])
ylim([0.13 0.19])
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'XTick',x_dose_tick_therm)
    ylabel({'Thermal Diffusivity [cm^2/s]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    xlabel({'Average Dose [dpa]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    position=get(gca,'Position');
    ax1=gca;
    ax2=axes('Position',position,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'XTick',x_dose_tick_therm,...
        'Xticklabel',x_time_labels_therm,...
        'XAxisLocation','top',...
        'YTick',{},...
        'YTickLabel',{},...
        'Color','none');
    ylim([0.13 0.19])
    xlabel({'Irradiation Time [hr]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    linkaxes([ax1 ax2])
    
display('Average Current [nA]:')
display(mean(c_current_plot))

display('Total Fluence [ions/cm^2]:')
display(interpolate_general(r_time(end),c_time,cum_fluence))