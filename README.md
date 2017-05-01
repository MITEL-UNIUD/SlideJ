# SlideJ

## Synopsis

SlideJ is an ImageJ plugin for processing **digital slides** (also known as virtual slides, WSI, etc). SlideJ has been tested in the following formats: Aperio .SVS, Leica .SCN, Hamamatsu .NDPI, Mirax, Generic tiled TIFF and regular TIFF. It works by splitting the slide in square tiles and iterating a user-configurable macro on each of them. SlideJ allows the user to launch very long series of unsupervised tasks which can be performed in free time.

## Code Example

SlideJ can be called directly from the ImageJ user interface, but as many other plugins, also from another macro. At launch, a modal dialog is shown to configure the main execution parameters.

## Motivation

SlideJ was created to provide a common framework for rapid prototyping of image processing and analysis of digital slides using ImageJ. It is based on Bio-Formats, which already provides digital slide access, but adds a layer of abstraction useful for many algorithms (though not all).

## Installation

To install SlideJ, just put it in the Plugins folder of ImageJ. The only requirement for the correct usage of SlideJ with ImageJ is the installation of Bio-Formats package and fiji-lib.jar in jars folder of ImageJ. 


## Tests

Describe and show how to run the tests with code examples.

## Contributors

Let people know how they can dive into the project, include important links to things like issue trackers, irc, twitter accounts if applicable.

## License

A short snippet describing the license (MIT, Apache, etc.)
