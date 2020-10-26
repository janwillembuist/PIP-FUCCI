a = [1, 1, 1, 2, 2, 4, 4]
b = delete_begin_end(b)

function [classified] = delete_begin_end(classified)
% Function that deletes the begin and end of a certain classification. It
% puts a zero for deleted classification. (JWB)
first = classified(1);
last = classified(end);

% Loop over entries from second item 
for i=1:1:length(classified)
    if classified(i) ~= first
        % A classification boundary is reached
        break
    end
    classified(i) = 0;
end

% Loop backwards over entries from second to last item
for i=length(classified):-1:1
    if classified(i) ~= last
        % A classification boundary is reached
        break
    end
    classified(i) = 0;
end
end