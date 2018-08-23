%Processing Ni frequency data from temperature ramp measurement. Data is taken at 8 degrees off from <100>{001}

%%%%%%%%%%%%%%%%%%%%%%
%Either run from directory that contains the raw TGS data files for these tests, or change to the appropriate directory here
dir=cd();
%%%%%%%%%%%%%%%%%%%%%%

str_base='Ni_beamline_2018_01_28-temp_steps-04.76um-';
cal_grating=4.5339; %in um from W data at 17mm launch WD
cal_grating_units=cal_grating*10^(-6);
cal_grating_err=3.9428e-9; %in m

RT_freq=zeros(1,3);
RT_freq_err=zeros(1,3);

Temps=50:25:600;

T_freq=zeros(1,length(Temps));
T_freq_err=zeros(1,length(Temps));

for ii=1:length(RT_freq)
    pos_str=strcat(str_base,'23C_spot0',num2str(ii),'-POS-1.txt');
    neg_str=strcat(str_base,'23C_spot0',num2str(ii),'-NEG-1.txt');
    [RT_freq(ii),RT_freq_err(ii),~,~,~,~]=TGS_phase_analysis(pos_str,neg_str,cal_grating,0);
end

for jj=1:length(Temps)
    pos_str=strcat(str_base,num2str(Temps(jj)),'C_spot01-POS-1.txt');
    neg_str=strcat(str_base,num2str(Temps(jj)),'C_spot01-NEG-1.txt');
    [T_freq(jj),T_freq_err(jj),~,~,~,~]=TGS_phase_analysis(pos_str,neg_str,cal_grating,0);
end

RT_speed=RT_freq*cal_grating_units;
T_speed=T_freq*cal_grating_units;

all_speeds=[mean(RT_speed) T_speed];
all_Temps=[23 Temps];

%%%%%%%%%%%%%%%%%%%%%%%%
%Input directory name that contains the pre-calculated Ni SAW speeds versus temperature at the correct angle
cd('directory_name_here')
load('Ni_SAW_v_temp_8.0deg.mat')
%%%%%%%%%%%%%%%%%%%%%%%%

cd(dir)

figure()
plot(Ni_SAW_v_temp(:,1),Ni_SAW_v_temp(:,2),'k--','LineWidth',1.25);
hold on
plot(all_Temps,all_speeds,'ro','MarkerSize',8,'MarkerFaceColor','r');
xlim([0 650])
legend({'Elastic Theory','Data'});
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25)
    ylabel({'SAW Speed [m/s]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    xlabel(strcat('Temperature [',char(176),'C]'),...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')