match (n: Movie) detach delete n
match (n: Person) detach delete n

CREATE (kn: fighter {name: "Khabib Nurmagomedov", weight: 155}), (rad: fighter {name: "Rafael Dos Anjos", weight: 155}), (kn)-[:beats]->(rad)
CREATE (nm: fighter {name: "Neil Magny", weight: 170})
CREATE (jj: fighter {name: "Jon Jones", weight: 205}), (dc: fighter {name: "Daniel Cormier", weight: 205}), (jj)-[:beats]->(dc)
CREATE (mb: fighter {name: "Michael Bisping", weight: 185}), (mh: fighter {name: "Matt Hamill", weight: 185}), (mb)-[:beats]->(mh)
CREATE (bv: fighter {name: "Brandon Vera", weight: 205})
CREATE (fm: fighter {name: "Frank Mir", weight: 230})
CREATE (bl: fighter {name: "Brock Lesnar", weight: 230}), (fm)-[:beats]->(bl)
CREATE (kg: fighter {name: "Kelvin Gastelum", weight: 185}), (nm)-[:beats]->(kg)
CREATE (bv)-[:beats]->(fm),
(jj)-[:beats]->(bv),
(rad)-[:beats]->(nm),
(kg)-[:beats]->(mb),
(mb)-[:beats]->(mh),
(mb)-[:beats]->(kg),
(mh)-[:beats]->(jj)

MATCH (n) RETURN n
