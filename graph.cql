///////////////Defining the Graph///////////////


//Loading table 
LOAD CSV WITH HEADERS FROM "file:///nodes-relations1.csv" AS table

//Defining vertex
MERGE (s:Sinister {Id: table.NSINIEST})
MERGE (t:Titular {Name: table.POLICY_NAME})
MERGE (i:Insured {Name: table.INSURED_NAME})
MERGE (a:Agent {Id: table.AGENT_ID})
MERGE (o:Office {Id: table.OFFICE_ID})
MERGE (p:physician {Name: table.PHISYCIAN})
MERGE (h:hospital {Name: table.HOSP_ID})

//Defining edges
MERGE (i)-[:Suffer]->(s)
MERGE (i)-[:Has]->(t)
MERGE (t)-[:Has]->(a)
MERGE (a)-[:Work]->(o)
MERGE (i)-[:Has]->(p)
MERGE (p)-[:Work]->(h)


//"NSINIEST","DATE_SIN","POLICY_NAME","INSURED_NAME","AGENT_ID","OFFICE_ID","OFFICE_NAME","PHISYCIAN","HOSP_ID","HOSP_NAME","DICTAMIN"

//Show up all relations
MATCH (h)<-[:Work]-(p)<-[:Has]-(i)-[:Has]->(t)-[:Has]->(a)-[:Work]->(o) RETURN h,p,i,t,a,o


/Show up all edges which have move_to relation ordered
MATCH (n:Zone)-[:Move_to*]->(m:Zone)
RETURN n, m
ORDER BY n.Crime DESC, n.Offenders DESC
LIMIT 10
//En el documento se muestran los 5 distintos