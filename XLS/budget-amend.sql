DROP TABLE IF EXISTS budget_amend;

CREATE TABLE budget_amend (
  id serial,
  project_id varchar,
  coagyear varchar,
  object_class_id integer,
  item_no integer,
  amend_no integer,
  total float,
  date_created date,
  date_updated date
);
