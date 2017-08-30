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
	title=getTitle();
	print("");
function process(colorWindowName,toEndPer) {
//http://imagej.1557.x6.nabble.com/How-to-create-a-regular-grid-of-rectangular-ROI-s-td3685056.html
	selectWindow(colorWindowName);
	x = 37;
	y = 37;
	numRow = 4;
	numCol = 4;
	width =(getWidth-74)/numCol;
	height = (getHeight-74)/numRow;
	spacing = 0;
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
			return lowBoundForAll;
		} 
	}	
	//This was adapted from a post by Roger Chang to an ImageJ forum here: http://imagej.1557.x6.nabble.com/Threshold-as-a-percentage-of-image-histogram-td3695671.html
	run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
	run("Select All");
	selectWindow("Log");
}

function corners(ind, colorWindowName){
	selectWindow(colorWindowName);
	run("Set Measurements...", "area mean integrated limit redirect=None decimal=3");
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
	}
	//This was adapted from a post by Roger Chang to an ImageJ forum here: http://imagej.1557.x6.nabble.com/Threshold-as-a-percentage-of-image-histogram-td3695671.html
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
	per=1;
	for(i=1;i<100;i++){
		corners(i,title);
		endIndex=i*4;
		for(j=0;j<endIndex;j++){
			meanGray=getResult("Mean",j);
			if(meanGray>0&&meanGray<18){
				//print("Mean Gray: "+meanGray);
				per=i-1;
				i=1000;
				//print("PER "+per);
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

//----------------------------------------
		run("Next Slice [>]");
		percentage=check();
		lowBoundVal=process(title, percentage);
		//print("attempt 2: "+lowBoundVal);
		ind=(percentage+1)*4;
		word=split(title,".");
		selectWindow("Results");
//-----------------------------------
function processRun() {
//http://imagej.1557.x6.nabble.com/How-to-create-a-regular-grid-of-rectangular-ROI-s-td3685056.html
	indexGrid=1;
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
			run("Clear Results");
			open(input+file);
			xOffset = j * (width + spacing);
			yOffset = i * (height + spacing);
			makeRectangle(x + xOffset, y + yOffset, width, height);
			//This was adapted from a post by RDD to an ImageJ forum here: http://imagej.1557.x6.nabble.com/How-to-create-a-regular-grid-of-rectangular-ROI-s-td3685056.html
			run("Crop");
			selectWindow(word[0]+"-"+indexGrid+".tif");
			run("Next Slice [>]"); //2nd slide
			setThreshold(lowBoundVal, 255);
			selectWindow(word[0]+"-"+indexGrid+".tif");
			run("Create Mask");
			selectWindow(word[0]+"-"+indexGrid+".tif");
			run("Create Selection");
			selectWindow(word[0]+"-"+indexGrid+".tif");
			run("Next Slice [>]");
			run("Next Slice [>]");
			run("Next Slice [>]");
			run("Set Measurements...", "area mean integrated redirect=None decimal=3");
			run("Measure"); //5th slide fo
			fo=getResult("Mean",0);
			areaVal=getResult("Area",0);
			//print("Array :");
			//if(indexGrid!=1){
				//Array.print(area);
			//}
			//print("AREA VAL: "+areaVal);
			if(areaVal<0.035){
				if(indexGrid==1){
					area=newArray();
					areaCM=newArray();
					pi=newArray();
					pii=newArray();
					piii=newArray();
					piv=newArray();
					n1=newArray();
					n2=newArray();
					n3=newArray();
					e1=newArray();
					e2=newArray();
					e3=newArray();
					fvfm=newArray();
					pn1=newArray();
					no1=newArray();
					pn2=newArray();
					no2=newArray();
					pn3=newArray();
					no3=newArray();
					//area=newArray("N/A");
				}
				area=Array.concat(area, "N/A");
				areaCM=Array.concat(areaCM, "N/A");
				pi=Array.concat(pi, "N/A");
				pii=Array.concat(pii, "N/A");
				piii=Array.concat(piii, "N/A");
				piv=Array.concat(piv, "N/A");
				n1=Array.concat(n1, "N/A");
				n2=Array.concat(n2, "N/A");
				n3=Array.concat(n3, "N/A");
				e1=Array.concat(e1, "N/A");
				e2=Array.concat(e2, "N/A");
				e3=Array.concat(e3, "N/A");
				fvfm=Array.concat(fvfm, "N/A");
				pn1=Array.concat(pn1, "N/A");
				no1=Array.concat(no1, "N/A");
				pn2=Array.concat(pn2, "N/A");
				no2=Array.concat(no2, "N/A");
				pn3=Array.concat(pn3, "N/A");
				no3=Array.concat(no3, "N/A");
			}
			else{
			if(indexGrid==1){
				area=newArray();
				areaCM=newArray();
				pi=newArray();
				pii=newArray();
				piii=newArray();
				piv=newArray();
				n1=newArray();
				n2=newArray();
				n3=newArray();
				e1=newArray();
				e2=newArray();
				e3=newArray();
				fvfm=newArray();
				pn1=newArray();
				no1=newArray();
				pn2=newArray();
				no2=newArray();
				pn3=newArray();
				no3=newArray();
			}
				
			area=Array.concat(area,areaVal);
			areaCM=Array.concat(areaCM,areaVal*6.4516);
			run("Next Slice [>]");
			run("Measure"); //6th slide fm
			fm=getResult("Mean",1);
			fvfm=Array.concat(fvfm,(fm-fo)/fm);
			run("Next Slice [>]");
			run("Measure"); //7th slide fs
			s7=getResult("Mean",2);
			run("Next Slice [>]");
			run("Measure"); //8th slide fm'
			s8=getResult("Mean",3);
			run("Next Slice [>]");
			run("Measure"); //9th slide fs
			s9=getResult("Mean",4);
			run("Next Slice [>]");
			run("Measure"); //10th slide fm'
			s10=getResult("Mean",5);
			run("Next Slice [>]");
			run("Measure"); //11th slide fs
			s11=getResult("Mean",6);
			run("Next Slice [>]");
			run("Measure"); //12th slide fm'
			s12=getResult("Mean",7);
			run("Next Slice [>]");
		
			run("Measure"); //13th slide fs
			s13=getResult("Mean",8);
			run("Next Slice [>]");
			run("Measure"); //14th slide fm'
			s14=getResult("Mean",9);
			run("Next Slice [>]");
			run("Measure"); //15th slide fs
			s15=getResult("Mean",10);
			run("Next Slice [>]");
			run("Measure"); //16th slide fm'
			s16=getResult("Mean",11);
			run("Next Slice [>]");
			run("Measure"); //17th slide fs
			s17=getResult("Mean",12);
			run("Next Slice [>]");
			run("Measure"); //18th slide fm'	
			s18=getResult("Mean",13);
			run("Next Slice [>]");


			run("Measure"); //19th slide fs
			s19=getResult("Mean",14);
			run("Next Slice [>]");
			run("Measure"); //20th slide fm'
			s20=getResult("Mean",15);
			run("Next Slice [>]");
			run("Measure"); //21st slide fs
			s21=getResult("Mean",16);
			run("Next Slice [>]");
			run("Measure"); //22nd slide fm'
			s22=getResult("Mean",17);
			run("Next Slice [>]");
			run("Measure"); //23rd slide fs
			s23=getResult("Mean",18);
			run("Next Slice [>]");
			run("Measure"); //24th slide fm'
			s24=getResult("Mean",19);
			run("Next Slice [>]");

			run("Measure"); //25th slide fs
			s25=getResult("Mean",20);
			run("Next Slice [>]");
			run("Measure"); //26th slide fm'
			s26=getResult("Mean",21);
			run("Next Slice [>]");
			run("Measure"); //27th slide fs
			s27=getResult("Mean",22);
			run("Next Slice [>]");
			run("Measure"); //28th slide fm'
			s28=getResult("Mean",23);
			run("Next Slice [>]");
			run("Measure"); //29th slide fs
			s29=getResult("Mean",24);
			run("Next Slice [>]");
			run("Measure"); //30th slide fm'
			s30=getResult("Mean",25);

			piVal=(s12-s11)/s12;
			if(!(piVal>0)){
				piVal=(s10-s9)/s10;
			}
			if(!(piVal>0)){
				piVal=(s8-s7)/s8;
			}
			pi=Array.concat(pi,piVal);	
			n1=Array.concat(n1,(fm-s12)/s12);
			e1=Array.concat(e1,280*0.84*0.5*piVal);
			pn1=Array.concat(pn1,(s11/s12)-(s11/fm));
			no1=Array.concat(no1,s11/fm);
//------------------------------------------------------
			piiVal=(s18-s17)/s18;
			if(!(piiVal>0)){
				piiVal=(s16-s15)/s16;
			}
			if(!(piiVal>0)){
				piiVal=(s14-s13)/s14;
			}
			pii=Array.concat(pii,piiVal);
			n2=Array.concat(n2,(fm-s18)/s18);
			e2=Array.concat(e2,610*0.84*0.5*piiVal);
			pn2=Array.concat(pn2,(s17/s18)-(s17/fm));
			no2=Array.concat(no2,s17/fm);
//----------------------------------------------------------
			piiiVal=(s24-s23)/s24;
			if(!(piiiVal>0)){
				piiiVal=(s22-s21)/s22;
			}
			if(!(piiiVal>0)){
				piiiVal=(s20-s19)/s20;
			}
			piii=Array.concat(piii,piiiVal);
			n3=Array.concat(n3,(fm-s24)/s24);
			e3=Array.concat(e3,925*0.84*0.5*piiiVal);
			pn3=Array.concat(pn3,(s23/s24)-(s23/fm));
			no3=Array.concat(no3,s23/fm);
//-----------------------------------------------------------
			pivVal=(s30-s29)/s30;
			if(!(pivVal>0)){
				pivVal=(s28-s27)/s28;
			}
			if(!(pivVal>0)){
				pivVal=(s26-s25)/s26;
			}
			piv=Array.concat(piv,pivVal);
			} //closes else
			selectWindow("Results");
			selectWindow("Results");
			//csvFile="Results2"+word[0]+".csv";
			//saveAs("Results", output+csvFile);
			run("Clear Results");
			indexGrid=indexGrid+1;
			//roiManager("Add");
		}		
	}
print("Area In^2: ");
//print("Len: "+area.length);
for(i=0;i<16;i++){
	print(area[i]);
}
print("");
print("Area Cm^2: ");
for(i=0;i<16;i++){
	print(areaCM[i]);
}
print("");
print("PSII1: ");
for(i=0;i<16;i++){
	print(pi[i]);
}
print("");
print("PSII2: ");
for(i=0;i<16;i++){
	print(pii[i]);
}
print("");
print("PSII3: ");
for(i=0;i<16;i++){
	print(piii[i]);
}
print("");
print("PSII4: ");
for(i=0;i<16;i++){
	print(piv[i]);
}
print("");
print("NPQ1: ");
for(i=0;i<16;i++){
	print(n1[i]);
}
print("");
print("NPQ2: ");
for(i=0;i<16;i++){
	print(n2[i]);
}
print("");
print("NPQ3: ");
for(i=0;i<16;i++){
	print(n3[i]);
}
print("");
print("ETR1: ");
for(i=0;i<16;i++){
	print(e1[i]);
}
print("");
print("ETR2: ");
for(i=0;i<16;i++){
	print(e2[i]);
}
print("");
print("ETR3: ");
for(i=0;i<16;i++){
	print(e3[i]);
}
print("");
print("pNPQ1: ");
for(i=0;i<16;i++){
	print(pn1[i]);
}
print("");
print("pNPQ2: ");
for(i=0;i<16;i++){
	print(pn2[i]);
}
print("");
print("pNPQ3: ");
for(i=0;i<16;i++){
	print(pn3[i]);
}
print("");
print("pNO1: ");
for(i=0;i<16;i++){
	print(no1[i]);
}
print("");
print("pNO2: ");
for(i=0;i<16;i++){
	print(no2[i]);
}
print("");
print("pNO3: ");
for(i=0;i<16;i++){
	print(no3[i]);
}
print("");
print("Fv/Fm: ");
for(i=0;i<16;i++){
	print(fvfm[i]);
}
}


processRun();

print("");
word2=split(file,".");
txtFile="Log"+word2[0]+".txt";
selectWindow("Log");
saveAs("Text", output+txtFile);

selectWindow("Log");
run("Close");
selectWindow("Results");
run("Close");
run("Close All");
}
