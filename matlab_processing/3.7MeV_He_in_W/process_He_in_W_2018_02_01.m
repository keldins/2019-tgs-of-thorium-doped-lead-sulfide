%Process 3.7 MeV He into W data from 2018-02-01

%%%%%%%%%%%%%%%%%%%
%Either run from directory containing all raw TGS data files for this exposure, or change directory here
dir=cd();
%%%%%%%%%%%%%%%%%%%

grat=4.5447; %in um

pos_base_run02='W_beamline_2018_02_01-3.7MeV_He_in_W-04.53um-run02-POS-';
neg_base_run02='W_beamline_2018_02_01-3.7MeV_He_in_W-04.53um-run02-NEG-';

pos_base_run03='W_beamline_2018_02_01-3.7MeV_He_in_W-04.53um-run03-POS-';
neg_base_run03='W_beamline_2018_02_01-3.7MeV_He_in_W-04.53um-run03-NEG-';

batches_run02=550;
batches_run03=393;
num_batches=batches_run02+batches_run03;

freq=zeros(1,num_batches);
speed=zeros(1,num_batches);
timestamps=zeros(1,num_batches);
diff=zeros(1,num_batches);
diff_err=zeros(2,num_batches);

for jj=1:batches_run02
    display(num_batches-jj)
    pos_str=strcat(pos_base_run02,num2str(jj),'.txt');
    neg_str=strcat(neg_base_run02,num2str(jj),'.txt');
    timestamps(jj)=find_meas_time(pos_str);
    [freq(jj),~,speed(jj),diff(jj),diff_err(:,jj),~]=TGS_phase_analysis(pos_str,neg_str,grat,2);
end

for kk=1:batches_run03
    display(num_batches-(kk+batches_run02))
    pos_str=strcat(pos_base_run03,num2str(kk),'.txt');
    neg_str=strcat(neg_base_run03,num2str(kk),'.txt');
    timestamps(kk+batches_run02)=find_meas_time(pos_str);
    [freq(kk+batches_run02),~,speed(kk+batches_run02),diff(kk+batches_run02),diff_err(:,kk+batches_run02),~]=TGS_phase_analysis(pos_str,neg_str,grat,2);
end

He_in_W_data_w_therm_new=[timestamps' freq' speed' diff' diff_err(1,:)'];
save('He_in_W_data_w_therm_new.mat',He_in_W_data_w_therm);

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
    
He_in_W_data_w_therm=[timestamps' freq' speed' diff' diff_err(1,:)'];