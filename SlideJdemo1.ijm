/////////////////////////////////////////////////////////
// SlideJDemo1 macro                                   //
//                                                     //
// To demonstrate basic SlideJ functioning             //
/////////////////////////////////////////////////////////

// Quicker with this
setBatchMode(true);

slide=slideData();
tile=getTitle;

// problem-specific code from here...
col1=tile+"-(Colour_1)";
col2=tile+"-(Colour_2)";

run("Colour Deconvolution", "vectors=[H DAB] hide");
close();

//create a row in the Results table, tile related data
addVariable("file",slide[0]);
setVariable("tile",tile);
setVariable("series",slide[1]);
setVariable("X",slide[2]);
setVariable("Y",slide[3]);

//brown
selectWindow(col2);
run("Smooth");
run("Smooth");
setAutoThreshold("Default");
run("Convert to Mask");


getStatistics(area, mean, min, max, std, histobrown);
// create a second cell in the row with number of brown pixels
setVariable("brown",histobrown[255]);


selectWindow(col1);
run("Smooth");
run("Smooth");
setAutoThreshold("Default");
//setThreshold(0, 165);
run("Convert to Mask");
//run("Close");

getStatistics(area, mean, min, max, std, histoblue);
// create a third cell in the row with number of blue pixels
setVariable("blue",histoblue[255]);

// create a fourth cell in the row with positivity percentage
setVariable("percentage", 100*histobrown[255]/(histobrown[255]+histoblue[255]));
close("*");

//... to here - end of problem-specific content

//To clean up memory
call("java.lang.System.gc");





/////////////////////////////////////////////////////////
// SlideJ Support functions                            //
// v1.0 - 20170420                                     //
//                                                     //
// MITEL                                               //
// Dept. of Mathematics, Computer Science and Physics  //
// University of Udine, Italy                          //
// http://mitel.dimi.uniud.it                          //
/////////////////////////////////////////////////////////


// Returns an array containing:
// original file name, series number, X and Y origin, width and height of the tile
// (in principle width and height are as requested in parameters, but border tiles
// could be smaller)
// Call it before doing anything on the image
function slideData() {
	title=getTitle();
	i1=indexOf(title,"__");
	i2=indexOf(title,"_",i1+2);
	i3=indexOf(title,"_",i2+1);
	i4=indexOf(title,".tif",i3+1);

	file=substring(title,0,i1);
	series=substring(title,i1+2,i2);
	x=substring(title,i2+1,i3);
	y=substring(title,i3+1,i4);
	
	Xsize=getWidth();
	Ysize=getHeight();
	
	res=newArray(file,series,x,y,Xsize,Ysize);
	return res;
}

// Sets a value for the named variable in the last result row
function setVariable(name, value) {
	setResult(name,nResults-1,value);
}

// Adds a new row and sets a value for the named variable
function addVariable(name, value) {
	setResult(name,nResults,value);
}

// Gets the value of the named variable in the last Results row
function getVariable(name) {
	res= getResultString(name,nResults-1);
	res1=parseInt(res);
	res2=parseFloat(res);
	if(!isNaN(res1)) return res1;
	else if(!isNaN(res2)) return res2;
	else return res;
}

function currentTime() {
getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
     TimeString="";
     if (hour<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+hour+":";
     if (minute<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+minute+":";
     if (second<10) {TimeString = TimeString+"0";}
     return TimeString+second;
}