%script to plot the He into W data from 2018-02-01 as a function of dose
%received by the sample, calibrating to point faraday cup measurements.

%%%%%%%%%%%%%%%%%%%%
%Run from directory containing the following files, remember to do TGS raw data processing first since it will take the longest
%VACANCY.txt from the correct SRIM run
%He_in_W_data_w_therm_new.mat
%temp_log_3.7MeV_He_in_W_2018_02_01.txt
%%%%%%%%%%%%%%%%%%%%

cal_grat_units=4.5447e-6; %in m 

average_dose=1;
stop_on_fail=1;

start_stamp=10*3600+35*60; %when cup was open, in seconds excluding about 9 min of exposure before we knew if beam was overlapped
grat=4.5447; %in um
spot_size=pi*(0.5/2)^2; %in cm^2
charge_state=1;
elementary_charge=1.6021766e-19;

%code in manual current v time measurements made on farady cup
c_time=[10*3600+13*60 10*3600+32*60 12*3600+30*60 14*3600+30*60 16*3600+30*60 18*3600+30*60 20*3600+35*60];
c_current=[62.5 57.5 62.5 59 58.5 59 58.5]; %in nA
c_current_units=c_current*10^-9; %in A
c_current_units_mean=mean(c_current_units);

c_mean_flux=c_current_units_mean/(spot_size*charge_state*elementary_charge); %in num/cm^2*s

% n_density_W=6.306*10^22; %in 1/cm^3
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

dose_rate=c_mean_flux*dose_calibration;
dose_rate_therm=c_mean_flux*dose_calibration_therm;

%Read in SAW response data
load('He_in_W_data_w_therm_new.mat')

r_time=He_in_W_data_w_therm(:,1)';
r_freq=He_in_W_data_w_therm(:,2)';
r_speed=He_in_W_data_w_therm(:,3)';
r_diff=He_in_W_data_w_therm(:,4)';

r_diff=r_diff*10^4; %to put in cm^2/s

end_time=20*3600+35*60;
[~,stp_idx]=min(abs(r_time-end_time));
r_time=r_time(1:stp_idx);
r_freq=r_freq(1:stp_idx);
r_speed=r_speed(1:stp_idx);
r_diff=r_diff(1:stp_idx);

r_doses=zeros(1,length(r_speed));
r_doses_therm=zeros(1,length(r_diff));
for jj=1:length(r_time)
    r_doses(jj)=(r_time(jj)-start_stamp)*dose_rate;
    r_doses_therm(jj)=(r_time(jj)-start_stamp)*dose_rate_therm;
end

%Temp data block
[t_time,t_temp]=read_watlow_data('temp_log_3.7MeV_He_in_W_2018_02_01.txt');

t_doses=zeros(1,length(t_temp));
for jj=1:length(t_time)
    t_doses(jj)=(t_time(jj)-start_stamp)*dose_rate;
end
    
plot_lim=r_doses(end);
display(plot_lim)
plot_lim_therm=r_doses_therm(end);
x_dose_tick=0:0.005:0.03;
x_dose_tick_therm=0:0.004:0.016;
x_time_labels=cell(1,length(x_dose_tick));
x_time_labels_therm=cell(1,length(x_dose_tick_therm));
for jj=1:length(x_dose_tick)
    time_val=x_dose_tick(jj)/dose_rate;
    time_val=round(time_val/3600,1);
    x_time_labels{jj}=num2str(time_val);
end
for jj=1:length(x_dose_tick_therm)
    time_val=x_dose_tick_therm(jj)/dose_rate_therm;
    time_val=round(time_val/3600,1);
    x_time_labels_therm{jj}=num2str(time_val);
end

figure('Position',[100 100 500 500])
%make subplots from the bottom up
subplot('Position',[0.14 0.12 0.83 0.25])
plot(t_doses,t_temp,'k-','LineWidth',1.25)
xlim([0 plot_lim])
ylim([22 43])
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'YTick',[25 30 35 40],...
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
subplot('Position',[0.14 0.37 0.83 0.53])
plot(r_doses,r_speed,'kx')
xlim([0 plot_lim])
ylim([2658 2682])
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25,...
        'XTick',x_dose_tick,...
        'Xticklabel',x_time_labels,...
        'YTick',[2660 2665 2670 2675 2680],...
        'XAxisLocation','top')
    ylabel({'SAW Speed [m/s]'},...
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
ylim([0.35 0.9])
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
    ylim([0.35 0.9])
    xlabel({'Irradiation Time [hr]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    linkaxes([ax1 ax2])
    xlim([0 plot_lim_therm])
    
    %%%%%%%%%%%%%%%
    %total fluence calc
    %%%%%%%%%%%%%%%
    total_fluence=c_mean_flux*(r_time(end)-start_stamp); %in num/cm^2
    display(total_fluence)
    %%%%%%%%%%%%%%%