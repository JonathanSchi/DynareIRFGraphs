# DynareIRFGraphs
Package that creates nice looking IRFs (also as eps and pdf) for dynare. 

This package is intended to create nice looking Dynare IRFs that do not require further manipulation by hand. 
To create the output it relies on the OccBin package by Luca Guerrieriand Matteo Iacoviello. All files apart from GraphCompareJS, clean_up, and  cg2printtemplate belong to the above mentioned authors. Note that these files might be adjusted to account for changes in Matlab that made their original files fail to execute. 
This package is written and optimized for Matlab. There is no guarantee that it will work with Octave. 

To use this package refer to the file: HowToUseGraphCompareJS which provides an example with comments. Store all the files in this repository in a folder and add it to your Matlab path. Note that this package is optimized for Live-Scripts. 
Apart from that refer to the following information:

File to run dynare with the occbin toolbox. Call this file
in a Live-script containing the following input:
1.  "Directories". A nx1 char array containing the folders that store mod files
2.  "VAR_Shortname". A 1xn char array containing all variables to be shown
3.  "VAR_Longname". A 1xn char array containing the names of the variables to
    be shown. If you don't want to declare the names just ignore this part. Note
    that the order has to be the same as in "VAR_Shortname". ((Furthermore,
    if you defined 'long_name' in the modfile and you wish to use exactly
    those expressions ignore this entry as well. )) not yet implemented!
4.  "Annualized". A nx1 vector with binary input. Use 1 if a variable
    should be annualized. Note that the order has to be the same as in
    "VAR_Shortname".
5.  "Model_Names". A mx4 char array containing the name (as saved in your folder) 
    of the models to be used. In each row start with the basic model, 
    then (if needed) the model with one constraint, 
    then the model with another constraint and finally a
    model with both constraints. If you use just one or no constraint at all
    add empty '' to match the size. Additional rows for additional models.
6.  "constraints". A mx2 char array containing the definition of
    constraints. Procede as with 5.
7.  "constraints_relax". A mx2 char array containing the definition of
    the relaxpoint of your constraints. Procede as with 5.
8.  "irfshocks". A nx1 char array containing the name of the shock as
    defined in your modfile.
9.  "shocksequences". A nxm Matrix containing the timing and intensity of
    the shock. Each row corresponds to one model. Note that all rows have to
    have equal length. The length furthermore defines the length of the IRFs.
10. "includelinearsolution". A 1xm vector. for each model
    define whether the linear solution should be included (set value to 1) 
    or only the linear solution should be shown (set value to 2).
11. "Legend_Names". A 1xm char array containing the description of the models to
    be shown in the legend
12. "Linestyle"={'bw' or 'n'} with bw for black and white printer friendy
    and n for normal
13. "DirectorySAVE"={'MyLatexDirectory'} defines a folder where the IRFs
    are stored in .eps and with latex friendly names. 
    This command deletes the output in the live script, but saves it to the defined folder. 
    The Live-Script will report the respective folder. Not defining "DirectorySAVE" shows
    the IRFs in the live script. 
14. print_NAME='NameofFile' that is to be stored in your folder. 
15. You can skip colors and linestyle (in case you want specific cases to
    have specific colors or linestyles by adding: colorskip=n and
    linestyleskip=n where n is an integer bigger than 0. If you do not want
    skip the first, but the second color or linestyle, then add a
    colorskipnum=2 and linestyleskipnum=2. These options are optional.
16. A command line: "run GraphcompareJS.m"
