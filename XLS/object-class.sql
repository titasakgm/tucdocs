DROP TABLE IF EXISTS object_class;

CREATE TABLE object_class (
  id serial,
  class_name varchar
);

INSERT INTO object_class VALUES
(1,'PERSONNEL'),
(2, 'FRINGE BENEFIT'),
(3, 'TRAVEL'),
(4, 'EQUIPMENT'),
(5, 'SUPPLIES'),
(6, 'CONTRACTUAL'),
(7, 'CONSTRUCTION'),
(8, 'OTHER');


