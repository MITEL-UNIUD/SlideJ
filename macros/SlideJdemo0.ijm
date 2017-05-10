/////////////////////////////////////////////////////////
// SlideJDemo0 macro                                   //
//                                                     //
// To demonstrate basic SlideJ functioning             //
/////////////////////////////////////////////////////////


TimeString = currentTime();


slide=slideData();
tile=getTitle;

//if a new slide is started, create a new row. If not, read previous data
if (nResults>0) {
	previous=getVariable("file");
	if(slide[0]!=previous) {
		addVariable("file",slide[0]);
		setVariable("series",slide[1]);
		setVariable("size",slide[4]);
		setVariable("startime",TimeString);
		setVariable("ntiles",1);
		}
	else {
		setVariable("ntiles",getVariable("ntiles")+1);
	}
}
else {
	addVariable("file", slide[0]);
	setVariable("series",slide[1]);
	setVariable("size",slide[4]);
	setVariable("startime",TimeString);
	setVariable("ntiles",1);
	}

close("*");


//To clean up memory
call("java.lang.System.gc");

setVariable("endtime",currentTime());



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
