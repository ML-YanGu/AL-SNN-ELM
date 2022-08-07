function [x_max]=find_max_change(number_class)
    slope=zeros(1,6);
    for i=1:6
        slope(i)=number_class(i+1)-number_class(i);
    end
    slope_delta=max(number_class)-min(number_class);
    delta=slope_delta*0.1;
    slope_invert = slope(end:-1:1);
    index=0;
    for i=1:6
        if slope_invert(i) ~= 0
            if abs(slope_invert(i)) < delta
                index=i+1;
                break;
            end
            index=i;
            break;
        end
    end
    if index==0
        index=2;
    end
    x_max=8-index;

end