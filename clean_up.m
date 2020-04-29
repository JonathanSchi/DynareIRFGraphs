%clear; close all;
%pause on
temp_list=dir('*.mod');
[num_mod,~]=size(temp_list);
FolderCurrent=pwd;
%clear functions



delete *_dynamic.m
delete *_steadystate2.m
delete *_set_auxiliary_variables.m
delete *_static.m
%delete *.eps
delete *.asv
delete *.jnl
delete *.tex
delete *.aux
delete *.dvi
delete *.log
%delete *.pdf
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
    status=0;
    loopnumber=0;
        while status==0
        status=rmdir(mod_name,'s');
        loopnumber=loopnumber+1;
        if loopnumber==50
            disp(['Unable to delete Folder ',mod_name,' in ',FolderCurrent,'!'])
            status=1;
        end
        end
    end
    eval(['model_name2=''+',mod_name,''';']);
    if exist(model_name2) == 7
    status=0;
    loopnumber=0;
        while status==0
        status=rmdir(model_name2,'s');
        loopnumber=loopnumber+1;
        if loopnumber==50
            disp(['Unable to delete Folder ',model_name2,' in ',FolderCurrent,'!'])
            status=1;
        end
        end
    end 
    
end

%clear;
