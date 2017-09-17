# ImageJ
<ul>
  <li>To get RGB color values from images of leaves placed in a grid layout, download Color.ijm.</li>
  <li>To get fluorescence-related values from .tif files after using ImagingWin, download Crop.ijm to first crop all .tif files, and then download PAMFluorescence.ijm.</li>
  </ul>
  
  <h2>Crop.ijm</h2>
  <h3>Directions</h3>
  1. Create an input directory containing the .tif files (from ImagingWin).<br>
2. Create an output directory, which will contain the cropped .tif files after running the code.<br>
3. After you download the Crop.ijm file, open the file in ImageJ (Plugins -> Macros -> Edit).<br>
4. Look for the following lines near the top:<br>
input=YOUR_INPUT_DIRECTORY;<br>
output=YOUR_OUTPUT_DIRECTORY;<br><br>

And write the path for your input and output directory:<br>
Example: input=“C:\\Users\\...";<br>
<b><i>Important: Make sure there is a semicolon after the path</i></b><br><br>

<h2>PAMFluorescence.ijm</h2>
  <p>Note: This file works for 4 by 4 grid layout (can work for other grid layout if you change numRow and numCol in the code).</p>
<h3>Directions:</h3>
1. Create an input directory containing the .tif files (from ImagingWin).<br>
2. Create an output directory, which will contain .txt files after running the code.<br>
3. After you download the PAMFluorescence.ijm file, open the file in ImageJ (Plugins -> Macros -> Edit).<br>
4. Look for the following lines near the top:<br>
input=YOUR_INPUT_DIRECTORY;<br>
output=YOUR_OUTPUT_DIRECTORY;<br><br>

And write the path for your input and output directory:<br>
Example: input=“C:\\Users\\...";<br>
<b><i>Important: Make sure there is a semicolon after the path</i></b><br><br><br>
<h2>Color.ijm</h2>
<p>Note: This file works for 4 by 4 grid layout (can work for other grid layout if you change numRow and numCol in the code).</p>
<h3>Directions:</h3>
1. Download Versatile Wand from this site: https://imagej.nih.gov/ij/plugins/versatile-wand-tool/index.html and follow the directions there.<br>
2. Download the image file “1mM1.jpg” in this repository.<br>
3. Create an input directory containing images (.jpg) of your leaves.<br>
4. Create an output directory, which will contain CSV files after running the code.<br>
5. After you download the Color.ijm file, open the file in ImageJ (Plugins -> Macros -> Edit).<br>
6. Look for the following lines near the top:<br>
input=YOUR_INPUT_DIRECTORY;<br>
output=YOUR_OUTPUT_DIRECTORY;<br><br>

And write the path for your input and output directory:<br>
Example: input=“C:\\Users\\...";<br>
<b><i>Important: Make sure there is a semicolon after the path<br></i></b><br><br><br>
Look for the line: open(IMAGE_PATH);<br>
	And write the path for the image "1mM1.jpg" you downloaded from this repository<br>
Example: open("C:\\Users\\...");<br><br><br>
<ul>
<li>To read the output CSV file (in your output directory):	<br>
The code’s grid layout labels the leaves going across, in rows.   For example, if it’s a 4 by 4 grid, leaves in the first row of the grid of leaves are labeled #1, #2, #3, and #4.  Second row leaves are labeled #5, #6, #7, #8.  Same goes for the rest.</li>
<li>
Data is organized in rows.  The important column to look at is “Mean”, which gives the color values.  Let’s say you have “n” number of leaves.  Then the first n rows (Rows #1 to n) contain the R values for all your leaves in order.  The next n rows (Rows # n+1 to # 2n) contain the G values for all your leaves in order.  Lastly, the final n rows (Rows # 2n+1 to #3n) contain the B values for all your leaves in order.  For example, for a 4 by 4 grid layout, rows #1 to #16 contain R values.  Rows #17 to #32 contain G values (so row 17 would contain G value for leaf #1).  Rows #33 to #48 contain B values (so row 33 would contain B value for leaf #1).</li>
</ul>

