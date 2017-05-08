# SlideJ

## Synopsis

SlideJ is an ImageJ plugin for processing **digital slides** (also known as virtual slides, WSI, etc). SlideJ is an ImageJ plugin for processing digital slides (also known as virtual slides, WSI, etc). SlideJ has been tested  on slides in the following formats: Aperio .SVS, Leica .SCN, Hamamatsu .NDPI, Mirax, Generic tiled TIFF and regular TIFF.
It works by splitting the slide in square tiles and iterating a user-configurable macro on each of them. 

SlideJ can be called directly from the ImageJ user interface, but as many other plugins, also from another macro. At launch, a modal dialog is shown to configure the main execution parameters.

## Motivation

SlideJ was created to provide a common framework for rapid prototyping of image processing and analysis of digital slides using ImageJ. It is based on Bio-Formats, which already provides digital slide access, but adds a layer of abstraction useful for many algorithms (though not all).

## Installation

To install SlideJ, just put it in the Plugins folder of ImageJ. The only requirements are the Bio-Formats package and  fiji-lib.jar (put them in the jar folder of ImageJ, or directly use Fiji). 


## Tests

To test SlideJ, create a folder (e.g., "in") and put digital slides into it; create annother folder to storing tiles (e.g., "out"). Choose a macro you want to run on your slides. From the ImageJ Plugins menu, call the plugin, set parameters, and wait.


## License

SLideJ is licensed under GPL. 

