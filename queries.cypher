//NOTE: Assure to have loaded the data in

//Query 1
//Description: Gets the top 3 areas with the most arrests
MATCH (l:Location)
RETURN l.boro AS boro, l.precinct as precinct, size(()-->(l)) AS count
ORDER BY count DESC LIMIT 3

//Query 2
//Description: Get the number of crimes commited per race and the percentage it represents
MATCH (a: Arrest)
MATCH (p:PersonTrait {race: "BLACK"})
WITH p.race AS race, size(()-->(p)) AS countOfArrests, count(a) AS totalArrests
RETURN race, sum(countOfArrests) AS count, ((sum(countOfArrests) / toFloat(totalArrests) )* 100) AS shareOfCrimePercent
ORDER BY count DESC 

//Query 3
//Description: Top 3 crimes commited by white males between the age 25-44
MATCH (c:Crime)<-[:OFFENCE]-(a:Arrest)-[:COMMITED_BY]->(p:PersonTrait {race: 'WHITE', age: "25-44", sex: "M"})
WITH count(c) AS crimeCount, p AS person, c AS crime
RETURN crime.title, crimeCount
ORDER by crimeCount DESC LIMIT 3

//Query 4
//Description: Top 3 days with most arrest
MATCH (a:Arrest)
WITH a.date as date, a.key as k 
RETURN date, count(distinct k) as count
ORDER BY count DESC LIMIT 3

//Query 5
//Description: Avg # of crimes between the 24th and the 1st jan vs avg of Arrest normal day
MATCH (a:Arrest)
WITH distinct a.date as date, count(distinct a.key) as keyCount
WHERE date =~ '\\d{1,2}\\/\\d{1,2}\\/\\d{4}'
RETURN avg(keyCount)
UNION 
MATCH (a:Arrest)
WITH distinct a.date as date, count(distinct a.key) as keyCount
WHERE date =~ '12\\/2[4-5]\\/\\d{4}'
RETURN avg(keyCount)

//Query 6
//Description: Location with most violent crimes ( - "RAPE 3" - "MURDER,UNCLASSIFIED" - "SEXUAL ABUSE 1" - "MURDER,UNCLASSIFIED" - "AGGRAVATED CRIMINAL CONTEMPT" - "RAPE 1" - "STRANGULATION 1ST")
MATCH(l:Location)
MATCH(c:Crime)
WHERE c.title="SEXUAL ABUSE 1"
RETURN l.boro as boro, l.precinct as precinct, size((c)<--()-->(l)) AS count
ORDER BY count DESC

//Query 7
//Description: Difference in the # of crimes related to MARIJUANA between 2005 and 2017
MATCH(a:Arrest)- [:OFFENCE] -> (c:Crime)
WHERE a.date =~ '\\d{1,2}\\/\\d{1,2}\\/\\d{2}17' and c.title =~'MARIJUANA.*'
RETURN count(a)
UNION 
MATCH(a:Arrest)- [:OFFENCE] -> (c:Crime)
WHERE a.date =~ '\\d{1,2}\\/\\d{1,2}\\/\\d{2}10' and c.title =~'MARIJUANA.*'
RETURN count(a)

//Query 8
//Description: "RESISTING ARREST" crimes sorted by race of perpetrator (looking at police brutality potentially)
MATCH (c:Crime{title:"RESISTING ARREST"})
MATCH(p:PersonTrait)
WITH p as p, size((c)<--()-->(p)) as rcount
RETURN p.race, p.sex, p.age, rcount
ORDER BY rcount DESC

//query 9
//description: Comparing top 3 crime for men vs women
MATCH (c:Crime)<-[:OFFENCE]-(a: Arrest)-[:COMMITED_BY]->(p:PersonTrait{sex:"M"})
WITH c.title as title, p.sex as p
RETURN distinct title, count(p)
ORDER BY count(p) DESC LIMIT 3
UNION
MATCH (c:Crime)<-[:OFFENCE]-(a: Arrest)-[:COMMITED_BY]->(p:PersonTrait{sex:"F"})
WITH c.title as title, p.sex as p
RETURN distinct title, count(p)
ORDER BY count(p) DESC LIMIT 3
 
//query 10
//description: Crime on Obama's election day vs Trump's
MATCH (a:Arrest)
WITH distinct a.date as date, count(distinct a.key) as keyCount
WHERE date = '11/08/2016'
RETURN avg(keyCount)
UNION 
MATCH (a:Arrest)
WITH distinct a.date as date, count(distinct a.key) as keyCount
WHERE date ='11/04/2008'
RETURN avg(keyCount)