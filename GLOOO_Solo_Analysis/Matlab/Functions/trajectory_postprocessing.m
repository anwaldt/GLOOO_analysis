function [] = trajectory_postprocessing( inpath, outpath, param)


X = importfile(inpath);

for bandCNT= 1:25
    
    X(:,bandCNT) = smooth(X(:,bandCNT), param.bark.smooth);
    
end
 
fid         = fopen(outpath,'w');
fprintf(fid, [repmat('%e ', 1, size(X, 1) ), ';\n'], X );
fclose(fid);

end
