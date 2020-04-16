//QUICK START (sample dataset)
LOAD CSV WITH HEADERS FROM "file:///dataset_test.csv" AS row
WITH row WHERE row.PD_DESC IS NOT NULL
MERGE (arrest:Arrest {key: row.ARREST_KEY, date: row.ARREST_DATE})
MERGE (personGroup:PersonTrait {age: row.AGE_GROUP, race: row.PERP_RACE, sex: row.PERP_SEX})
MERGE (location: Location {boro: row.ARREST_BORO, precinct: row.ARREST_PRECINCT})
MERGE (crime: Crime {title: row.PD_DESC, description: row.OFNS_DESC})
CREATE (arrest)-[rel1:COMMITED_BY]->(personGroup)
CREATE (arrest)-[rel2:COMMITED_AT]->(location)
CREATE (arrest)-[rel3:OFFENCE]->(crime)


//LOADING THE FULL DATA (steps)

//Step 1: Add Indexes
CREATE INDEX ON :PersonTrait(race)
CREATE INDEX ON :Crime(title) 
CREATE INDEX ON :Arrest(key)

//Step 2: Add a part of data
:auto USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///NYPD_Arrests_Data__Historic_.csv" AS row
WITH row WHERE row.PD_DESC IS NOT NULL AND row.AGE_GROUP IS NOT NULL AND row.PERP_RACE IS NOT NULL AND row.PERP_SEX IS NOT NULL
MERGE (personGroup:PersonTrait {age: row.AGE_GROUP, race: row.PERP_RACE, sex: row.PERP_SEX})

//Step 3: Add a part of data
:auto USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///NYPD_Arrests_Data__Historic_.csv" AS row
WITH row WHERE row.AGE_GROUP IS NOT NULL AND row.PERP_RACE IS NOT NULL AND row.PERP_SEX IS NOT NULL
WITH row WHERE row.ARREST_BORO IS NOT NULL AND row.ARREST_PRECINCT IS NOT NULL
WITH row WHERE row.PD_DESC IS NOT NULL AND row.OFNS_DESC IS NOT NULL
WITH row WHERE row.ARREST_KEY IS NOT NULL AND row.ARREST_DATE IS NOT NULL
MERGE (location: Location {boro: row.ARREST_BORO, precinct: row.ARREST_PRECINCT})

//Step 4: Add a part of data
:auto USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///NYPD_Arrests_Data__Historic_.csv" AS row
WITH row WHERE row.AGE_GROUP IS NOT NULL AND row.PERP_RACE IS NOT NULL AND row.PERP_SEX IS NOT NULL
WITH row WHERE row.ARREST_BORO IS NOT NULL AND row.ARREST_PRECINCT IS NOT NULL
WITH row WHERE row.PD_DESC IS NOT NULL AND row.OFNS_DESC IS NOT NULL
WITH row WHERE row.ARREST_KEY IS NOT NULL AND row.ARREST_DATE IS NOT NULL
MERGE (crime: Crime {title: row.PD_DESC, description: row.OFNS_DESC})

//Step 5: Add the remaining data and link it all together
:auto USING PERIODIC COMMIT 10000
LOAD CSV WITH HEADERS FROM "file:///NYPD_Arrests_Data__Historic_.csv" AS row
WITH row WHERE row.AGE_GROUP IS NOT NULL AND row.PERP_RACE IS NOT NULL AND row.PERP_SEX IS NOT NULL
WITH row WHERE row.ARREST_BORO IS NOT NULL AND row.ARREST_PRECINCT IS NOT NULL
WITH row WHERE row.PD_DESC IS NOT NULL AND row.OFNS_DESC IS NOT NULL
WITH row WHERE row.ARREST_KEY IS NOT NULL AND row.ARREST_DATE IS NOT NULL
MATCH (crime: Crime {title: row.PD_DESC, description: row.OFNS_DESC})
MATCH (location: Location {boro: row.ARREST_BORO, precinct: row.ARREST_PRECINCT})
MATCH (personGroup:PersonTrait {age: row.AGE_GROUP, race: row.PERP_RACE, sex: row.PERP_SEX})
CREATE (arrest:Arrest {key: row.ARREST_KEY, date: row.ARREST_DATE})
CREATE (arrest)-[rel3:OFFENCE]->(crime)
CREATE (arrest)-[rel2:COMMITED_AT]->(location)
CREATE (arrest)-[rel1:COMMITED_BY]->(personGroup)