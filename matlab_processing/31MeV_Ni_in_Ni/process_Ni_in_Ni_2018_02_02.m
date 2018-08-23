%Process 31 MeV Ni into Ni data from 2018-02-02 to get both speed and
%thermal data

%%%%%%%%%%%%%%%%%%%%%%%%
%Either run from directory containing raw TGS data for this exposure, or change directories here
dir=cd();
%%%%%%%%%%%%%%%%%%%%%%%%

grat=4.5447;

pos_base_run01='Ni_beamline_2018_02_02-31MeV_Ni_in_Ni-04.53um-run01-POS-';
neg_base_run01='Ni_beamline_2018_02_02-31MeV_Ni_in_Ni-04.53um-run01-NEG-';

pos_base_run02='Ni_beamline_2018_02_02-31MeV_Ni_in_Ni-04.53um-run02-POS-';
neg_base_run02='Ni_beamline_2018_02_02-31MeV_Ni_in_Ni-04.53um-run02-NEG-';

batches_run01=225;
batches_run02=304;
num_batches=batches_run01+batches_run02;

freq=zeros(1,num_batches);
speed=zeros(1,num_batches);
timestamps=zeros(1,num_batches);
diff=zeros(1,num_batches);
diff_err=zeros(2,num_batches);

for jj=1:batches_run01
    display(num_batches-jj)
    pos_str=strcat(pos_base_run01,num2str(jj),'.txt');
    neg_str=strcat(neg_base_run01,num2str(jj),'.txt');
    [freq(jj),~,speed(jj),diff(jj),diff_err(jj),~]=TGS_phase_analysis(pos_str,neg_str,grat,2);
    timestamps(jj)=find_meas_time(pos_str);
end

for kk=1:batches_run02
    display(num_batches-(kk+batches_run01))
    pos_str=strcat(pos_base_run02,num2str(kk),'.txt');
    neg_str=strcat(neg_base_run02,num2str(kk),'.txt');
    [freq(kk+batches_run01),~,speed(kk+batches_run01),diff(kk+batches_run01),diff_err(:,kk+batches_run01),~]=TGS_phase_analysis(pos_str,neg_str,grat,2);
    timestamps(kk+batches_run01)=find_meas_time(pos_str);
end

Ni_in_Ni_data_w_therm_new=[timestamps' freq' speed' diff' diff_err(1,:)'];
save('Ni_in_Ni_data_w_therm_new.mat',Ni_in_Ni_data_w_therm);

figure()
plot(timestamps/60,speed,'kx')
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
    xlabel({'Time [min]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
figure()
plot(timestamps/60,diff*10^4,'rx')
set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25)
    ylabel({'Thermal Diffusivity [cm^2/s]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')
    xlabel({'Time [min]'},...
        'FontUnits','points',...
        'FontSize',20,...
        'FontName','Helvetica')