%clear; close all;
%pause on
temp_list=dir('*.mod');
[num_mod,~]=size(temp_list);




delete *_dynamic.m
delete *_steadystate2.m
delete *_set_auxiliary_variables.m
delete *_static.m
delete *.eps
delete *.asv
delete *.jnl
delete *.tex
delete *.aux
delete *.dvi
delete *.log
delete *.pdf
delete *.ps
delete *.gz

for ii=1:num_mod
    mod_name = strsplit(temp_list(ii).name,'.');
    mod_name = char(mod_name(1));
    %delete(['*',mod_name,'.m']);
    delete(['*',mod_name,'.log']);
    delete(['*',mod_name,'_results.mat']);
    if exist([mod_name,'/Output'],'dir') == 7
    rmdir([mod_name,'/Output']);
    end
    if exist(mod_name,'dir') == 7
    rmdir(mod_name,'s');
    end
    eval(['model_name2="+',mod_name,'";']);
    if exist(model_name2) == 7
    %pause(15);    
    rmdir(model_name2,'s');
    end 
    
end

%clear;
