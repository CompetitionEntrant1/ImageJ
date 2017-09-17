// @File(label="Input directory", style="directory") input
// @File(label="Output directory", style="directory") output
//@String(label="File suffix", value=".JPG") suffix

//--------------------------------------------------------------
//DIRECTIONS:
//Write the path for your input and output directory: 
//Example: input= "C:\\Users\\...";

input=YOUR_INPUT_DIRECTORY;
output=YOUR_OUTPUT_DIRECTORY;
//--------------------------------------------------------------
suffix=".JPG";
processFolder(input);
function processFolder(input){
	list=getFileList(input);
	for(i=0;i<list.length;i++){
		//print("NUM FILES: "+list.length);
		if(File.isDirectory(input+list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			print("yes");
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file){
//-------------------------------------------------------------
//DIRECTIONS:
//Write the path for the image "1mM1.jpg" you downloaded from the same repository
//Example: open("C:\\Users\\...");

open(IMAGE_PATH);
//-------------------------------------------------------------
makeLine(632, 276, 2796, 272);
run("Set Scale...", "distance=2164.0037 known=12.70 pixel=1 unit=cm global");
open(input+file);
title=file;
getHistogram(values, counts, 256);
lowerBound=0;
upperBound=0;
 for (i=0; i<values.length; i++){
     	print(values[i], counts[i]);
}

 for (i=0; i<values.length; i++){
	if(counts[i]>=50){
     		//print(values[i], counts[i]);
		lowerBound=values[i];
		print(lowerBound);
		i=300;
	}
}
for(i=values.length-1;i>-1;i--){
	if(counts[i]>=1){
		//print(values[i], counts[i]);
		upperBound=values[i];
		print(upperBound);
		i=-10;
	}
}

setForegroundColor(175, 180, 0);

call("Versatile_Wand_Tool.doWand", 294, 71, 50.0, 94.0, 0, "non-contiguous eyedropper");



run("Clear Outside");
run("Select None");

run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
run("Split Channels");

if (roiManager("count") > 0){
	selectWindow("ROI Manager");
	run("Select All");
	roiManager("Delete");
	selectWindow("ROI Manager");
	run("Close");
}

function process(colorWindowName) {
	selectWindow(colorWindowName);
	x = 0;
	y = 0;
	numRow = 4;
	numCol = 4;
	width =getWidth()/numCol;
	height = getHeight()/numRow;
	spacing = 0;
	for(i = 0; i < numRow; i++)
	{
		for(j = 0; j < numCol; j++)
		{
			xOffset = j * (width + spacing);
			print(xOffset);
			yOffset = i * (height + spacing);
			print(yOffset);
			makeRectangle(x + xOffset, y + yOffset, width, height);
			roiManager("Add");
			if (roiManager("count") > 100)
				{
				print("Maximum reached: 100 entries have been created.");
				exit;
				}
		}		
	}
	//This was adapted from a post by RDD to an ImageJ forum here: http://imagej.1557.x6.nabble.com/How-to-create-a-regular-grid-of-rectangular-ROI-s-td3685056.html
	run("Select None");
	run("8-bit");
	setThreshold(lowerBound, upperBound);	
	run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
	roiManager("Measure");
	run("Select All");
	roiManager("Delete");
	selectWindow("ROI Manager");
	run("Close");
	selectWindow("Log");
}

function process2(colorWindowName) {
	selectWindow(colorWindowName);
	x = 0;
	y = 0;
	numRow = 4;
	numCol = 4;
	width =getWidth()/numCol;
	height = getHeight()/numRow;
	spacing = 0;
	for(i = 0; i < numRow; i++)
	{
		for(j = 0; j < numCol; j++)
		{
			xOffset = j * (width + spacing);
			print(xOffset);
			yOffset = i * (height + spacing);
			print(yOffset);
			makeRectangle(x + xOffset, y + yOffset, width, height);
			roiManager("Add");
			if (roiManager("count") > 100)
				{
				print("Maximum reached: 100 entries have been created.");
				exit;
				}
		}		
	}
	//This was adapted from a post by RDD to an ImageJ forum here: http://imagej.1557.x6.nabble.com/How-to-create-a-regular-grid-of-rectangular-ROI-s-td3685056.html
	run("Select None");
	run("8-bit");
	setThreshold(1, upperBound);
	run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
	roiManager("Measure");
	selectWindow("Log");
	run("Close");
}

red1=title+" (red)";
green1=title+" (green)";
blue1=title+" (blue)";

process(red1);
process(green1);
process2(blue1);

selectWindow("Results");
word=split(file,".");

csvFile="Results"+word[0]+".csv";
saveAs("Results", output+csvFile);
selectWindow("Results");
run("Clear Results");
run("Close");


}
