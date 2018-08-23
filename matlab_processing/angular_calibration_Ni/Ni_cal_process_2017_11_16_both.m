%process calibration Ni data from 2017-11-16 at Sandia

%%%%%%%%%%%%%%%%%%%
%Either run from directory containing raw TGS data for orientation measurements, or change to correct directory here
dir=cd();
%%%%%%%%%%%%%%%%%%%

str_base_52='Ni_calibration_001-2017-11-16-05.20um-';
str_mid_52='_deg-';

angles_52=0:5:45;

SAW_response_52=zeros(1,length(angles_52));

for jj=1:length(angles_52)
    if angles_52(jj)<10
        angle_str=strcat('0',num2str(angles_52(jj)));
    else
        angle_str=num2str(angles_52(jj));
    end
    pos_str=strcat(str_base_52,angle_str,str_mid_52,'POS-1.txt');
    neg_str=strcat(str_base_52,angle_str,str_mid_52,'NEG-1.txt');
    
    [SAW_response_52(jj),~,~,~,~,~]=TGS_phase_analysis(pos_str,neg_str,5.2,0);
end

[angles_new_52,SAW_new_52]=phase_shift(angles_52(1:end-1),SAW_response_52(1:end-1),90,83);
PSAW_bool_52=zeros(1,length(SAW_new_52));
PSAW_bool_52(end-3:end-2)=1;

str_base_34='Ni_calibration_001-2017-11-16-03.40um-';
str_mid_34='_deg-';

angles_34=0:5:45;

SAW_response_34=zeros(1,length(angles_34));

for jj=1:length(angles_34)
    if angles_34(jj)<10
        angle_str=strcat('0',num2str(angles_34(jj)));
    else
        angle_str=num2str(angles_34(jj));
    end
    pos_str=strcat(str_base_34,angle_str,str_mid_34,'POS-1.txt');
    neg_str=strcat(str_base_34,angle_str,str_mid_34,'NEG-1.txt');
    
    [SAW_response_34(jj),~,~,~,~,~]=TGS_phase_analysis(pos_str,neg_str,3.4,0);
end

[angles_new_34,SAW_new_34]=phase_shift(angles_34(1:end-1),SAW_response_34(1:end-1),90,83);
PSAW_bool_34=zeros(1,length(SAW_new_34));
PSAW_bool_34(end-3:end-2)=1;

%%%%%%%%%%%%%%%%%%%
%Change to directory containing the Ni SAW speed versus angle data Ni_SAW_speeds.mat
cd('directory_name_here')
load('Ni_SAW_speeds.mat')
%%%%%%%%%%%%%%%%%%%

Cal_grat_52=zeros(1,length(SAW_new_52));

for kk=1:length(SAW_new_52)
    if PSAW_bool_52(kk) || angles_new_52(kk)==45
        [~,ind]=min(abs(Ni_PSAW_speed(:,1)-angles_new_52(kk)));
        Cal_grat_52(kk)=Ni_PSAW_speed(ind,2)/SAW_new_52(kk);
    elseif angles_new_52(kk)<45
        [~,ind]=min(abs(Ni_SAW_speed_1(:,1)-angles_new_52(kk)));
        Cal_grat_52(kk)=Ni_SAW_speed_1(ind,2)/SAW_new_52(kk);
    elseif angles_new_52(kk)>45
        [~,ind]=min(abs(Ni_SAW_speed_2(:,1)-angles_new_52(kk)));
        Cal_grat_52(kk)=Ni_SAW_speed_2(ind,2)/SAW_new_52(kk);
    end
end

Cal_grat_34=zeros(1,length(SAW_new_34));

for kk=1:length(SAW_new_34)
    if PSAW_bool_34(kk) || angles_new_34(kk)==45
        [~,ind]=min(abs(Ni_PSAW_speed(:,1)-angles_new_34(kk)));
        Cal_grat_34(kk)=Ni_PSAW_speed(ind,2)/SAW_new_34(kk);
    elseif angles_new_34(kk)<45
        [~,ind]=min(abs(Ni_SAW_speed_1(:,1)-angles_new_34(kk)));
        Cal_grat_34(kk)=Ni_SAW_speed_1(ind,2)/SAW_new_34(kk);
    elseif angles_new_34(kk)>45
        [~,ind]=min(abs(Ni_SAW_speed_2(:,1)-angles_new_34(kk)));
        Cal_grat_34(kk)=Ni_SAW_speed_2(ind,2)/SAW_new_34(kk);
    end
end

calibrated_grating_52=mean(Cal_grat_52);
grat_err_52=std(Cal_grat_52);
display(calibrated_grating_52*10^6)
display(grat_err_52*10^6)

calibrated_grating_34=mean(Cal_grat_34);
grat_err_34=std(Cal_grat_34);
display(calibrated_grating_34*10^6)
display(grat_err_34*10^6)

figure()
plot(Ni_SAW_speed_1(1:25,1),Ni_SAW_speed_1(1:25,2),'k--','LineWidth',1.25)
hold on
plot(Ni_SAW_speed_2(22:end,1),Ni_SAW_speed_2(22:end,2),'k--','LineWidth',1.25)
hold on
plot(Ni_PSAW_speed(26:66,1),Ni_PSAW_speed(26:66,2),'k--','LineWidth',1.25)
hold on
plot(angles_new_52,SAW_new_52*calibrated_grating_52,'rd','MarkerSize',6,'LineWidth',1.25)
hold on
plot(90-angles_new_34,SAW_new_34*calibrated_grating_34,'bo','MarkerSize',6,'LineWidth',1.25)
xlim([0 90])
ylim([2600 3200])
set(gca,...
    'FontUnits','points',...
    'FontWeight','normal',...
    'FontSize',16,...
    'FontName','Helvetica',...
    'LineWidth',1.25)
ylabel({'(P)SAW speed [m/s]'},...
    'FontUnits','points',...
    'FontSize',20,...
    'FontName','Helvetica')
xlabel({'Surface angle [degrees]'},...
    'FontUnits','points',...
    'FontSize',20,...
    'FontName','Helvetica')