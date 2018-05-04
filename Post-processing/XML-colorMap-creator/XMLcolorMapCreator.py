#!/usr/bin/python
import numpy as np
import pdb
import sys
import os
import math

"""
This script generates (or append text in existing) .xml files containing html code readable in the visualization software Paraview. The use of such xml files within Paraview allows to load user defined colorMaps.
The generation of those files requires three equations that return the RGB code at a given scale factor x (-1<x<1 or 0<x<1). Those equations are used as callables (symbol evaluators) thanks to the 'lambda' python operator. 
Three equations systems given in "Paul Tol. 2012. "Colour Schemes." SRON Technical Note, SRON/EPS/TN/09-002. https://personal.sron.nl/~pault/colourschemes.pdf" are included so far in the method 'predefinedColorMap(system)' and one can switch from one to another by changing the argument system from 1 to 3.
Other color maps can be added in the same way provinding that the equations systems is known !
"""


# Functions used in the script
#######################################################
def checkColorMap(File,ColorMar):
    if (os.path.exists(File)):
        print "Reading '"+str(File)+"' file to check if color map already exists..."
        dataFile=open(File,"r")
        Stop=False
        line=dataFile.readline().strip('\n')
        if line == '' :
            # Empty file
            process = 'write'
        else :
            # Read all the lines to check if the colorMap already exists
            while not Stop:
                line = dataFile.readline().strip('\n')
                if line[0:10] == '<ColorMap ':
                    if 'name="'+nameColorMap+'"' in line :
                        ## ColorMap name already exists
                        sys.exit("ColorMap name found in '"+str(File)+"' file. ColorMap should already exist.")
                elif line[0:13]== '</ColorMaps>':
                    ## End of the file
                    print "'"+str(File)+"' File read successfully. Color map does not exist (yet)"
                    process='append'
                    Stop=True
                else : continue
            dataFile.close()
        print "ColorMap name not found in '",File,"' file. Starting process."
    return process

def predefinedColorMap(system):
    """
    Method which returns color 3 equations (red,green,blue) given in reference :
    [1] Paul Tol. 2012. "Colour Schemes." SRON Technical Note, SRON/EPS/TN/09-002. https://personal.sron.nl/~pault/colourschemes.pdf
    The integer 'system' allows to choose among the three systems given in the paper.
    The objects returned by the function are callable.
    """
    if system==1:
        # system (1) p.7 in [1]
        red=lambda x:1.-0.392*(1.+math.erf((x-0.869)/0.255))
        green=lambda x:1.021 -0.456*(1.+math.erf((x-0.527)/0.376))
        blue=lambda x:1.-0.493*(1.+math.erf((x-0.272)/0.309))
    elif system==2:
        # system (2) p.9 in [1]
        red=lambda x:0.237-2.13*x+26.92*x**2-65.5*x**3+63.5*x**4-22.36*x**5
        green=lambda x:((0.572+1.524*x-1.811*x**2)/(1.-0.291*x+0.1574*x**2))**2
        blue=lambda x:1./(1.579-4.03*x+12.92*x**2-31.4*x**3+48.6*x**4-23.36*x**5)
    elif system==3:
        # system (3) p.11 in [1]
        red=lambda x:(0.472-0.567*x+4.05*x**2)/(1.+8.72*x-19.17*x**2+14.1*x**3)
        green=lambda x:0.108932-1.22635*x+27.284*x**2-98.577*x**3+163.3*x**4-131.395*x**5+40.634*x**6
        blue=lambda x:1./(1.97+3.54*x-68.5*x**2+243.*x**3-297*x**4+125*x**5)
    else :
        sys.exit("Wrong index '"+str(system)+"' given in predefinedColorMap.")
    return red,green,blue
#######################################################

#######################################################
#               BEGINNING OF THE SCRIPT               #
#######################################################

nameFile='ColorMap.xml'
nameColorMap='Tol3'
spaceType='RGB'

# Check if file and colorMap already exist
process=checkColorMap(nameFile,nameColorMap)

# The number of color samples in the color map
Samples=10
colorRange=np.linspace(0.,1.,Samples)

# Colors equations :
redEquation,greenEquation,blueEquation =predefinedColorMap(3)

if process=='write':
    # Create a file and fill it
    dataFile=open(nameFile,"w")
    dataFile.write('<ColorMaps>\n')
    dataFile.write('<ColorMap name="'+nameColorMap+'" space="'+spaceType+'">\n')
    for x in (colorRange):
        dataFile.write('<Point x="'+str(x)+'" o="1" r="'+str(redEquation(x))+'" g="'+str(greenEquation(x))+'" b="'+str(blueEquation(x))+'"/>\n')
    dataFile.write('</ColorMap>\n')
    dataFile.write('</ColorMaps>\n')
    dataFile.close()
else :
    # File must be copied to overwrite the last line '</ColorMaps>'
    dataFile=open(nameFile,"r")
    copyFile=open("outFile.xml","w")
    line=dataFile.readline().strip('\n')
    while '</ColorMaps>' not in line:
        copyFile.write(line+'\n')
        line=dataFile.readline().strip('\n')
    copyFile.write('<ColorMap name="'+nameColorMap+'" space="'+spaceType+'">\n')
    for x in (colorRange):
        copyFile.write('<Point x="'+str(x)+'" o="1" r="'+str(redEquation(x))+'" g="'+str(greenEquation(x))+'" b="'+str(blueEquation(x))+'"/>\n')
    copyFile.write('</ColorMap>\n')
    copyFile.write('</ColorMaps>\n')
    copyFile.close()
    # Move the copy file to dataFile
    os.system('mv outFile.xml '+str(nameFile))
    




