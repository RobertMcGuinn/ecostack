20241220: STATUS: Experimental / Developing

# ecostack 
## Code for making Ecosystem Data Packages leveraging H3
Goal: Deliver Ecosystem Data Packages in the form of H3 hexagon layers with key attributes for any number of NOAA acquired datasets. 

### Advantages of the H3 approach vs. traditional geographic summary methods
- Easy geographic integration and comparison: No more mismatched variables.  
- Computationally efficient tablular queries rather than GIS operations.
- Light weight (No need to store topology, that is all in the H3 ID).
- Data reduction. Hex layers are a lot more light weight that original data.
- Each "hexification" method can be modified to the interest of the researcher.

#### Scale
Note that for the current application it seems like H3 scale levels 7 and 8 are the appropriate ones, but this should be revisited when trying to move these approaches to other applications.  

#### Delivery Format
- Integrated dataset as a set of "hexified" layers that can be easily joined and manipulated.  
- Alternatively, deliver one hex layer with many attributes attached.  

## Methods for the "hexification"

### Points to Hex
- Count
- Statistics of some numerical attribute within the point layer
- Enumeration of Categorcial variables (e.g. # of unique ScientificName)
- Assignment of single category (e.g. place designation)

### Raster to Hex
- Area of a particular class
- Number of different classes
- Continuous raster statisics
- Patch statistics
- Topographic summaries

### Lines to Hex
- Meters of line
- Area of line (when buffered) - See Polygons to Hex

### Polygons to Hex
- Area of particular class
- Continuous value statistics (area weighted)
- Number of classes
- Dominant class
- Assignment of single class (e.g. place designation)

