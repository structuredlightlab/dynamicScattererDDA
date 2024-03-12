function [iterations,optm_progress,optm_phases] = readOptmData(file_name, ...
    data_range)
%objective function values (read the header of file if not sure what the 
% objective function is)
filePath_objFun = strcat(file_name, '__objectiveFun');
data_objFun = readmatrix(filePath_objFun);
if ~isempty(data_range)
    data_objFun = data_objFun(data_range,:);
end

optm_progress = data_objFun(:,2:4);
iterations = data_objFun(:,1);

%optimisation variable values (usually this is phase)
filePath_optmVar = strcat(file_name, '__optmVar');
data_optmVar = readmatrix(filePath_optmVar);
data_optmVar = data_optmVar(:,2:end);
if ~isempty(data_range)
    data_optmVar = data_optmVar(data_range,:);
end
optm_phases = data_optmVar;
end