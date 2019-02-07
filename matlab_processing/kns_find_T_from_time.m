function T_for_return = kns_find_T_from_time(times, Ts, timestamp)
    index = find(timestamp >= times);
    index = index(end);
    T_for_return = Ts(index);
end
