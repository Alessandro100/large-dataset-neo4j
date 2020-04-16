# large-dataset-neo4j
This folder runs through the import of the NYPD dataset (0.8 gigs) into neo4j to get insight

Requirements:
-	Download the NYPD dataset from https://catalog.data.gov/dataset/nypd-arrests-data-historic/resource/edd46fca-a8d9-41f4-ade2-e720c1bd8314 (~0.8 gigs)
-	Download Neo4j Desktop Client

Steps:
-	In the Neo4j Desktop Client, create an empty graph
-	Import the test dataset and real data set into the ‘import’ file
-	Open the Neo4j desktop browser for the graph you just created
-	Run the queries to load the data found in load-data.cypher
o	If its quick start, only 1 command to run (fast but not complete)
o	If it’s all the data, will take a bit of time and 5 commands to run (instructions in the file)
-	Once the data is loaded, you can run queries on it found in the queries.cypher

