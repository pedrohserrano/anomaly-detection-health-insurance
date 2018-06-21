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


// generate the pre-2.2 META-graph  
MATCH (a)-[r]->(b)
WITH labels(a) AS a_labels,type(r) AS rel_type,labels(b) AS b_labels
UNWIND a_labels as l  
UNWIND b_labels as l2  
MERGE (a:Node:Meta {name:l})  
MERGE (b:Node:Meta {name:l2})  
MERGE (a)-[:OUTGOING]->(:Relationship:Meta {name:rel_type})-[:INCOMING]->(b)  
RETURN distinct l as first_node, rel_type as connected_by, l2 as second_node  


MATCH (h)<-[pwh:Work]-(p)<-[ihp:Has]-(i)-[iht:Has]->(t)-[tha:Has]->(a)-[awo:Work]->(o)
WITH labels(i) AS Insured, 
labels(t) AS Titular,
labels(a) AS Agent,
labels(o) AS Office,
labels(p) AS physician,
labels(h) AS hospital,
type(pwh) AS p_work_h,
type(ihp) AS i_has_p,
type(iht) AS i_has_t,
type(tha) AS t_has_a,
type(awo) AS a_work_o
UNWIND Titular as l1
UNWIND Agent as l2
UNWIND Office as l3
UNWIND physician as l4
UNWIND hospital as l5
MERGE (i:Node:Meta {name:l1})
MERGE (a:Node:Meta {name:l2})
MERGE (o:Node:Meta {name:l3})
MERGE (p:Node:Meta {name:l4})
MERGE (h:Node:Meta {name:l5})
MERGE (h)<-[:Work]-(p)<-[:Has]-(i)-[:Has]->(t)-[:Has]->(a)-[:Work]->(o)
RETURN distinct l1 as Titular, l2 as Agent, l3 as Office, l4 as physician, l5 as hospital, p_work_h, i_has_p, i_has_t, t_has_a, a_work_o

