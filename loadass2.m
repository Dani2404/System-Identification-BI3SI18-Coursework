% Program to load data files for the cybernetics system III  assignment.
% The data files are on suma3 so this program will only run if you are
% logged in there.

% c=computer;
xhurl='http://www.personal.rdg.ac.uk/~sis01xh/teaching/Sysid/datafiles/Datasets.htm';
dirxp=dir('xp*.dat');
if length(dirxp) <1
    web(xhurl)
else
    disp('--------------------')
    disp('to load more files run the Matlab command')
    disp('    web(xhurl)')
    [fname, pathname, filterindex] = uigetfile('*.dat');
    if length(fname)>0 & fname ~=0
        eval(['load ' pathname fname]);		% Load the file
        fname(find(fname == '.'):length(fname))=[];	% delete the .dat extension
        ry=eval(fname);		% put raw data into variable ry
        % y=decimate(ry(:,2),10);	% resample
        y=ry(:,2);

        plot(y)
        xlabel('sample number')
        ylabel('master position')
        title(fname)
        grid
        clear pathname filterindex dirxp
    end
end