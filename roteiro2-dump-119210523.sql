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

ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_func_resp_cpf_fkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_superior_cpf_fkey;
ALTER TABLE ONLY public.tarefas DROP CONSTRAINT tarefas_pkey;
ALTER TABLE ONLY public.funcionario DROP CONSTRAINT funcionario_pkey;
DROP TABLE public.tarefas;
DROP TABLE public.funcionario;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: funcionario; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.funcionario (
    cpf character(11) NOT NULL,
    data_nasc date NOT NULL,
    nome character varying(100) NOT NULL,
    funcao character varying(20) NOT NULL,
    nivel character(1) NOT NULL,
    superior_cpf character(11),
    CONSTRAINT check_supervisor CHECK ((((funcao)::text = 'SUP_LIMPEZA'::text) OR (((funcao)::text = 'Limpeza'::text) AND (superior_cpf IS NOT NULL)))),
    CONSTRAINT funcionario_funcao_check CHECK (((funcao)::text = ANY ((ARRAY['Limpeza'::character varying, 'SUP_LIMPEZA'::character varying])::text[]))),
    CONSTRAINT funcionario_nivel_check CHECK ((nivel = ANY (ARRAY['J'::bpchar, 'P'::bpchar, 'S'::bpchar])))
);


ALTER TABLE public.funcionario OWNER TO yallecvdc;

--
-- Name: tarefas; Type: TABLE; Schema: public; Owner: yallecvdc
--

CREATE TABLE public.tarefas (
    id bigint NOT NULL,
    descricao character varying(40),
    func_resp_cpf character(11),
    prioridade smallint,
    status character(1),
    CONSTRAINT tarefas_chk_cpf CHECK (((status = 'P'::bpchar) OR (func_resp_cpf IS NOT NULL))),
    CONSTRAINT tarefas_chk_prioridade_valida CHECK (((prioridade >= 0) AND (prioridade <= 5))),
    CONSTRAINT tarefas_chk_status_valido CHECK ((status = ANY (ARRAY['P'::bpchar, 'E'::bpchar, 'C'::bpchar])))
);


ALTER TABLE public.tarefas OWNER TO yallecvdc;

--
-- Data for Name: funcionario; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--

INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678911', '1980-05-07', 'Pedro da Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678912', '1980-03-08', 'Jose da Silva', 'Limpeza', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678917', '1990-07-08', 'Josue da Silva', 'Limpeza', 'P', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678920', '1990-09-10', 'Maria da Silva', 'Limpeza', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678918', '1985-10-11', 'Rosa Maria', 'Limpeza', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678921', '1995-07-28', 'Lais Silva', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678916', '1997-10-11', 'Renato Russo', 'Limpeza', 'J', '12345678921');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678923', '1990-06-21', 'Elton John', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678924', '1980-05-20', 'Freddie Mercury', 'SUP_LIMPEZA', 'S', NULL);
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678927', '1990-08-01', 'Ross Matt', 'Limpeza', 'J', '12345678924');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678930', '1995-07-10', 'Raul Seixas', 'Limpeza', 'J', '12345678924');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('12345678929', '1990-05-10', 'Rita Lee', 'Limpeza', 'J', '12345678924');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('1234567811 ', '1995-07-08', 'Maria da Silva', 'Limpeza', 'P', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232955', '1995-11-05', 'Anthony Kiedis', 'Limpeza', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('32323232911', '1996-10-05', 'Santanna Cantador', 'Limpeza', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432111', '1946-10-26', 'Belchior', 'Limpeza', 'J', '12345678911');
INSERT INTO public.funcionario (cpf, data_nasc, nome, funcao, nivel, superior_cpf) VALUES ('98765432122', '1945-04-17', 'Ednardo', 'Limpeza', 'J', '12345678911');


--
-- Data for Name: tarefas; Type: TABLE DATA; Schema: public; Owner: yallecvdc
--

INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483646, 'limpar chão do corredor central', '98765432111', 0, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483647, 'limpar janelas da sala 203', '98765432122', 1, 'C');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483648, 'limpar portas do térreo', NULL, 4, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483653, 'limpar portas do 1o andar', NULL, 2, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147484651, 'limpar portas do 1o andar', NULL, 5, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483652, 'limpar portas do 2o andar', NULL, 5, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483650, 'limpar chão do corredor central', '98765432111', 0, 'P');
INSERT INTO public.tarefas (id, descricao, func_resp_cpf, prioridade, status) VALUES (2147483656, 'limpar janelas 3ro andar', '98765432111', 0, 'E');


--
-- Name: funcionario funcionario_pkey; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_pkey PRIMARY KEY (cpf);


--
-- Name: tarefas tarefas_pkey; Type: CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_pkey PRIMARY KEY (id);


--
-- Name: funcionario funcionario_superior_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.funcionario
    ADD CONSTRAINT funcionario_superior_cpf_fkey FOREIGN KEY (superior_cpf) REFERENCES public.funcionario(cpf);


--
-- Name: tarefas tarefas_func_resp_cpf_fkey; Type: FK CONSTRAINT; Schema: public; Owner: yallecvdc
--

ALTER TABLE ONLY public.tarefas
    ADD CONSTRAINT tarefas_func_resp_cpf_fkey FOREIGN KEY (func_resp_cpf) REFERENCES public.funcionario(cpf) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

