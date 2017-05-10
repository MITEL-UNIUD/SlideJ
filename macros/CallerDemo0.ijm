/////////////////////////////////////////////////////////
// SlideJ CallerDemo2:                                 //
// Calling SlideJ from another macro                   //
//                                                     //
// This is a macro that calls SlideJ passing another   //
// macro (SlideJDemo2). It has been used for           // 
// performance tests (it sets batch mode at the start).//
/////////////////////////////////////////////////////////


// Quicker with this
setBatchMode(true);

in="/Users/enzo/Documents/lavori/AIDPATH/SlideJ/in/";
out="/Users/enzo/Documents/lavori/AIDPATH/SlideJ/tiles/";
callit="/Users/enzo/Documents/lavori/AIDPATH/SlideJ/github/SlideJdemo0.ijm";

addVariable("endtime",currentTime());
setVariable("file","no");

run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=1 tile=8192 overlap=0 cancel=Yes");
run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=1 tile=16384 overlap=0 cancel=Yes");
run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=1 tile=4096 overlap=0 cancel=Yes");
run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=1 tile=12388 overlap=0 cancel=Yes");
run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=1 tile=6144 overlap=0 cancel=Yes");
run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=1 tile=14336 overlap=0 cancel=Yes");
run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=1 tile=10240 overlap=0 cancel=Yes");
run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=1 tile=3072 overlap=0 cancel=Yes");
run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=1 tile=2048 overlap=0 cancel=Yes");



setBatchMode(false);

addVariable("endtime",currentTime());





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
