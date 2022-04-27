// light weighted
MATCH (f: fighter)-[:beats]->()
WHERE f.weight <= 155 RETURN f

// middle weighters who won at least 1 fight
MATCH (f: fighter)-[:beats]->()
WHERE 155 < f.weight < 185 RETURN f

// walter(?) weighters who won at least 1 fight
MATCH (f: fighter)-[:beats]->()
WHERE f.weight >= 185 RETURN f

// Return fighters who had 1-1 record with each other
MATCH (f1)-[:beats]->(f2)
CALL {
    WITH f1, f2
    MATCH (f2)-[:beats]->(f1)
    RETURN COUNT(*) AS lose
}
WITH f1, count(f1) AS win, lose
WHERE win=1 AND lose=1
RETURN DISTINCT f1


//Return all fighter that can “Khabib Nurmagomedov” beat them and he didn’t have a fight with them yet.
MATCH (f1: fighter {name:'Khabib Nurmagomedov'})-[:beats]->()-[:beats]->(f2)
RETURN DISTINCT f2

//Return undefeated Fighters(0 loss)
MATCH (f1)-[:beats]->()
CALL {
    WITH f1
    MATCH ()-[:beats]->(f1)
    RETURN COUNT(*) AS lose
}
WITH f1, count(f1) AS win, lose
RETURN DISTINCT
CASE WHEN lose=0 THEN f1 END as undefeated

//return all defeated
MATCH (f1)-[:beats]->()
CALL {
    WITH f1
    MATCH ()-[:beats]->(f1)
    RETURN COUNT(*) AS lose
}
WITH f1, count(f1) AS win, lose
RETURN DISTINCT
CASE WHEN win=0 THEN f1 END as defeated

//Return all fighters MMA records and create query to enter the record as a property for a fighter {name, weight, record}
MATCH (f1)-[:beats]-(f2)
SET f1.record = f1.record + [[ID(f1), ID(f2)]]
RETURN f1
