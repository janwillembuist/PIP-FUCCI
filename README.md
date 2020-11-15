# PIP-FUCCI
PIP-FUCCI tool in MATLAB

## TODO
1. ~~Add SiR-DNA channel~~
2. ~~Set classifier to zero if it is the first or last cell stage~~
3. ~~Migrate the tool from GUIDE to new GUI options in MATLAB~~
3. ~~Improve the manual characterization options~~
3. Improve automatic detection
3. ~~Check the child cell thing~~
3. ~~Add image in GUI for visual inspection by loading the image data file~~
    ~~- Load the tiff file with menu button~~
    ~~- change frame for current track with button~~
    ~~- Save posX and posY into handles in data loading~~
    - ~~Combine it altogether
    - Check the longer than 95 arrays~~
4. ~~Enable csv loading as input~~, code speed gains, error debugging

## BUGS
- Specify UIAxes
- Undefined button actions
- Speed gains not used (pre-allocating, ~~str2double~~, ~~&&~~)
- Handles could be replaced by app properties for consistency with the MATLAB app development.
- ~~GUI is created with GUIDE, which will be unsupported in the future~~
