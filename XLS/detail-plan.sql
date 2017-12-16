DROP TABLE IF EXISTS detail_plan;

CREATE TABLE detail_plan (
  id serial,
  budget_plan_id integer,
  object_class_id integer,
  item integer,
  description varchar,
  original_budget float,
  amend_order integer,
  amend_budget float,
  fiscal_year varchar,
  q1_sep float,
  q1_oct float,
  q1_nov float,
  q1_total float,
  q2_dec float,
  q2_jan float,
  q2_feb float,
  q2_total float,
  q3_mar float,
  q3_apr float,
  q3_may float,
  q3_total float,
  q4_jun float,
  q4_jul float,
  q4_aug float,
  q4_total float,
  total_expenses float,
  balance float
);