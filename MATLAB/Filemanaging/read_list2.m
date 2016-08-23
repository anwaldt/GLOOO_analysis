function v = read_list2(filename, c)

% this function returns the content of the column <c> in tetxt-file <filename>

fopen('filename');
content = char(textread(filename,'%s'));
fclose('all');

if size(content,1) < c
    v = -1;
    return
end

v = content(c,:);

ind=find(v == ' '); 
if ~isempty(ind)
    v = v(1:ind(1)-1);
end
