function [time_record,current_out]=read_current_data_2018_02_02(current_file,dt,plotty)
%read in current data as recorded from BPM on Sandia beamline experiment.
%dt is the record time over which charge is collected at each step in sec

%%%%%%%%
%%%%%%%%
%Note. There electrons spraying from the cup just upstream of
%the BPM. So we just need to equate the current right before and right
%after the cup open to make record continuous
%%%%%%%%
%%%%%%%%

cup_in_time_absolute=10*3600+50*60;

if nargin<3
    plotty=0;
end

current_record=textscan(fopen(current_file),'%s %s %s %s');

make_len=length(current_record{1});
rec_time_hr=zeros(1,make_len);
rec_time_min=zeros(1,make_len);
rec_time_sec=zeros(1,make_len);
rec_charge=zeros(1,make_len);

ind_to_remove=[];

for jj=1:make_len
    time_str=current_record{2}{jj};
    
    if strcmp('',time_str)
        ind_to_remove=[ind_to_remove jj];
    else
        
        if (strcmp(current_record{3}{jj},'PM') && ~strcmp(time_str(1:2),'12')) || (strcmp(current_record{3}{jj},'AM') && strcmp(time_str(1:2),'12'))
            add_hr=12;
        else
            add_hr=0;
        end
        
        if length(time_str)==8
            rec_time_hr(jj)=str2double(time_str(1:2))+add_hr;
            rec_time_min(jj)=str2double(time_str(4:5));
            rec_time_sec(jj)=str2double(time_str(7:8));
        else
            rec_time_hr(jj)=str2double(time_str(1))+add_hr;
            rec_time_min(jj)=str2double(time_str(3:4));
            rec_time_sec(jj)=str2double(time_str(6:7));
        end
        
        rec_charge(jj)=str2double(current_record{4}{jj});
    end
end

absolute_time=rec_time_hr*3600+rec_time_min*60+rec_time_sec;

for ii=1:length(ind_to_remove)
    idx=ind_to_remove(ii);
    if idx==make_len
        absolute_time=absolute_time(1:idx-1);
        rec_charge=rec_charge(1:idx-1);
    else
        absolute_time=[absolute_time(1:idx-1) absolute_time(idx+1:end)];
        rec_charge=[rec_charge(1:idx-1) rec_charge(idx+1:end)];
    end
end


[~,cup_in_ind]=min(abs(absolute_time-cup_in_time_absolute));

ave_len=5;
pre_cup_current=rec_charge(cup_in_ind-(5+ave_len):cup_in_ind-5);
post_cup_current=rec_charge(cup_in_ind+5:cup_in_ind+(5+ave_len));
cup_factor=mean(pre_cup_current)/mean(post_cup_current);

charge_calibrated=[rec_charge(1:cup_in_ind) rec_charge(cup_in_ind+1:end)*cup_factor];

current=charge_calibrated/dt;

current=current*10^9; %in nA

%%%%Calibration block to cup measured currents
cal_time_hr=[9 10 10 19];
cal_time_min=[49 10 48 36];
cal_current=[30.5 31.5 31.7 45]; %in nA
cal_time_absolute=cal_time_hr*3600+cal_time_min*60;
cal_factor_vec=zeros(1,length(cal_current));

for kk=1:length(cal_time_absolute)
    [~,spot_idx]=min(abs(absolute_time-cal_time_absolute(kk)));
    spot_current=current(spot_idx);
    cal_factor_vec(kk)=(cal_current(kk)/spot_current);
end

current=current*mean(cal_factor_vec);

time_record=absolute_time(2:end-1);
current_out=abs(current(2:end-1));

if plotty
    figure()
    plot(time_record/60,current_out,'k-','LineWidth',1.25)
    hold on
    plot([1110 1110],[26 44],'r--')
    hold on
    set(gca,...
        'FontUnits','points',...
        'FontWeight','normal',...
        'FontSize',16,...
        'FontName','Helvetica',...
        'LineWidth',1.25)
    ylabel({'Current [nA]'},...
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