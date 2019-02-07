% Basic idea: loop through TGS data file until you find the line that starts
% with 'time stamp (ms)'. Get time stamp from line, convert to sec and return.
function timestamp_in_seconds = get_timestamp_from_TGS_datafile(TGS_filename)
   fid = fopen(TGS_filename); 
   num_chars_to_match = length("time stamp (ms)");

   line = fgetl(fid);
   while (  ~ strncmp("time stamp (ms)", line, num_chars_to_match)  )
       % we haven't reached time stamp line yet, so keep going
       line = fgetl(fid);
   end
   fclose(fid);

   hour = str2double(line(17:18));
   minute = str2double(line(20:21));
   second = str2double(line(23:24));
   timestamp_in_seconds = hour*3600 + minute*60 + second;
end
