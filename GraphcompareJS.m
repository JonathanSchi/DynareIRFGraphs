%Copyright: Jonathan Schiller, University of Bayreuth
%File to run dynare with the occbin toolbox. Call this file
%in a script containing the following input:
%1. "Directories". A nx1 char array containing the folders that store mod files
%2. "VAR_Shortname". A 1xn char array containing all variables to be shown
%3. "VAR_Longname". A 1xn char array containing the names of the variables to
%   be shown. If you don't want to declare the names just ignore this part. Note
%   that the order has to be the same as in "VAR_Shortname". ((Furthermore,
%   if you defined 'long_name' in the modfile and you wish to use exactly
%   those expressions ignore this entry as well. )) not yet implemented!
%4. "Annualized". A nx1 vector with binary input. Use 1 if a variable
%   should be annualized. Note that the order has to be the same as in
%   "VAR_Shortname".
%5. "Model_Names". A mx4 char array containing the name (as saved in your folder) 
%   of the models to be used. In each row start with the basic model, 
%   then (if needed) the model with one constraint, 
%   then the model with another constraint and finally a
%   model with both constraints. If you use just one or no constraint at all
%   add empty '' to match the size. Additional rows for additional models.
%6. "constraints". A mx2 char array containing the definition of
%   constraints. Procede as with 5.
%7. "constraints_relax". A mx2 char array containing the definition of
%   the relaxpoint of your constraints. Procede as with 5.
%8. "irfshocks". A nx1 char array containing the name of the shock as
%   defined in your modfile.
%9. "shocksequences". A nxm Matrix containing the timing and intensity of
%   the shock. Each row corresponds to one model. Note that all rows have to
%   have equal length. The length furthermore defines the length of the IRFs.
%10."includelinearsolution". A 1xm vector. for each model
%   define whether the linear solution should be included (set value to 1) 
%   or only the linear solution should be shown (set value to 2).
%11."Legend_Names". A 1xm char array containing the description of the models to
%   be shown in the legend
%12."Linestyle"={'bw' or 'n'} with bw for black and white printer friendy
%   and n for normal
%13."DirectorySAVE"={'MyLatexDirectory'} defines a folder where the IRFs
%   are stored in .eps and with latex friendly names (without blanks)
%14. print_NAME='NameofFile' that is stored in your folder. 
%15. You can skip colors and linestyle (in case you want specific cases to
%have specific colors or linestyles by adding: colorskip=n and
%linestyleskip=n where n is an integer bigger than 0. If you do not want
%skip the first, but the second color or linestyle, then add a
%colorskipnum=2 and linestyleskipnum=2. These options are optional and can
%be left out without problems.
%16.A command line: "run GraphcompareJS.m"
 
%
%% Don't change anything from here on
close all;
pause on;
currentFolder=pwd;
%transpose(shocksequences);
Num_VAR=length(VAR_Shortname);
Num_Columns=min(3,ceil((sqrt(Num_VAR))));
if Num_VAR==3
    Num_Columns=3;
end
Num_Rows=Num_Columns;
Num_Models=size(Model_Names,1);
nperiods = size(shocksequences,1);
Num_model={'1','2','3','4','5','6'};    

%% Run Dynare with or without OccBin for all models 
for ii=1:Num_Models
%change directory
cd(Directories{ii})
    if isempty(Model_Names{ii,2})
        disp NOOCCBIN
        includelinearsolution(1,ii)=0;
        [zdata_, zdatass_, oobase_, Mbase_ ] = ...
            solve_no_constraint(Model_Names{ii,1},...
            shocksequences(:,ii),irfshocks{ii},nperiods);
        for i=1:Mbase_.endo_nbr
              eval([deblank(Mbase_.endo_names{i,:}),'_linear',Num_model{ii},'=zdata_(:,i);']);
              eval([deblank(Mbase_.endo_names{i,:}),'_piecewise',Num_model{ii},'=zdata_(:,i);']);
              eval([deblank(Mbase_.endo_names{i,:}),'_ss',Num_model{ii},'=zdatass_(i);']);
        end
    elseif isempty(Model_Names{ii,3})
        disp OCCBINONECONSTRAINT
        [zdatalinear, zdatapiecewise, zdatass, oobase_, Mbase_ ] = ...
          solve_one_constraint(Model_Names{ii,1}, Model_Names{ii,2},...
          constraints{ii,1}, constraints_relax{ii,1},...
          shocksequences(:,ii),irfshocks{ii},nperiods);
          for i=1:Mbase_.endo_nbr
              eval([deblank(Mbase_.endo_names{i,:}),'_linear',Num_model{ii},'=zdatalinear(:,i);']);
              eval([deblank(Mbase_.endo_names{i,:}),'_piecewise',Num_model{ii},'=zdatapiecewise(:,i);']);
              eval([deblank(Mbase_.endo_names{i,:}),'_ss',Num_model{ii},'=zdatass(i);']);
          end
    else
        disp OCCBINTWOCONSTRAINT
        [zdatalinear, zdatapiecewise, zdatass, oobase_, Mbase_ ] = ...
              solve_two_constraints(Model_Names{ii,1},Model_Names{ii,2},Model_Names{ii,3},Model_Names{ii,4},...
              constraints{ii,1}, constraints{ii,2},constraints_relax{ii,1},... 
              constraints_relax{ii,2}, shocksequences(:,ii),irfshocks{ii},nperiods);
           for i=1:Mbase_.endo_nbr
              eval([deblank(Mbase_.endo_names{i,:}),'_linear',Num_model{ii},'=zdatalinear(:,i);']);
              eval([deblank(Mbase_.endo_names{i,:}),'_piecewise',Num_model{ii},'=zdatapiecewise(:,i);']);
              eval([deblank(Mbase_.endo_names{i,:}),'_ss',Num_model{ii},'=zdatass(i);']);
           end
    end    
    
%clean up the folder (clean_up is saved in the occbin folder, if you miss the file exclude this section!)
%clean_up
cd ..
end


%% Plot graphs

%Define t (Time=Start:Step:End)
t=1:1:nperiods;
%Color/LinestyleSkip
if exist('colorskip','var')==0
    colorskip=0;
end
if exist('colorskipnum','var')==0
    colorskipnum=0;
end
if exist('linestyleskipnum','var')==0
    linestyleskipnum=0;
end
if exist('linestyleskip','var')==0
    linestyleskip=0;
end
%Colordefintion
colorr={'[0 0 0]','[0.8  0.2  0.0]','[0.2  0.6  0.8]','[0.4  0.6  0.7]','[0.2  0.8  0.8]','[0.0  1.0  0.9]'}; %
%colorr={'[0 0 0]','[0.0  0.8  0.5]','[0.2  0.6  0.8]','[0.4  0.6  0.7]','[0.2  0.8  0.8]','[0.0  1.0  0.9]'};
if exist('Linestyle')==0
    Linestyle={'n'};
end

if Linestyle{1}=='bw'
    linestylee={'-',':','-.','-.*'};%
elseif Linestyle{1}=='n'
    linestylee={'-','-','-','-','-'};
else
    linestylee={'-','-','-','-','-'};
end
%Declare figure
fig=figure('name','Impulse responses','numbertitle','off');
% Enlarge figure to (nearly) full screen.
set(fig, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
if exist('DirectorySAVE')==0
    DirectorySAVE={''};
end
if isempty(DirectorySAVE{1})
else
set(fig,'Visible','on');
end
%genrate_IRF_names=zeros(Num_VAR,Num_Models);
%set(fig,'Color','none');
NamesforIRFs=cell(Num_Models,Num_VAR);
for nn=1:Num_Models
    for mm=1:Num_VAR
        NamesforIRFs{nn,mm}=[VAR_Shortname{mm},'_piecewise',Num_model{nn}];
    end
end
NamesforlinearIRFs=cell(Num_Models,Num_VAR);
for nn=1:Num_Models
    for mm=1:Num_VAR
        NamesforlinearIRFs{nn,mm}=[VAR_Shortname{mm},'_linear',Num_model{nn}];
    end
end
%create matrix containing the results
format long
IRFs=zeros([Num_Models*nperiods,Num_VAR]);
for nn=1:Num_Models
    for mm=1:Num_VAR
        IRFs(((nn-1)*nperiods+1):(nn*nperiods),mm)=evalin('base',NamesforIRFs{nn,mm});
    end
end
IRFslinear=zeros([Num_Models*nperiods,Num_VAR]);
for nn=1:Num_Models
    for mm=1:Num_VAR
        IRFslinear(((nn-1)*nperiods+1):(nn*nperiods),mm)=evalin('base',NamesforlinearIRFs{nn,mm});
    end
end


%plot
zeroline=zeros(1,nperiods);
for mm=1:Num_VAR
    %Define horizontal place in grid
    RRR=mod(mm,Num_Columns);
        if RRR==0
            RRR=Num_Columns;
        end
    %Plot figures for all models and all variables using subplot with a
    %predefined grid size to avoid shifts.
    for nn=1:Num_Models 
        linestyleskipp=0;
        colorskipp=0;
        if colorskipnum==nn
            colorskipp=colorskip;
        end
        if linestyleskipnum==nn
            linestyleskipp=linestyleskip;
        end
        subplot('Position',[0.1+(RRR-1)*(1/Num_Columns) 0.07+1/Num_Rows*(Num_Rows-ceil(mm/Num_Rows)) 1/Num_Columns-0.11 1/Num_Rows-0.1])
            if Annualized(1,mm)==1
                if includelinearsolution(nn)==1
                    plot(t,400*IRFs(((nn-1)*nperiods+1):(nn*nperiods),mm),linestylee{nn+linestyleskipp},'LineWidth',2,'Color',colorr{nn+colorskipp}) 
                    %grid on
                    hold on
                    plot(t,400*IRFslinear(((nn-1)*nperiods+1):(nn*nperiods),mm),'--','LineWidth',2,'Color',colorr{nn+colorskipp})
                    hold on
                elseif includelinearsolution(nn)==0
                    %grid on
                    plot(t,400*IRFs(((nn-1)*nperiods+1):(nn*nperiods),mm),linestylee{nn+linestyleskipp},'LineWidth',2,'Color',colorr{nn+colorskipp})
                else
                    %grid on
                    plot(t,400*IRFslinear(((nn-1)*nperiods+1):(nn*nperiods),mm),'--','LineWidth',2,'Color',colorr{nn+colorskipp})
                end
                yylabel=ylabel([{'Annualized $\%\Delta$ from ss'}], 'Interpreter','LaTex','FontSize',14);
                set(yylabel, 'Units', 'Normalized')
                poss=get(yylabel, 'Position');
                set(yylabel, 'Position', poss + [-poss(1,1)-0.15, 0, 0]);
            else
                if includelinearsolution(nn)==1
                    plot(t,100*IRFs(((nn-1)*nperiods+1):(nn*nperiods),mm),linestylee{nn+linestyleskipp},'LineWidth',2,'Color',colorr{nn+colorskipp})
                    %grid on
                    hold on
                    plot(t,100*IRFslinear(((nn-1)*nperiods+1):(nn*nperiods),mm),'--','LineWidth',2,'Color',colorr{nn+colorskipp})
                 elseif includelinearsolution(nn)==0
                    %grid on
                    plot(t,100*IRFs(((nn-1)*nperiods+1):(nn*nperiods),mm),linestylee{nn+linestyleskipp},'LineWidth',2,'Color',colorr{nn+colorskipp})
                else
                    %grid on
                    plot(t,100*IRFslinear(((nn-1)*nperiods+1):(nn*nperiods),mm),'--','LineWidth',2,'Color',colorr{nn+colorskipp})
                end
                yylabel=ylabel([{'$\%\Delta$ from ss'}], 'Interpreter','LaTex','FontSize',14);
                set(yylabel, 'Units', 'Normalized')
                poss=get(yylabel, 'Position');
                set(yylabel, 'Position', poss + [-poss(1,1)-0.15, 0, 0]);
            end
            hold on
            grid on
    end
    %include title
    if isempty(VAR_Longname{mm})
        title(VAR_Shortname{mm}, 'Interpreter','LaTex','FontSize',14)
    else
        title(VAR_Longname{mm}, 'Interpreter','LaTex','FontSize',14)
    end
    %include legend
    if mm==size(Num_VAR)
        countt=0;
        if isempty(Legend_Names)==1
            
        else    
            for ll=1:Num_Models
               if includelinearsolution(ll)==0
                   legend2{1,ll+countt}=Legend_Names{1,ll}; 
               elseif includelinearsolution(ll)==1
                   legend2{1,ll+countt}=Legend_Names{1,ll};
                   legend2{1,ll+countt+1}=[Legend_Names{1,ll},' (without constraint)'];
                   countt=1+countt;
               else 
                   legend2{1,ll+countt}=[Legend_Names{1,ll},' (without constraint)'];
               end
               %if isempty(Model_Names{ll,2})
               %    legend2{1,ll+countt}=[Legend_Names{1,ll},' (without constraint)'];
               %end
            end
        
            legend1=legend(legend2,'Orientation','horizontal', 'Interpreter','LaTex','FontSize',14);
            legend boxoff
            set(legend1,'Position',[0.5 0.003+1/Num_Rows*(Num_Rows-ceil(Num_VAR/Num_Rows)) 0.0 0.02],'AutoUpdate','off');
        end
    end
   
    axis([1 nperiods -inf inf])
    %include zeroline
    plot(t,zeroline,'r','LineWidth',0.5)
    hold off
end
%% This part saves all graphs directly to prescribed folder (latex friendly)
%Note that all graphs are named as defined in print_NAME
%without any blanks or unreadable signs. 
%Allow for saving and non saving depending on whether the folder is
%specified or not

if isempty(DirectorySAVE{1})
    disp('Figures not saved!')
else
    cd(DirectorySAVE{1})
    %Create nice looking output. cg2printtemplate is in the occbin folder
    load('cg2printtemplate.mat')
    setprinttemplate(gcf,template)
    %Make background transparent
    set(fig,'Color','none');
    %Create Name for file without blanks or non suited signs
    deletee={'Ä','Ö','Ü','ß','.',' ',',',':',';','/','\','(',')','[',']','{','}','Â§','%','&','$'};
    replacee=repmat({''},1,size(deletee,2));
    for i=1:size(deletee,2)
        print_NAME=strrep(print_NAME,deletee{i},replacee{i});
    end
    %save file as .eps and .pdf $$$$$$$$$$$$$$$$Future work might include other
    %formats
    print(print_NAME,'-dpdf')
    print(print_NAME,'-depsc')
    %Change current folder back to the original folder
    cd(Directories{1})
    cd ..
    disp(['Figures saved to: ' DirectorySAVE{1}])
    set(fig,'Color','white')
    set(fig,'Visible','off')
    
end

colorskip=0;
linestyleskip=0;
for ii=1:Num_Models
   cd(Directories{ii})
   clean_up
end
cd(currentFolder)
%%%%%%
%TODO:
%1 Allow for other files (pdf ..... ) 
%2 Try to display graphs even if graphs are printed (connected to the
%LiveScript... maybe just 'close all' instead of set(fig,'Visible','off')?)

