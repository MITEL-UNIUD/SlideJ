import ij.plugin.*;
import ij.*;
import ij.process.*;
import ij.gui.*;
import ij.util.Tools;
import ij.io.*;
import ij.macro.Interpreter;
import ij.IJ;
import ij.plugin.PlugIn;

import java.util.*;
import java.util.GregorianCalendar;
import java.awt.image.ColorConvertOp;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.Vector;
import java.io.File;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.text.SimpleDateFormat;

import loci.formats.gui.BufferedImageReader;
import loci.formats.FormatException;
import loci.common.services.ServiceFactory;
import loci.formats.ImageReader;
import loci.formats.ImageWriter;
import loci.formats.meta.IMetadata;
import loci.formats.services.OMEXMLService;
import loci.plugins.LociImporter;
import fiji.util.gui.GenericDialogPlus;

/** 
    MITEL
    Dept. of Mathematics, Computer Science and Physics University of Udine, Italy 
*/

/** 
    SlideJ is an ImageJ plugin for automated processing of Whole Slide Images.
    SlideJ has been tested  on slides in the following formats:  
    Aperio .SVS, Leica .SCN, Hamamatsu .NDPI, Mirax, Generic tiled TIFF and regular TIFF.
    The user is allowed to process multiple images present in a folder and store the eventual results in a 
    different folder by setting up paths in the “input” and “output” fields,respectively.
    Since digital slide processing could be a time consuming task, SlideJ allows the user to launch very 
    long series of unsupervised tasks which can be performed in free time.
    SlideJ is released uner LGPL v3 License.
*/

public class SlideJ_ implements PlugIn{
private GenericDialogPlus gd;
private String macro;
private String cancel_file;
private int serie;
private int crop;
private int overlap;


private static final String[] code = {
    "[Select from list]",
    "Yes",
    "No",
    };
    
public void run(String arg) {
	
    /* The interface of the plugin is a modal dialog that resembles the one implemented in ImageJ
       for batch macro execution. */
    gd = new GenericDialogPlus("SlideJ");
    gd.addDirectoryField( "input", "");
    gd.addDirectoryField( "output", "");
    gd.addDirectoryOrFileField( "macro", "");
    gd.addStringField("Series: ", "1", 5);
    gd.addStringField("Tile size: ", "1024", 10);
    gd.setInsets(0, 0, 10);
    gd.addStringField("Overlap: ", "0", 10);
    gd.setInsets(0, 0, 10);
    gd.addChoice("Cancel temporary tiles?", code, code[1]);
    
    gd.showDialog();
    
    String inputPath = gd.getNextString();
    String outputPath = gd.getNextString();
    String macro = gd.getNextString();
    String serie_str = gd.getNextString();
    String crop_str = gd.getNextString();
    String overlap_str = gd.getNextString();
    
    serie = Integer.parseInt(serie_str);
    crop = Integer.parseInt(crop_str);
    overlap = Integer.parseInt(overlap_str);
    cancel_file =  gd.getNextChoice();
    
    if (gd.wasCanceled()) {
        return;
    }
    
    if (inputPath.equals("")) {
        error("Please choose an input folder");
        return;
    }
    inputPath = addSeparator(inputPath);
    File f1 = new File(inputPath);
    if (!f1.exists() || !f1.isDirectory()) {
        error("Input does not exist or is not a folder\n \n"+inputPath);
        return;
    }
    if (outputPath.equals("")) {
        error("Please choose an output folder");
        return;
    }
    outputPath = addSeparator(outputPath);
    File f2 = new File(outputPath);
    if (!f2.exists() || !f2.isDirectory()) {
        error("Output does not exist or is not a folder\n \n"+outputPath);
        return;
    }
    if (macro.equals("")) {
        error("Please choose a macro file");
        return;
    }
    File f3 = new File(macro);
    if (!f3.exists()) {
        error("Macro does not exist \n"+macro);
        return;
    }
    
    ImageJ ij = IJ.getInstance();
		if (ij!=null)
            ij.getProgressBar().setBatchMode(true);
    IJ.resetEscape();
    
    File[] list1=f1.listFiles();
    int MAX=list1.length;
    long startTime = 0;
    try{
        FileWriter w;
        w=new FileWriter(outputPath + "SlideJlog.txt", true);
        GregorianCalendar now = new GregorianCalendar();
        SimpleDateFormat dateformat = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss");
        w.write("Start SlideJ Plugin: " +dateformat.format( now.getTime() ) + "\n\r");
        w.flush();
        for (int i = 0; i<MAX; i++){
            
        startTime = System.currentTimeMillis();//Time recorder
        
            
        ImageReader imageReader = new ImageReader(); //Byte reader
        BufferedImageReader buffImageReader = new BufferedImageReader();
        String inputName =list1[i].getName();
        if(! inputName.endsWith(".DS_Store")){
            
            String imgPath = inputPath + inputName;
            System.out.println(imgPath);
            try
            {
                imageReader.setId(imgPath);
                BufferedImageReader buffImageReaderTest = new BufferedImageReader();
                buffImageReaderTest.setId(imgPath);
                int s = (serie - 1);
                buffImageReaderTest.setSeries(s);
                int buffYTest = buffImageReaderTest.getSizeY();
                int buffXTest = buffImageReaderTest.getSizeX();
                int t = (int) crop;
                int over = (int) overlap;
                int tilex = t;
                int x_coor = 0;
                for( int j = 0; j == 0; x_coor = x_coor + t - over) {
                    int tiley = t;
                    int y_coor = 0;
                    
                    for( int z = 0;z == 0; y_coor = y_coor + t - over) {
                        
                       if((x_coor + t) >= buffXTest)
                       {
                           tilex = buffXTest - x_coor;
                           j = 1;
                       }
                        
                        if((y_coor + t) >= buffYTest)
                        {
                            tiley = buffYTest - y_coor ;
                            z = 1;
                            
                        }
                        
                        
                        BufferedImage rgbImage = buffImageReaderTest.openImage(0,x_coor, y_coor, tilex, tiley);
                        /* Tiles are stored in TIFF format with a file name that reflects their position 
                           on the overall digital slide according to the following template:
                           <OriginalFileName.ext>__<series>_<Xorigin>_<Yorigin>.tif */
                        File fileTileOut = new File(outputPath +inputName+"__"+serie+"_"+x_coor+"_"+ y_coor+".tif");
                        String title = inputName+"__"+serie+"_"+x_coor+"_"+ y_coor+".tif";
                        ImagePlus imp = new ImagePlus(title,rgbImage);
                        IJ.run(imp, "RGB Color", "");
                        String path_imprgb = outputPath +inputName+"__"+serie+"_"+x_coor+"_"+ y_coor+".tif";
                        //imp.close();
                        IJ.saveAs(imp, "Tiff", path_imprgb );
                        //imp.close();
                        imp.flush();
                        IJ.open(path_imprgb);
                        ImagePlus imp1 = IJ.getImage();
                        IJ.runMacroFile(macro);//Macro application
                        if(cancel_file.equals("Yes")){
                              //imp1.close();
                              imp1.flush();
                              fileTileOut.delete();
                            
                        }
                         else if(cancel_file.equals("No")){
                        
                        //imp1.close();
                        imp1.flush();
                        }
                     
                    
                        
                    }
                }
                long endTime   = System.currentTimeMillis();
                long totalTime = endTime - startTime;
                
                
                w.write("File " +inputName+ ", series number " +serie+ ", tile size " +crop+ ", overlap " +overlap+ ", time " +totalTime+ " ms. "+ "\n\r");
                w.flush();
            }
            catch (FormatException exc)
            {
                System.out.println("Format exception" + exc.getMessage());
            }
            catch (IOException exc)
            {
                System.out.println("I/O exception" + exc.getMessage());
            }
            
            
            
        }
            
    }
    
    
}
    catch (IOException e)
    {
        e.printStackTrace();
    }

}
    
  
	
	
	
		
	String addSeparator(String path) {
		if (path.equals("")) return path;
		if (!(path.endsWith("/")||path.endsWith("\\")))
			path = path + File.separator;
		return path;
	}
	
	void error(String msg) {
		IJ.error("Error:", msg);
	}
    
    public void run() {
        
    }
    
}

