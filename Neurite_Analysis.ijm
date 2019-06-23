/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                         //
// Marco for neurite analysis											                                   //
//                                                                                                         //
//                                                                                                         //
// Written by: Yan-Ping Zhang Schaerer	                                                                   //
// Date: 22/01/2016                                                                                        //
// Copy Right: Hoffmann-La Roche AG                                                                        //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*
dir is the image folder
if img is empty, then analyze all .lif images in the dir folder,
if img is specified, then only analyze this one
channel is the selected channel for analysis
*/
//directory
var dir = "\\\\pr-ba-data7\\PR_Ba_Scratch\\Yanping\\Lingo1"//"C:\\Temp\\Lingo1"
var img = "" //"Pair 1 - Cortex.lif", ""
var channel = "C=1" //"C=1", "C=2"

//Parameters (global variables)
var filter_sigma = 0.4196;
var threshold_method = "Otsu dark"; //"Default dark","Otsu dark","Huang dark"		
var skeletonize = "";// "skeletonize", ""

////////////////////////////////////////////////////////////////////////////////////////////////////////////
setBatchMode(true);
sep = "\\"
if (img != "") {
	path = dir + sep + img;
	run_Neurite_analysis(path);
}
else {
	list = getFileList(dir);
	for (m = 0; m < list.length; m++) {
		if (endsWith(list[m], ".lif")) {
			path = dir + sep + list[m];
			run_Neurite_analysis(path);
		}
	}
}

/*
input is the path of the .lif image
output is a result table
*/
function run_Neurite_analysis(path) {
	// close all open image windows
	run("Close All");
	// open lif image
	command =  "open=[" + path + "] open_all_series"
				+ " split_channels autoscale color_mode=Default view=Hyperstack stack_order=XYCZT";
    run("Bio-Formats Importer", command);
    // process selected image channel
    for (k=0; k<nImages;k++) {
		selectImage(k+1);
		title_img = getTitle();
		if (endsWith(title_img, channel)){
			run("Z Project...", "projection=[Max Intensity]");
		    rename("Max_" + title_img);
		    run("Analyze Neurite", "select=[" + "Max_" + title_img 
		    + "] threshold=[" + threshold_method + "] sigma=" + parseFloat(filter_sigma) + " " + skeletonize);
		    close("*" + title_img + "*");
		}
    }
}	  
	





