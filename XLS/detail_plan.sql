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
-- Name: detail_plan; Type: TABLE; Schema: public; Owner: admin; Tablespace: 
--

CREATE TABLE detail_plan (
    id integer NOT NULL,
    budget_plan_id integer,
    object_class_id integer,
    item integer,
    description character varying,
    original_budget double precision,
    amend_order integer,
    amend_budget double precision,
    fiscal_year character varying,
    q1_sep double precision,
    q1_oct double precision,
    q1_nov double precision,
    q1_total double precision,
    q2_dec double precision,
    q2_jan double precision,
    q2_feb double precision,
    q2_total double precision,
    q3_mar double precision,
    q3_apr double precision,
    q3_may double precision,
    q3_total double precision,
    q4_jun double precision,
    q4_jul double precision,
    q4_aug double precision,
    q4_total double precision,
    total_expenses double precision,
    balance double precision
);


ALTER TABLE public.detail_plan OWNER TO admin;

--
-- Name: detail_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE detail_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.detail_plan_id_seq OWNER TO admin;

--
-- Name: detail_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE detail_plan_id_seq OWNED BY detail_plan.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY detail_plan ALTER COLUMN id SET DEFAULT nextval('detail_plan_id_seq'::regclass);


--
-- PostgreSQL database dump complete
--

