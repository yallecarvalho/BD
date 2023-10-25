--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3 (Debian 15.3-1.pgdg120+1)
-- Dumped by pg_dump version 15.4 (Ubuntu 15.4-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.venda_itens DROP CONSTRAINT venda_itens_id_venda_fkey;
ALTER TABLE ONLY public.venda_itens DROP CONSTRAINT venda_itens_id_medicamento_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_func_cpf_func_funcao_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_cpf_cliente_fkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacia_gerente_fkey;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_id_venda_fkey;
ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT unico_se_sede;
ALTER TABLE ONLY public.medicamento DROP CONSTRAINT medicamento_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_pkey;
ALTER TABLE ONLY public.funcionarios DROP CONSTRAINT funcionarios_cpf_funcao_key;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_pkey;
ALTER TABLE ONLY public.farmacias DROP CONSTRAINT farmacias_bairro_key;
ALTER TABLE ONLY public.entregas DROP CONSTRAINT entregas_pkey;
ALTER TABLE ONLY public.clientes DROP CONSTRAINT clientes_pkey;
ALTER TABLE ONLY public.cliente_endereco DROP CONSTRAINT cliente_endereco_pkey;
ALTER TABLE public.venda ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.medicamento ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.farmacias ALTER COLUMN id DROP DEFAULT;
DROP TABLE public.venda_itens;
DROP SEQUENCE public.venda_id_seq;
DROP TABLE public.venda;
DROP SEQUENCE public.medicamento_id_seq;
DROP TABLE public.medicamento;
DROP TABLE public.funcionarios;
DROP SEQUENCE public.farmacias_id_seq;
DROP TABLE public.farmacias;
DROP TABLE public.entregas;
DROP TABLE public.clientes;
DROP TABLE public.cliente_endereco;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cliente_endereco; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.cliente_endereco (
    cpf_cliente character(11) NOT NULL,
    endereco character varying(80) NOT NULL,
    tipo_endereco character(1) NOT NULL,
    CONSTRAINT cliente_endereco_tipo_endereco_check CHECK ((tipo_endereco = ANY (ARRAY['R'::bpchar, 'T'::bpchar, 'O'::bpchar])))
);


ALTER TABLE public.cliente_endereco OWNER TO yallecvdc;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.clientes (
    nome character varying(40) NOT NULL,
    cpf character(11) NOT NULL,
    data_de_nasc date NOT NULL,
    CONSTRAINT clientes_chk_idade CHECK ((age((data_de_nasc)::timestamp without time zone) >= '18 years'::interval))
);


ALTER TABLE public.clientes OWNER TO yallecvdc;

--
-- Name: entregas; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.entregas (
    cpf_cliente character(11) NOT NULL,
    id_venda integer NOT NULL,
    endereco character varying(80)
);


ALTER TABLE public.entregas OWNER TO yallecvdc;

--
-- Name: farmacias; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.farmacias (
    id integer NOT NULL,
    categoria character(1) NOT NULL,
    bairro character varying(20) NOT NULL,
    cidade character varying(15) NOT NULL,
    gerente_cpf character(11) NOT NULL,
    gerente_funcao character(1) NOT NULL,
    estado public.estado NOT NULL,
    CONSTRAINT farmacias_categoria_check CHECK ((categoria = ANY (ARRAY['S'::bpchar, 'F'::bpchar]))),
    CONSTRAINT farmacias_chk_gerente_valido CHECK ((gerente_funcao = ANY (ARRAY['A'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.farmacias OWNER TO yallecvdc;

--
-- Name: farmacias_id_seq; Type: SEQUENCE; Schema: public; Owner: yallecvdc
--

CREATE SEQUENCE public.farmacias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.farmacias_id_seq OWNER TO yallecvdc;

--
-- Name: farmacias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yallecvdc
--

ALTER SEQUENCE public.farmacias_id_seq OWNED BY public.farmacias.id;


--
-- Name: funcionarios; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.funcionarios (
    nome character varying(40) NOT NULL,
    cpf character(11) NOT NULL,
    funcao character(1) NOT NULL,
    id_farmacia integer,
    CONSTRAINT funcao_valida_chk CHECK ((funcao = ANY (ARRAY['F'::bpchar, 'V'::bpchar, 'E'::bpchar, 'C'::bpchar, 'A'::bpchar])))
);


ALTER TABLE public.funcionarios OWNER TO yallecvdc;

--
-- Name: medicamento; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.medicamento (
    id integer NOT NULL,
    nome character varying(30) NOT NULL,
    com_receita character(1) NOT NULL,
    CONSTRAINT medicamento_com_receita_check CHECK ((com_receita = ANY (ARRAY['S'::bpchar, 'N'::bpchar])))
);


ALTER TABLE public.medicamento OWNER TO yallecvdc;

--
-- Name: medicamento_id_seq; Type: SEQUENCE; Schema: public; Owner: yallecvdc
--

CREATE SEQUENCE public.medicamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicamento_id_seq OWNER TO yallecvdc;

--
-- Name: medicamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yallecvdc
--

ALTER SEQUENCE public.medicamento_id_seq OWNED BY public.medicamento.id;


--
-- Name: venda; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.venda (
    id integer NOT NULL,
    no_itens integer NOT NULL,
    entrega character(1),
    func_cpf character(11) NOT NULL,
    func_funcao character(1),
    cpf_cliente character(11),
    valor_total numeric,
    com_receita character(1) NOT NULL,
    CONSTRAINT venda_chk_com_receita CHECK (((com_receita = 'N'::bpchar) OR ((com_receita = 'S'::bpchar) AND (cpf_cliente IS NOT NULL)))),
    CONSTRAINT venda_chk_func_vendedor CHECK ((func_funcao = 'V'::bpchar)),
    CONSTRAINT venda_chk_valida CHECK (((entrega = 'N'::bpchar) OR ((entrega = 'S'::bpchar) AND (cpf_cliente IS NOT NULL)))),
    CONSTRAINT venda_entrega_check CHECK ((entrega = ANY (ARRAY['S'::bpchar, 'N'::bpchar])))
);


ALTER TABLE public.venda OWNER TO yallecvdc;

--
-- Name: venda_id_seq; Type: SEQUENCE; Schema: public; Owner: yallecvdc
--

CREATE SEQUENCE public.venda_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.venda_id_seq OWNER TO yallecvdc;

--
-- Name: venda_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: yallecvdc
--

ALTER SEQUENCE public.venda_id_seq OWNED BY public.venda.id;


--
-- Name: venda_itens; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.venda_itens (
    id_medicamento integer NOT NULL,
    id_venda integer NOT NULL,
    valor numeric NOT NULL
);


ALTER TABLE public.venda_itens OWNER TO yallecvdc;

--
-- Name: farmacias id; Type: DEFAULT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.farmacias ALTER COLUMN id SET DEFAULT nextval('public.farmacias_id_seq'::regclass);


--
-- Name: medicamento id; Type: DEFAULT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.medicamento ALTER COLUMN id SET DEFAULT nextval('public.medicamento_id_seq'::regclass);


--
-- Name: venda id; Type: DEFAULT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.venda ALTER COLUMN id SET DEFAULT nextval('public.venda_id_seq'::regclass);


--
-- Data for Name: cliente_endereco; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--



--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--



--
-- Data for Name: entregas; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--



--
-- Data for Name: farmacias; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--



--
-- Data for Name: funcionarios; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--



--
-- Data for Name: medicamento; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--



--
-- Data for Name: venda; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--



--
-- Data for Name: venda_itens; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--



--
-- Name: farmacias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yallecvdc
--

SELECT pg_catalog.setval('public.farmacias_id_seq', 2, true);


--
-- Name: medicamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yallecvdc
--

SELECT pg_catalog.setval('public.medicamento_id_seq', 5, true);


--
-- Name: venda_id_seq; Type: SEQUENCE SET; Schema: public; Owner: yallecvdc
--

SELECT pg_catalog.setval('public.venda_id_seq', 4, true);


--
-- Name: cliente_endereco cliente_endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.cliente_endereco
    ADD CONSTRAINT cliente_endereco_pkey PRIMARY KEY (cpf_cliente, endereco);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (cpf);


--
-- Name: entregas entregas_pkey; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_pkey PRIMARY KEY (cpf_cliente, id_venda);


--
-- Name: farmacias farmacias_bairro_key; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_bairro_key UNIQUE (bairro);


--
-- Name: farmacias farmacias_pkey; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacias_pkey PRIMARY KEY (id);


--
-- Name: funcionarios funcionarios_cpf_funcao_key; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_cpf_funcao_key UNIQUE (cpf, funcao);


--
-- Name: funcionarios funcionarios_pkey; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (cpf);


--
-- Name: medicamento medicamento_pkey; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.medicamento
    ADD CONSTRAINT medicamento_pkey PRIMARY KEY (id);


--
-- Name: farmacias unico_se_sede; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT unico_se_sede EXCLUDE USING gist (categoria WITH =) WHERE ((categoria = 'S'::bpchar));


--
-- Name: venda venda_pkey; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id);


--
-- Name: entregas entregas_id_venda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.entregas
    ADD CONSTRAINT entregas_id_venda_fkey FOREIGN KEY (id_venda) REFERENCES public.venda(id);


--
-- Name: farmacias farmacia_gerente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.farmacias
    ADD CONSTRAINT farmacia_gerente_fkey FOREIGN KEY (gerente_cpf, gerente_funcao) REFERENCES public.funcionarios(cpf, funcao);


--
-- Name: venda venda_cpf_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_cpf_cliente_fkey FOREIGN KEY (cpf_cliente) REFERENCES public.clientes(cpf);


--
-- Name: venda venda_func_cpf_func_funcao_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_func_cpf_func_funcao_fkey FOREIGN KEY (func_cpf, func_funcao) REFERENCES public.funcionarios(cpf, funcao) ON DELETE RESTRICT;


--
-- Name: venda_itens venda_itens_id_medicamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT venda_itens_id_medicamento_fkey FOREIGN KEY (id_medicamento) REFERENCES public.medicamento(id) ON DELETE RESTRICT;


--
-- Name: venda_itens venda_itens_id_venda_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.venda_itens
    ADD CONSTRAINT venda_itens_id_venda_fkey FOREIGN KEY (id_venda) REFERENCES public.venda(id);


--
-- PostgreSQL database dump complete
--
-- COMANDOS ADICIONAIS
--

-- devem ser inseridos com sucesso
-- INSERT INTO funcionarios VALUES ('joao', '1234566789', 'A',  null);
-- INSERT INTO funcionarios VALUES ('maria', '1234566780', 'F', '1');
-- INSERT INTO funcionarios VALUES ('ednardo', '1234563456', 'F', '2');
-- INSERT INTO funcionarios VALUES('elis', '12345676780', 'C', null);
-- INSERT INTO funcionarios VALUES ('lais', '1234566743', 'V',  null);
-- INSERT INTO farmacias (categoria, bairro, cidade, gerente_cpf, gerente_funcao, estado) VALUES ('F', 'Catole', 'Campina Grande', '1234566789', 'A', 'PB');
-- INSERT INTO farmacias (categoria, bairro, cidade, gerente_cpf, gerente_funcao, estado) VALUES ('S', 'Centro', 'Campina Grande', '1234566780', 'F', 'PB');
-- INSERT INTO clientes VALUES ('slash', '12345678910', '1995-08-19');
-- INSERT INTO clientes VALUES ('myles kennedy', '12345678911', '1990-07-10);
-- INSERT INTO cliente_endereco VALUES('12345678910', 'rua jose da silva, 115, centro, campina grande', 'T');
-- INSERT INTO cliente_endereco VALUES('12345678910', 'rua vigario calixto, 315, catole, campina grande', 'R');
-- INSERT INTO medicamento  VALUES (2, 'nasonex', 'N');
-- INSERT INTO medicamento (nome, com_receita) VALUES ('ritalina', 'S');
-- INSERT INTO venda  VALUES (2, 1, 'N', '1234566743', 'V', '10', 'N'); 
-- INSERT INTO venda VALUES (3, 2, 'S', '1234566743', 'V','12345678910', 60, 'N'); 
-- INSERT INTO venda_itens VALUES (2, 2, 10);

-- Devem retornar com erro:

-- Retorna erro pois as funções inseridas não são válidas
-- INSERT INTO funcionarios VALUES('elis', '12345676780', 'T', '2'); 
-- INSERT INTO funcionarios VALUES('elis', '12345676780', 'Z', null); 

-- Retorna erro pois MG não entra nos estados permitidos
-- INSERT INTO farmacias (categoria, bairro, cidade, gerente_cpf, gerente_funcao, estado) VALUES ('F', 'Centro', 'Campo Grande', '1234566780', 'A', 'MG');  
-- Retorna erro pois só pode existir uma sede.
-- INSERT INTO farmacias (categoria, bairro, cidade, gerente_cpf, gerente_funcao, estado) VALUES ('S', 'Itararé', 'Campina Grande', '1234563456', 'F', 'PB'); 
-- Retorna erro pois o bairro deve ser o único
-- INSERT INTO farmacias VALUES (3, 'F', 'Centro', 'Campina Grande', '12345676780', 'F', 'PB'); 

-- Retorna erro porque os clientes tem menos de 18 anos
-- INSERT INTO clientes VALUES ('slash', '12345678910', '2007-08-19');
-- INSERT INTO clientes VALUES ('axl rose', '1234567811', '2006-05-20);

-- Retorna erro porque são tipos inválidos de endereço.
-- INSERT INTO cliente_endereco VALUES('12345678910', 'rua jose da silva, 115, centro, campina grande', 'R');
-- INSERT INTO cliente_endereco VALUES('12345678910', 'rua epitacio pessoa, 1230', 'C');

-- Retorna erro pois precisa ser determinado se o remédio é vendido com receita ou não
-- INSERT INTO medicamento (nome, com_receita) VALUES ('novalgina', null);
-- Retorna erro porque 'T' é uma entrada inválida para 'com_receita'
-- INSERT INTO medicamento (nome, com_receita) VALUES ('maresis', 'T');

-- Retorna erro porque só quem pode realizar uma venda é um funcionário vendedor ('V')
-- NSERT INTO venda VALUES (2, 'S', '1234566789', 'A', 60, 'N'); 
-- Retorna erro porque precisa do cpf do cliente para vendas com entrega
-- INSERT INTO venda (no_itens, entrega, func_cpf, func_funcao, valor_total, com_receita) VALUES (2, 'S', '1234566743', 'V', 60, 'N'); 

-- Retorna erro pois o medicamento está vinculado a uma venda
-- DELETE FROM medicamento WHERE nome = 'nasonex'; 
-- Retorna erro pois o funcionário está vinculado a uma venda
-- DELETE FROM funcionarios WHERE cpf = '1234566743'; - da erro
