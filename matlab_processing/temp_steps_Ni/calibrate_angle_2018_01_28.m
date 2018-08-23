%%%%%%RESULT%%%%%%%
%sample is oriented at 8 +/- 1 degrees off <100>
%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
%Input directory containing both get_Ni_constants() and getSAW() with associated helper functions
cd('directory_name_here')
%%%%%%%%%%%%%%%%%%%%%%

[c1,c2,c4,rho]=get_Ni_constants(23); %extract density and constants from literature data
Ni=struct('fomular','Ni', 'C11',c1*10^9, 'C12',c2*10^9, 'C44',c4*10^9, 'density',rho*10^3, 'class','cubic');
C_mat=getCijkl(Ni);
den=getDensity(Ni);

% {001} surface speed calculation
angles=0:0.5:10;
Ni_SAW_speed_001=zeros(1,length(angles));
for ii=1:length(Ni_SAW_speed_001)
    display(ii)
    [Ni_SAW_speed_001(ii),~,~]=getSAW(C_mat,den,[0 0 0],angles(ii),4000);
end

%%%%%%%%%%%%%%%%%%%%%%
%Input directory name containing raw TGS data from temperature step measurements
cd('directory_name_here')
%%%%%%%%%%%%%%%%%%%%%%

str_base='Ni_beamline_2018_01_28-temp_steps-04.76um-23C_spot0';
cal_grating=4.5339; %in um from W data at 17mm launch WD
cal_grating_units=cal_grating*10^(-6);

ref_freq=zeros(1,3);
ref_freq_err=zeros(1,3);
for jj=1:length(ref_freq)
    pos_str=strcat(str_base,num2str(jj),'-POS-1.txt');
    neg_str=strcat(str_base,num2str(jj),'-NEG-1.txt');
    [ref_freq(jj),ref_freq_err(jj),~,~,~,~]=TGS_phase_analysis(pos_str,neg_str,cal_grating,0);
end

ref_speed=ref_freq*cal_grating_units;
ref_speed_err=ref_freq_err*cal_grating_units;

mean_speed=mean(ref_speed);

[~,min_ind]=min(abs(Ni_SAW_speed_001-mean_speed));

orient_angle=angles(min_ind);

figure()
plot(angles,Ni_SAW_speed_001,'k-','LineWidth',1.25)
hold on
plot(orient_angle,mean_speed,'rd','MarkerFaceColor','r')
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
        xlabel({'Surface Angle [degrees]'},...
            'FontUnits','points',...
            'FontSize',20,...
            'FontName','Helvetica')
