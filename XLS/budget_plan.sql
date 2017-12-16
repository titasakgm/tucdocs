--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: budget_plan; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE budget_plan (
    id integer NOT NULL,
    project_code character varying,
    project_name character varying,
    budget_approved double precision,
    cash_on_hand double precision,
    carry_over double precision,
    newly_purpose double precision,
    fiscal_year character varying,
    personnel double precision,
    fringe_benefit double precision,
    travel double precision,
    equipment double precision,
    supplies double precision,
    contractual double precision,
    construction double precision,
    other double precision
);


ALTER TABLE public.budget_plan OWNER TO admin;

--
-- Name: budget_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE budget_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.budget_plan_id_seq OWNER TO admin;

--
-- Name: budget_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE budget_plan_id_seq OWNED BY budget_plan.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY budget_plan ALTER COLUMN id SET DEFAULT nextval('budget_plan_id_seq'::regclass);


--
-- PostgreSQL database dump complete
--

