/////////////////////////////////////////////////////////
// SlideJ CallerDemo2:                                 //
// Calling SlideJ from another macro                   //
//                                                     //
// It calls SlideJDemo and then shows the tile with    //
// highest percentage.                                 //
// It works with more than one slide in the "In" folder//
/////////////////////////////////////////////////////////


// Quicker with this
setBatchMode(true);

in="/Users/enzo/Documents/lavori/AIDPATH/SlideJ/in/";
out="/Users/enzo/Documents/lavori/AIDPATH/SlideJ/tiles/";
callit="/Users/enzo/Documents/lavori/AIDPATH/SlideJ/SlideJdemo1.txt";

run("SlideJ ", "input="+in+" output="+out+" macro="+callit+" series=2 tile=3072 overlap=0 cancel=No");

tile=""; max=0;
for(i=0; i<nResults; i++) {
		if(getResult("percentage",i)>max) {
			print(i);
			max=getResult("percentage",i);
			tile=getResultString("tile",i);
		}
}
		print(out+tile);
setBatchMode(false);
open(out+tile);





/////////////////////////////////////////////////////////
// SlideJ Support functions                            //
// v1.0 - 20170420                                     //
//                                                     //
// MITEL                                               //
// Dept. of Mathematics, Computer Science and Physics  //
// University of Udine, Italy                          //
// http://mitel.dimi.uniud.it                          //
/////////////////////////////////////////////////////////


// Returns an array containing original file name, series number, X and Y origin, pixel size
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
	
	size=getWidth();
	
	res=newArray(file,series,x,y,size);
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
