function [angles_new,speeds_new]=phase_shift(angles,speeds,period,phase_shift)

angles=angles+phase_shift;
for ii=1:length(angles)
    if angles(ii)>=period
        angles(ii)=angles(ii)-period;
    end
end

[angles_new,index_order]=sort(angles);

speeds_new=zeros(1,length(speeds));

for jj=1:length(speeds)
    speeds_new(jj)=speeds(index_order(jj));
end

end