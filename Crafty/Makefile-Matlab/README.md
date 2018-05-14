# Makefile-Matlab

A simple example makefile for building MEX files in MATLAB. The makefile is directly copied from https://github.com/kyamagu/matlab-serialization with the exception of the example usage in the header, which is adjusted to the Linux environment.



## Usage

Put this makefile into the same directory where your **.cc** files are.

Example: `make MATLABDIR=/usr/local/MATLAB/R2015b/`

To obtain the MATLAB root directory, execute

````bash
matlab -nodesktop -nosplash -r "a=matlabroot; fileID = fopen('MATLABDIR.txt','w'); fprintf(fileID, '%s', a); fclose(fileID); quit"
````

