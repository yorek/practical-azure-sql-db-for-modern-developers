/*
	Spatial index
*/
-- Note: Table must have a primary key for the spatial index

CREATE SPATIAL INDEX SI_Flightline_Routes  
   ON Flightline(Route)  
   USING GEOGRAPHY_GRID  
   WITH (  
    GRIDS = ( MEDIUM, LOW, MEDIUM, HIGH ),  
    CELLS_PER_OBJECT = 64,  
    PAD_INDEX  = ON
);