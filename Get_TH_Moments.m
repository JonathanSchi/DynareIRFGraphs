%% Extract Theoretical Moments
Directoryss={'C:\Users\Jonathan\Documents\Promotion\TARGET\Final stuff\1Baseline','C:\Users\Jonathan\Documents\Promotion\TARGET\Final stuff\2Deleveraging','C:\Users\Jonathan\Documents\Promotion\TARGET\Final stuff\3TARGET'};
TH_moments_both=zeros(10,3);
for i=1:3    
    cd(Directoryss{i})
    dynare Model 
    s2 = diag(oo_.gamma_y{1});
    sd = sqrt(s2);
    
    TH_moments_both(:,i)=[100*sd];
end
