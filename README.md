20241220: STATUS: Experimental / Developing

# ecostack 
## Code for making Ecosystem Data Packages leveraging H3

Actions: 
Join key attributes for any number of NOAA acquired datasets to H3 Hexagons at various scales. Note that for the current application it seems like scale levels 7 and 8 are the appropriate ones, but this should be revisited when trying to move these approaches to other applications.  

Deliver this integrated dataset as a set of "hexified" layers that can be easily joined and manipulated.  

Alternatively, deliver one hex layer with many attributes attached.  

Various methods for the "hexification"

### Points to Hex
- Count
- Statistics of some numerical attribute within the point layer
- Enumeration of Categorcial variables (e.g. # of unique ScientificName)
### Raster to Hex
- Area of a particular class
- Number of different classes
- Continuous raster statisics
- Patch statistics
- Topographic summaries
### Lines to Hex
### Polygons to Hex
