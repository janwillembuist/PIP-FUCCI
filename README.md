# PIP-FUCCI Readme
PIP-FUCCI tool in MATLAB. A tool to analyze fluorescent cell data from [TrackMate][3] and classify the cell stages based on that data. Development commissioned by the [NKI][2].

Author: [@janwillembuist][4]

Date: 13-12-2020

In this readme the following topics are described:
* Installation
* Usage
* Algorithms

## Installation
The PIP-FUCCI tool can be installed by downloading the most recent installer from [github][1] and opening it with your MATLAB client. After installing it will be accessible from the **apps** tab inside MATLAB. With a simple click the PIP-FUCCI tool should appear on your screen.

## Usage
After installation the PIP-FUCCI tool can be launched from the **apps** tab inside MATLAB. You should now see the app window appear like this:

image here

In the menu bar, data can be loaded into the app. Loading raw data, or classified data (saved from a previous session) starts up most of the app's features. When loading raw data, the app will automatically classify the cell phases with the **four-phase classification algorithm**. This algorithm is described in the algorithms section of this readme. The options defined in the **automatic classification settings** box in the app influence the behaviour of the algorithm. The **Image files** button can load the corresponding tiff file from TrackMate to visually inspect the cell phase classification. When you click on this button the app will ask you to confirm a few settings. Here you can specify the image size, if cell locations in your data file are not defined in pixels, the brightness, and the clipping around a cell.

### Accepted input data
* Raw data (.xlsx, .csv)
* Classified data (.xlsx) (savefile of the PIP-FUCCI tool)
* Image data (.tiff, .tif)

### Track and cell selection
Once data is loaded, you can pick a track number in the **select track number** popup-menu. Selecting a track will update the relative intensity plots of that specific track. If there is mitosis happening in that specific track, you can pick the different cells in the track with the **select cell number** box. Cell number one corresponds to the mother cell.

### Manual classification update
If you spot some errors in the automatic classification, changes to the cell stage classification can be made in this box. Specify the start and end frame of which you would like to change the classification, pick the phase you would like to change it to, and click update. The classification should update immediately.

### Displaying third channel image and adding comments
When tiff data is loaded in the app, you can visually inspect the third channel image of the cell. Fill in a frame number you would like to see of the selected track and selected cell and click **update**. From here you can click forward and backward to move through the frame numbers. By adding a comment in the comment box and clicking **add**, you will add a comment in the output file for this specific **track**, **cell**, and **frame**.

## Algorithms
Based on the fluorescent cell data from TrackMate, the PIP-FUCCI tool classifies every timestep on the track with a cell stage. When you load data in the PIP-FUCCI tool, the four-phase classification algorithm is applied on each track in the file. If you are viewing a specific track, you can apply the five-phase classification algorithm to the track by clicking **Divide Mitosis**.

### Four-phase classification
The four-phase classification classifies the cell cyclus into four different classes:
1. M (Mitosis)
2. G1 (Growth 1)
3. S (Synthesis)
4. G2 (Growth 2)

### Five-phase classification
The five-phase classification classifies five different classes:
1. M1 (Prophase-Metaphase)
2. M2 (Anaphase-Telophase)
2. G1 (Growth 1)
3. S (Synthesis)
4. G2 (Growth 2)

[1]: https://github.com/janwillembuist/PIP-FUCCI/tree/main/dist
[2]: https://www.nki.nl/
[3]: https://imagej.net/TrackMate
[4]: https://github.com/janwillembuist
