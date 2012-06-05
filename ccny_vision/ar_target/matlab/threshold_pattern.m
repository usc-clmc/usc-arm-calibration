% function threshold_pattern(fname)

clear all;
close all;

for n=1:32

    fname = sprintf('../data/m%i.pat', n);
    disp(fname)
        
    pattern = load(fname);
    threshold = 120;
    
    pattern(find(pattern < threshold)) = 0;
    pattern(find(pattern > threshold)) = 255;

    fid = fopen(sprintf('%s_new', fname), 'wt');
    rows = length(pattern(:,1));
    cols = length(pattern(1,:));

    for i = 1:rows
       for j = 1:cols
           fprintf(fid,'%g ',pattern(i,j));
       end
       fprintf(fid,'\n');
       if(mod(i, 48) == 0 && i>0)
            fprintf(fid,'\n');
       end
    end
    fclose(fid);

    %new_pattern = load(sprintf('%s_new', fname));
    %size(new_pattern)
    
end

