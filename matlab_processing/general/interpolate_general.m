function [y_value]=interpolate_general(x_data,x_ref,y_ref)
% Provide reference data in x_ref and y_ref, function will prouduce the
% value from linear interpolation at point x_data.

[~,temp_index]=min(abs(x_ref-x_data));

if temp_index==1
    temp_index_2=temp_index+1;
elseif temp_index==length(x_ref)
    temp_index_2=temp_index-1;
else
    neg_diff=abs(x_data-x_ref(temp_index-1));
    pos_diff=abs(x_data-x_ref(temp_index+1));
    
    if neg_diff<pos_diff
        temp_index_2=temp_index-1;
    else
        temp_index_2=temp_index+1;
    end
end

m=(y_ref(temp_index_2)-y_ref(temp_index))/(x_ref(temp_index_2)-x_ref(temp_index));
b=y_ref(temp_index)-m*x_ref(temp_index);

y_value=m*x_data+b;

end