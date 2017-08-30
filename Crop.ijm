// @File(label="Input directory", style="directory") input
// @File(label="Output directory", style="directory") output
//@String(label="File suffix", value=".tif") suffix

//---------------------------------------------------------------------------
//DIRECTIONS:
//Write the path for your input and output directory: 
//Example: input="C:\\Users\\...";

input=YOUR_INPUT_DIRECTORY;
output=YOUR_OUTPUT_DIRECTORY;
//---------------------------------------------------------------------------


suffix=".tif";
processFolder(input);
function processFolder(input){
	list=getFileList(input);
	for(i=0;i<list.length;i++){
		//print("NUM FILES: "+list.length);
		if(File.isDirectory(input+list[i]))
			processFolder("" + input + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file){
	open(input+file);
	title=file;
	print("");
function process(colorWindowName,toEndPer) {
	selectWindow(colorWindowName);
	x = 37;
	y = 37;
	numRow = 4;
	numCol = 4;
	width =(getWidth-74)/numCol;
	height = (getHeight-74)/numRow;
	spacing = 0;
	for(i = 0; i < numRow; i++)
	{
		for(j = 0; j < numCol; j++)
		{
			xOffset = j * (width + spacing);
			//print(xOffset);
			yOffset = i * (height + spacing);
			//print(yOffset);
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
	tissueThreshPerc = 100-toEndPer; 
	nBins = 256; 
	getHistogram(values, count, nBins); 
	size = count.length; 
	cumSum= getWidth() * getHeight();
	tissueValue = cumSum * tissueThreshPerc / 100; 
	cumSumValues = count; 
	for (i = 1; i<count.length; i++) 
	{ 
		cumSumValues[i] += cumSumValues[i-1]; 
	} 
	for (i = 1; i<cumSumValues.length; i++) 
	{ 
		if (cumSumValues[i-1] <= tissueValue && tissueValue <= cumSumValues[i]) {
			lowerBound=i;
			lowBoundForAll=lowerBound;
			//print("Lower Bound: "+lowBoundForAll);
			upperBound=255;
			setThreshold(lowerBound, upperBound);
		} 
	}
	//This was adapted from a post by Roger Chang to an ImageJ forum here: http://imagej.1557.x6.nabble.com/Threshold-as-a-percentage-of-image-histogram-td3695671.html
	run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
	roiManager("Measure");
	run("Select All");
	selectWindow("Log");
}

function corners(ind, colorWindowName){
	selectWindow(colorWindowName);
	makeRectangle(0, 0, 28, getHeight());
	roiManager("Add");	
	run("Select None");	
	makeRectangle(getWidth()-28, 0, 28, getHeight());
	roiManager("Add");
	run("Select None");	
	makeRectangle(0, 0, getWidth(), 28);
	roiManager("Add");
	run("Select None");	
	makeRectangle(0, getHeight()-28, getWidth(), 28);
	roiManager("Add");
	run("Select None");	
	toEndPer=ind;
	tissueThreshPerc = 100-toEndPer; 
	nBins = 256; 
	getHistogram(values, count, nBins); 
	size = count.length; 
	cumSum= getWidth() * getHeight();
	tissueValue = cumSum * tissueThreshPerc / 100; 
	cumSumValues = count; 
	for (i = 1; i<count.length; i++) 
	{ 
	cumSumValues[i] += cumSumValues[i-1]; 
	} 
	for (i = 1; i<cumSumValues.length; i++) 
	{ 
	if (cumSumValues[i-1] <= tissueValue && tissueValue <= cumSumValues[i]) {
	lowerBound=i;
	upperBound=255;
	setThreshold(lowerBound, upperBound);
	} 
	//This was adapted from a post by Roger Chang to an ImageJ forum here: http://imagej.1557.x6.nabble.com/Threshold-as-a-percentage-of-image-histogram-td3695671.html
}
	run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
	roiManager("Measure");
	run("Select All");
	roiManager("Delete");
	selectWindow("ROI Manager");
	run("Close");
	selectWindow("Log");
}

function check(){
	run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
	per=0;
	for(i=1;i<100;i++){
		corners(i,title);
		endIndex=i*4;
		for(j=0;j<endIndex;j++){
			meanGray=getResult("Mean",j);
			//print(meanGray);
			if(meanGray>0){
				per=i-1;
				i=1000;
				return per;
			}
		}
	}
}
function processCrop(colorWindowName,toEndPer) {
//http://imagej.1557.x6.nabble.com/How-to-create-a-regular-grid-of-rectangular-ROI-s-td3685056.html
	selectWindow(colorWindowName);
	x = 0;
	y = 0;
	numRow = 4;
	numCol = 4;
	width =getWidth()/numCol;
	height = getHeight()/numRow;
	spacing = 0;
	for(i=0;i<getWidth;i++){
		makeRectangle(i,0,1,getHeight);
		roiManager("Add");	
	}
	for(s=0;s<getHeight;s++){
		makeRectangle(0,s,getWidth,1);
		roiManager("Add");
	}
	run("Select None");
	tissueThreshPerc = 100-toEndPer; 
	nBins = 256; 
	getHistogram(values, count, nBins); 
	size = count.length; 
	cumSum= getWidth() * getHeight();
	tissueValue = cumSum * tissueThreshPerc / 100; 
	cumSumValues = count; 
	for (i = 1; i<count.length; i++) 
	{ 
		cumSumValues[i] += cumSumValues[i-1]; 
	} 
	for (i = 1; i<cumSumValues.length; i++) 
	{ 
	if (cumSumValues[i-1] <= tissueValue && tissueValue <= cumSumValues[i]) {
		lowerBound=i;
		upperBound=255;
		//print("lower "+lowerBound);
		setThreshold(lowerBound, upperBound);
	} 
	}
	//This was adapted from a post by Roger Chang to an ImageJ forum here: http://imagej.1557.x6.nabble.com/Threshold-as-a-percentage-of-image-histogram-td3695671.html
	run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
	roiManager("Measure");
	run("Select All");
	selectWindow("Log");
}

function left(){
count4=0;
for(j=indCrop;j<indCrop+getWidth;j++){
	meanGray=getResult("Mean",j);
	if(j!=indCrop+getWidth-1){
		meanGray2=getResult("Mean",j+1);
	}
	else{
		meanGray2=getResult("Mean",j);
	}
	if(meanGray>0&&meanGray2>0){
		num=count4;
		//print("Left most: "+num);
		return num;
		j=ind+getWidth+1;
	}
	count4++;
}
}

function right(){
count=1;
for(k=indCrop+getWidth-1;k>=indCrop;k--){
	meanGray=getResult("Mean",k);
	if(k!=0){
		meanGray2=getResult("Mean",k-1);
	}
	else{
		meanGray2=getResult("Mean",k);
	}
	if(meanGray>0&&meanGray2>0){
		num=count;
		//print("Right most: "+num);
		return num;
		k=-1;
	}
	count++;
}
}

function top(){
count3=1;
for(m=indCrop+getWidth;m<indCrop+getWidth+getHeight;m++){
	meanGray=getResult("Mean",m);
	if(m!=indCrop+getWidth+getHeight-1){
		meanGray2=getResult("Mean",m+1);
	}
	else{
		meanGray2=getResult("Mean",m);
	}
	if(meanGray>0&&meanGray2>0){
		num=count3;
		//print("Top most: "+num);
		return num;
		m=indCrop+getWidth+getHeight+1;
	}
	count3++;
}
}

function bot(){
count2=1;
for(n=indCrop+getWidth+getHeight-1;n>=indCrop+getWidth;n--){
	meanGray=getResult("Mean",n);
	if(n!=0){
		meanGray2=getResult("Mean",n-1);
	}
	else{
		meanGray2=getResult("Mean",n);
	}
	if(meanGray>0&&meanGray2>0){
		num=count2;
		//print("Bottom most: "+num);
		return num;
		n=-1;
	}
	count2++;
}
}




//---------------------------------
		percentageCrop=check();
		indCrop=(percentageCrop+1)*4;
		processCrop(title,percentageCrop);
		l=left();
		r=right();
		t=top();
		b=bot();
		makeRectangle(l-37,t-37,getWidth-r+37-(l-37),getHeight-b+37-(t-37));
		run("Crop");
		saveAs("Tiff", output+file);
		selectWindow("Results");
		run("Clear Results");
		if (roiManager("count") > 0){
			selectWindow("ROI Manager");
			run("Select All");
			roiManager("Delete");
			selectWindow("ROI Manager");
			run("Close");
		}
//-----------------------------------

}
