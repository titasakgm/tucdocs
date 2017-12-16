DROP TABLE IF EXISTS budget_plan;

CREATE TABLE budget_plan (
  id serial,
  project_code varchar,
  project_name varchar,
  budget_approved float,
  cash_on_hand float,
  carry_over float,
  newly_purpose float,
  fiscal_year varchar,
  personnel float,
  fringe_benefit float,
  travel float,
  equipment float,
  supplies float,
  contractual float,
  construction float,
  other float
);
