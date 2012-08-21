# XQuery SVG Examples

This project is a collection of XQuery programs that generate SVG documents.

## License

&copy; 2012 Charles Dietrich 

Released under the MIT license

## About

The programs here are designed for a high school drafting class with access to a 
laser cutter or computerized paper cutter.

The intent is to teach programming. The students start by learning the basics of the
SVG standard and simple for loops in XQuery. They progress to developing a more 
complex program to design a lampshade.

The course is project based.

## Projects

* Project 1 "Name": write your name in SVG without using the `<text>` element. 
Use a for loop to generate a repeated pattern. Use `template.xq` to start.
Example program `charles.xq`.

* Project 2 "Lamp": approximate a non-developable surface (e.g. a sphere) using
interlocking pieces of flexible material. Example (advanced, in progress): 
`cone-sphere.xq`

Possible additional projects:

* "Visualization": create a visualization that ingests XML data and 
outputs an SVG.

## Software required

* XQuery editor (suggested): 28msec Sausalito (all platforms). This is an Eclipse-based 
editor that includes the Zorba XQuery processor.
* SVG-capable browser: Google Chrome, etc.
* SVG editor: Inkscape, svg-edit (browser-based), etc.
* SVG->cutter converter: a converter that can convert SVG to a format the laser cutter 
or computerized paper cutter can use, e.g. Inkscape, Corel Draw, etc.

Students should use the included `svg-utils.xq`, a library for generating SVG transform 
and path microsyntax.
