
-- criação da tabela com os dados do automóvel
CREATE TABLE automovel (
placa CHAR(7),
chassi CHAR(17),
cor TEXT,
veiculo TEXT,
renavam CHAR(11),
ano INTEGER,
cpf_dono INTEGER
);
-- criaçao da tabela com os dados do segurado
CREATE TABLE segurado (
nome TEXT,
cpf INTEGER,
data_de_nascimento DATE,
sexo VARCHAR(9),
estado_civil VARCHAR(10),
celular INTEGER,
email TEXT,
endereço TEXT,
placa CHAR(7)
);

-- criação da tabela perito com informações básicas
CREATE TABLE perito (
nome TEXT,
cpf INTEGER
);

-- criação da tabela oficina com informações básicas
CREATE TABLE oficina (
nome TEXT,
cnpj INTEGER,
endereço TEXT
);

-- criação da tabela seguro com os dados referentes ao seguro
CREATE TABLE seguro (
id_veiculo CHAR(7),
data_inicio DATE,
fim_da_vigencia DATE,
coberturas TEXT,
valor_do_veiculo NUMERIC,
uso_do_veiculo TEXT,
no_apolice INTEGER
);

-- criação da tabel com os dados do automovel e itens analisados durante a perícia
CREATE TABLE pericia (
id_pericia INTEGER,
id_veiculo CHAR(7),
id_sinistro INTEGER,
farois TEXT,
espelhos_retrovisores TEXT,
limpadores_de_para_brisa TEXT,
itens_de_segurança TEXT,
pneus TEXT,
itens_de_identificacao TEXT,
buzina TEXT,
vidros TEXT,
blindagem TEXT,
suspensao TEXT
);

-- criação da tabela com os dados do reparo
CREATE TABLE reparo (
data DATE,
oficina TEXT,
id_veiculo CHAR(7),
Id_pericia INTEGER,
no_apolice INTEGER,
itens_a_reparar TEXT,
valor_reparo NUMERIC
);

CREATE TABLE sinistro (
data DATE,
cpf_dono INTEGER,
Placa_veiculo CHAR(7),
classificaçao VARCHAR(7),
descricao TEXT,
Id_sinistro SERIAL
);

-- adição da placa como chave primária 
ALTER TABLE automovel ADD PRIMARY KEY (placa);
-- adição do cpf como chave primária
ALTER TABLE segurado ADD PRIMARY KEY (cpf);
-- adição do cpf como chave primária
ALTER TABLE perito ADD PRIMARY KEY (cpf);

-- adição do CNPJ como chave primária
ALTER TABLE oficina ADD PRIMARY KEY (cnpj);

-- adição do numero da apólice como chave primária
ALTER TABLE seguro ADD PRIMARY KEY (no_apolice);

-- adição do id da perícia como chave primária
ALTER TABLE pericia ADD PRIMARY KEY (id_pericia);
-- adição da coluna id_reparo para ser usada como chave primária
ALTER TABLE reparo ADD COLUMN id_reparo SERIAL;
-- adição do id do reparo como chave primária
ALTER TABLE reparo ADD PRIMARY KEY (id_reparo);

-- renomeando o id_sinistro pra corrigir o nome
ALTER TABLE sinistro RENAME COLUMN Id_sinistro TO id_sinitro;
ALTER TABLE sinistro RENAME COLUMN id_sinitro TO id_sinistro;

-- adição do id do sinistro como chave primária
ALTER TABLE sinistro ADD PRIMARY KEY (id_sinistro);

-- mudança do nome do atributo para uniformizar o atributo placa_veiculo;
ALTER TABLE automovel RENAME COLUMN placa TO placa_veiculo;
ALTER TABLE segurado RENAME COLUMN placa TO placa_veiculo;
ALTER TABLE seguro RENAME COLUMN id_veiculo TO placa_veiculo;
ALTER TABLE pericia RENAME COLUMN id_veiculo TO placa_veiculo;
ALTER TABLE reparo RENAME COLUMN id_veiculo TO placa_veiculo;

-- adição das chaves estrangeiras 
ALTER TABLE automovel ADD CONSTRAINT automovel_cpf_dono_fkey FOREIGN KEY (cpf_dono) REFERENCES segurado (cpf);
ALTER TABLE segurado ADD CONSTRAINT segurado_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo);
ALTER TABLE seguro ADD CONSTRAINT seguro_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo);
ALTER TABLE pericia ADD CONSTRAINT pericia_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo);
ALTER TABLE pericia ADD CONSTRAINT pericia_id_sinistro_fkey FOREIGN KEY (id_sinistro) REFERENCES  sinistro (id_sinistro);
ALTER TABLE reparo ADD CONSTRAINT reparo_no_apolice_fkey FOREIGN KEY (no_apolice) REFERENCES  seguro (no_apolice);
ALTER TABLE sinistro ADD CONSTRAINT sinistro_cpf_dono_fkey FOREIGN KEY (cpf_dono) REFERENCES  segurado (cpf);
ALTER TABLE sinistro ADD CONSTRAINT sinistro_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES  automovel (placa_veiculo);

-- passo 6: remoção das tabelas, com uso de cascade em uma das tabelas
DROP TABLE oficina;
DROP TABLE perito;
DROP TABLE reparo;
DROP TABLE seguro;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE segurado CASCADE;
DROP TABLE automovel;


-- passo 8: criação das novas tabelas implementando os comandos NOT NULL, PRIMARY KEY E FOREIGN KEY
CREATE TABLE automovel (
placa_veiculo CHAR(7) NOT NULL,
chassi CHAR(17) NOT NULL,
cor TEXT,
veiculo TEXT,
renavam CHAR(11) NOT NULL,
ano INTEGER,
cpf_dono CHAR(11) NOT NULL,
CONSTRAINT automovel_pkey PRIMARY KEY (placa_veiculo)
);

CREATE TABLE segurado (
nome TEXT,
cpf CHAR(11) NOT NULL,
cnh CHAR(10) NOT NULL,
data_de_nascimento DATE NOT NULL,
sexo VARCHAR(9),
estado_civil VARCHAR(10),
celular INTEGER NOT NULL,
email TEXT,
endereço TEXT,
placa_veiculo CHAR(7) NOT NULL,
CONSTRAINT segurado_pkey PRIMARY KEY (cpf),
CONSTRAINT segurado_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel(placa_veiculo)
);

CREATE TABLE perito (
nome TEXT NOT NULL,
cpf CHAR(11) NOT NULL,
CONSTRAINT perito_pkey PRIMARY KEY (cpf)
);

CREATE TABLE oficina (
nome TEXT NOT NULL,
cnpj CHAR(14) NOT NULL,
endereço TEXT,
CONSTRAINT oficina_pkey PRIMARY KEY (cnpj)
);

CREATE TABLE seguro (
placa_veiculo CHAR(7) NOT NULL, 
data_inicio DATE NOT NULL,
fim_da_vigencia DATE NOT NULL,
coberturas TEXT,
valor_do_veiculo NUMERIC NOT NULL,
uso_do_veiculo TEXT,
no_apolice SERIAL NOT NULL,
CONSTRAINT seguro_pkey PRIMARY KEY (no_apolice),
CONSTRAINT seguro_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo)
);

CREATE TABLE sinistro (
id_sinistro SERIAL NOT NULL,
data DATE NOT NULL,
cpf_dono CHAR(11) NOT NULL,
placa_veiculo CHAR(7) NOT NULL,
classificaçao VARCHAR(7),
descricao TEXT NOT NULL,
CONSTRAINT sinistro_pkey PRIMARY KEY (id_sinistro),
CONSTRAINT sinistro_cpf_dono_fkey FOREIGN KEY (cpf_dono) REFERENCES segurado (cpf),
CONSTRAINT sinistro_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo)
);

CREATE TABLE pericia (
id_pericia SERIAL NOT NULL,
placa_veiculo CHAR(7) NOT NULL,
id_sinistro INTEGER NOT NULL,
farois TEXT,
espelhos_retrovisores TEXT,
limpadores_de_para_brisa TEXT,
itens_de_segurança TEXT,
pneus TEXT,
itens_de_identificacao TEXT,
buzina TEXT,
vidros TEXT,
blindagem TEXT,
suspensao TEXT,
CONSTRAINT pericia_pkey PRIMARY KEY (id_pericia),
CONSTRAINT pericia_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo),
CONSTRAINT pericia_id_sinistro_fkey FOREIGN KEY (id_sinistro) REFERENCES sinistro (id_sinistro)
);

CREATE TABLE reparo (
id_reparo SERIAL NOT NULL,
data DATE,
oficina_cnpj CHAR(14),
placa_veiculo CHAR(7) NOT NULL,
id_pericia INTEGER NOT NULL,
no_apolice INTEGER NOT NULL,
itens_a_reparar TEXT,
valor_reparo NUMERIC NOT NULL,
CONSTRAINT reparo_pkey PRIMARY KEY (id_reparo),
CONSTRAINT reparo_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo),
CONSTRAINT reparo_id_pericia_fkey FOREIGN KEY (id_pericia) REFERENCES pericia (id_pericia),
CONSTRAINT reparo_no_apolice_fkey FOREIGN KEY (no_apolice) REFERENCES seguro (no_apolice),
CONSTRAINT reparo_oficina_cnpj FOREIGN KEY (oficina_cnpj) REFERENCES oficina (cnpj)
);

-- remoção das tabelas
DROP TABLE perito;
DROP TABLE reparo;
DROP TABLE oficina;
DROP TABLE seguro;
DROP TABLE pericia;
DROP TABLE sinistro;
DROP TABLE segurado; 
DROP TABLE automovel;

-- passo 10: adicionaria uma tabela com os dados da apolice anterior, que traz a informação importante se houve sinistro anterior ou não.
-- Recriação do banco com a adição da nova tabela.

CREATE TABLE automovel (
placa_veiculo CHAR(7) NOT NULL,
chassi CHAR(17) NOT NULL,
cor TEXT,
veiculo TEXT,
renavam CHAR(11) NOT NULL,
ano INTEGER,
cpf_dono CHAR(11) NOT NULL,
CONSTRAINT automovel_pkey PRIMARY KEY (placa_veiculo)
);

CREATE TABLE segurado (
nome TEXT,
cpf CHAR(11) NOT NULL,
cnh CHAR(10) NOT NULL,
data_de_nascimento DATE NOT NULL,
sexo VARCHAR(9),
estado_civil VARCHAR(10),
celular INTEGER NOT NULL,
email TEXT,
endereço TEXT,
placa_veiculo CHAR(7) NOT NULL,
CONSTRAINT segurado_pkey PRIMARY KEY (cpf),
CONSTRAINT segurado_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel(placa_veiculo)
);

CREATE TABLE perito (
nome TEXT NOT NULL,
cpf CHAR(11) NOT NULL,
CONSTRAINT perito_pkey PRIMARY KEY (cpf)
);

CREATE TABLE oficina (
nome TEXT NOT NULL,
cnpj CHAR(14) NOT NULL,
endereço TEXT,
CONSTRAINT oficina_pkey PRIMARY KEY (cnpj)
);

CREATE TABLE apolice_anterior (
id_apolice_ant INTEGER NOT NULL,
cia_anterior TEXT NOT NULL,
fim_vigencia_ant DATE NOT NULL,
sinistro_apolice_anterior CHAR(3) NOT NULL,
CONSTRAINT apolice_anterior_pkey PRIMARY KEY (sinistro_apolice_anterior)
);

CREATE TABLE seguro (
placa_veiculo CHAR(7) NOT NULL, 
data_inicio DATE NOT NULL,
fim_da_vigencia DATE NOT NULL,
coberturas TEXT,
valor_do_veiculo NUMERIC NOT NULL,
uso_do_veiculo TEXT,
no_apolice SERIAL NOT NULL,
sinistro_ant CHAR(3) NOT NULL,
CONSTRAINT seguro_pkey PRIMARY KEY (no_apolice),
CONSTRAINT seguro_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo),
CONSTRAINT seguro_sinistro_ant_fkey FOREIGN KEY (sinistro_ant) REFERENCES apolice_anterior (sinistro_apolice_anterior)
);

CREATE TABLE sinistro (
id_sinistro SERIAL NOT NULL,
data DATE NOT NULL,
cpf_dono CHAR(11) NOT NULL,
placa_veiculo CHAR(7) NOT NULL,
classificaçao VARCHAR(7),
descricao TEXT NOT NULL,
CONSTRAINT sinistro_pkey PRIMARY KEY (id_sinistro),
CONSTRAINT sinistro_cpf_dono_fkey FOREIGN KEY (cpf_dono) REFERENCES segurado (cpf),
CONSTRAINT sinistro_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo)
);

CREATE TABLE pericia (
id_pericia SERIAL NOT NULL,
placa_veiculo CHAR(7) NOT NULL,
id_sinistro INTEGER NOT NULL,
farois TEXT,
espelhos_retrovisores TEXT,
limpadores_de_para_brisa TEXT,
itens_de_segurança TEXT,
pneus TEXT,
itens_de_identificacao TEXT,
buzina TEXT,
vidros TEXT,
blindagem TEXT,
suspensao TEXT,
CONSTRAINT pericia_pkey PRIMARY KEY (id_pericia),
CONSTRAINT pericia_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo),
CONSTRAINT pericia_id_sinistro_fkey FOREIGN KEY (id_sinistro) REFERENCES sinistro (id_sinistro)
);

CREATE TABLE reparo (
id_reparo SERIAL NOT NULL,
data DATE,
oficina_cnpj CHAR(14),
placa_veiculo CHAR(7) NOT NULL,
id_pericia INTEGER NOT NULL,
no_apolice INTEGER NOT NULL,
itens_a_reparar TEXT,
valor_reparo NUMERIC NOT NULL,
CONSTRAINT reparo_pkey PRIMARY KEY (id_reparo),
CONSTRAINT reparo_placa_veiculo_fkey FOREIGN KEY (placa_veiculo) REFERENCES automovel (placa_veiculo),
CONSTRAINT reparo_id_pericia_fkey FOREIGN KEY (id_pericia) REFERENCES pericia (id_pericia),
CONSTRAINT reparo_no_apolice_fkey FOREIGN KEY (no_apolice) REFERENCES seguro (no_apolice),
CONSTRAINT reparo_oficina_cnpj FOREIGN KEY (oficina_cnpj) REFERENCES oficina (cnpj)
);



