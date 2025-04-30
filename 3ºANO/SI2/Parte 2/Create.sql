CREATE TABLE desempenho_academico (
	id_desempenho		 INTEGER,
	nota_final		 INTEGER,
	frequencia		 INTEGER,
	matricula_ativa		 INTEGER,
	propina_a_pagar		 FLOAT,
	bolsa_recebida		 FLOAT,
	ano_letivo		 INTEGER,
	semestre			 INTEGER,
	cursos_id_curso		 INTEGER NOT NULL,
	disciplinas_id_disciplina INTEGER NOT NULL,
	tempo_id_tempo		 INTEGER NOT NULL,
	estudantes_id_estudante	 INTEGER NOT NULL,
	financeiro_id_financas	 INTEGER NOT NULL,
	PRIMARY KEY(id_desempenho)
);

CREATE TABLE disciplinas (
	id_disciplina	 INTEGER,
	nome_disciplina VARCHAR(512),
	semestre	 INTEGER,
	carga_horaria	 INTEGER,
	ects		 INTEGER,
	responsavel	 VARCHAR(512),
	PRIMARY KEY(id_disciplina)
);

CREATE TABLE tempo (
	id_tempo	 INTEGER,
	ano_letivo INTEGER,
	semestre	 INTEGER,
	PRIMARY KEY(id_tempo)
);

CREATE TABLE cursos (
	id_curso		 INTEGER,
	nome_curso	 VARCHAR(512),
	area_curso	 VARCHAR(512),
	duracao		 INTEGER,
	coordenador	 VARCHAR(512),
	numero_estudantes INTEGER,
	taxa_adesao	 FLOAT,
	taxa_saida	 FLOAT,
	PRIMARY KEY(id_curso)
);

CREATE TABLE financeiro (
	id_financas	 INTEGER,
	total_propinas FLOAT,
	valor_bolsa	 INTEGER,
	PRIMARY KEY(id_financas)
);

CREATE TABLE estudantes (
	id_estudante		 INTEGER,
	nome_estudante		 VARCHAR(512),
	genero			 VARCHAR(512),
	idade			 INTEGER,
	situacao_socioeconomica FLOAT,
	regime_frequencia	 VARCHAR(512),
	ano_ingresso		 INTEGER,
	residencia		 VARCHAR(512),
	PRIMARY KEY(id_estudante)
);

ALTER TABLE desempenho_academico ADD CONSTRAINT desempenho_academico_fk1 FOREIGN KEY (cursos_id_curso) REFERENCES cursos(id_curso);
ALTER TABLE desempenho_academico ADD CONSTRAINT desempenho_academico_fk2 FOREIGN KEY (disciplinas_id_disciplina) REFERENCES disciplinas(id_disciplina);
ALTER TABLE desempenho_academico ADD CONSTRAINT desempenho_academico_fk3 FOREIGN KEY (tempo_id_tempo) REFERENCES tempo(id_tempo);
ALTER TABLE desempenho_academico ADD CONSTRAINT desempenho_academico_fk4 FOREIGN KEY (estudantes_id_estudante) REFERENCES estudantes(id_estudante);
ALTER TABLE desempenho_academico ADD CONSTRAINT desempenho_academico_fk5 FOREIGN KEY (financeiro_id_financas) REFERENCES financeiro(id_financas);

