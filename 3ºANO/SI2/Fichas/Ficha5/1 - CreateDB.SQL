/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2022                    */
/* Created on:     20/11/2023 17:54:11                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMPANHAMARKETING') and o.name = 'FK_CAMPANHA_RELATIONS_CLIENTE')
alter table CAMPANHAMARKETING
   drop constraint FK_CAMPANHA_RELATIONS_CLIENTE
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMPANHAMARKETING') and o.name = 'FK_CAMPANHA_RELATIONS_CLASSEID')
alter table CAMPANHAMARKETING
   drop constraint FK_CAMPANHA_RELATIONS_CLASSEID
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMPANHAMARKETING') and o.name = 'FK_CAMPANHA_RELATIONS_REGIAO')
alter table CAMPANHAMARKETING
   drop constraint FK_CAMPANHA_RELATIONS_REGIAO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMPANHAMARKETING') and o.name = 'FK_CAMPANHA___CREDITOH')
alter table CAMPANHAMARKETING
   drop constraint FK_CAMPANHA___CREDITOH
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMPANHAMARKETING') and o.name = 'FK_CAMPANHA____CARRO')
alter table CAMPANHAMARKETING
   drop constraint FK_CAMPANHA____CARRO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMPANHAMARKETING') and o.name = 'FK_CAMPANHA_____TEMPO')
alter table CAMPANHAMARKETING
   drop constraint FK_CAMPANHA_____TEMPO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMPANHAMARKETING') and o.name = 'FK_CAMPANHA______CONTAORD')
alter table CAMPANHAMARKETING
   drop constraint FK_CAMPANHA______CONTAORD
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMPANHAMARKETING') and o.name = 'FK_CAMPANHA_______CONTAPRA')
alter table CAMPANHAMARKETING
   drop constraint FK_CAMPANHA_______CONTAPRA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('CAMPANHAMARKETING') and o.name = 'FK_CAMPANHA________CLASSEVE')
alter table CAMPANHAMARKETING
   drop constraint FK_CAMPANHA________CLASSEVE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CAMPANHAMARKETING')
            and   name  = '____FK'
            and   indid > 0
            and   indid < 255)
   drop index CAMPANHAMARKETING.____FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CAMPANHAMARKETING')
            and   name  = 'RELATIONSHIP_8_FK'
            and   indid > 0
            and   indid < 255)
   drop index CAMPANHAMARKETING.RELATIONSHIP_8_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CAMPANHAMARKETING')
            and   name  = '_______FK'
            and   indid > 0
            and   indid < 255)
   drop index CAMPANHAMARKETING._______FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CAMPANHAMARKETING')
            and   name  = 'RELATIONSHIP_6_FK'
            and   indid > 0
            and   indid < 255)
   drop index CAMPANHAMARKETING.RELATIONSHIP_6_FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CAMPANHAMARKETING')
            and   name  = '__FK'
            and   indid > 0
            and   indid < 255)
   drop index CAMPANHAMARKETING.__FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CAMPANHAMARKETING')
            and   name  = '______FK'
            and   indid > 0
            and   indid < 255)
   drop index CAMPANHAMARKETING.______FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CAMPANHAMARKETING')
            and   name  = '_____FK'
            and   indid > 0
            and   indid < 255)
   drop index CAMPANHAMARKETING._____FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CAMPANHAMARKETING')
            and   name  = '___FK'
            and   indid > 0
            and   indid < 255)
   drop index CAMPANHAMARKETING.___FK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('CAMPANHAMARKETING')
            and   name  = 'RELATIONSHIP_1_FK'
            and   indid > 0
            and   indid < 255)
   drop index CAMPANHAMARKETING.RELATIONSHIP_1_FK
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CAMPANHAMARKETING')
            and   type = 'U')
   drop table CAMPANHAMARKETING
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CARRO')
            and   type = 'U')
   drop table CARRO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CLASSEIDADE')
            and   type = 'U')
   drop table CLASSEIDADE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CLASSEVENCIMENTO')
            and   type = 'U')
   drop table CLASSEVENCIMENTO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CLIENTE')
            and   type = 'U')
   drop table CLIENTE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CONTAORDEM')
            and   type = 'U')
   drop table CONTAORDEM
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CONTAPRAZO')
            and   type = 'U')
   drop table CONTAPRAZO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('CREDITOHABITACAO')
            and   type = 'U')
   drop table CREDITOHABITACAO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('REGIAO')
            and   type = 'U')
   drop table REGIAO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TEMPO')
            and   type = 'U')
   drop table TEMPO
go

/*==============================================================*/
/* Table: CAMPANHAMARKETING                                     */
/*==============================================================*/
create table CAMPANHAMARKETING (
   IDCAMPANHAMERKETING  int                  not null,
   IDTEMPO              int                  not null,
   IDCLIENTE            int                  not null,
   IDCARRO              int                  not null,
   IDCONTAORDEM         int                  not null,
   IDCONTAPRAZO         int                  not null,
   IDCREDITOHABITACAO   int                  not null,
   IDCLASSEIDADE        int                  not null,
   IDCLASSEVENCIMENTO   int                  not null,
   IDREGIAO             int                  not null,
   COMPRACAMPANHAANTERIOR int                  null,
   constraint PK_CAMPANHAMARKETING primary key (IDTEMPO, IDCAMPANHAMERKETING, IDCLIENTE, IDCARRO, IDCONTAORDEM, IDCONTAPRAZO, IDCREDITOHABITACAO, IDCLASSEIDADE, IDCLASSEVENCIMENTO, IDREGIAO)
)
go

/*==============================================================*/
/* Index: RELATIONSHIP_1_FK                                     */
/*==============================================================*/




create nonclustered index RELATIONSHIP_1_FK on CAMPANHAMARKETING (IDCLIENTE ASC)
go

/*==============================================================*/
/* Index: ___FK                                                 */
/*==============================================================*/




create nonclustered index ___FK on CAMPANHAMARKETING (IDCARRO ASC)
go

/*==============================================================*/
/* Index: _____FK                                               */
/*==============================================================*/




create nonclustered index _____FK on CAMPANHAMARKETING (IDCONTAORDEM ASC)
go

/*==============================================================*/
/* Index: ______FK                                              */
/*==============================================================*/




create nonclustered index ______FK on CAMPANHAMARKETING (IDCONTAPRAZO ASC)
go

/*==============================================================*/
/* Index: __FK                                                  */
/*==============================================================*/




create nonclustered index __FK on CAMPANHAMARKETING (IDCREDITOHABITACAO ASC)
go

/*==============================================================*/
/* Index: RELATIONSHIP_6_FK                                     */
/*==============================================================*/




create nonclustered index RELATIONSHIP_6_FK on CAMPANHAMARKETING (IDCLASSEIDADE ASC)
go

/*==============================================================*/
/* Index: _______FK                                             */
/*==============================================================*/




create nonclustered index _______FK on CAMPANHAMARKETING (IDCLASSEVENCIMENTO ASC)
go

/*==============================================================*/
/* Index: RELATIONSHIP_8_FK                                     */
/*==============================================================*/




create nonclustered index RELATIONSHIP_8_FK on CAMPANHAMARKETING (IDREGIAO ASC)
go

/*==============================================================*/
/* Index: ____FK                                                */
/*==============================================================*/




create nonclustered index ____FK on CAMPANHAMARKETING (IDTEMPO ASC)
go

/*==============================================================*/
/* Table: CARRO                                                 */
/*==============================================================*/
create table CARRO (
   IDCARRO              int                  not null,
   TEMCARRO             char(256)            null,
   constraint PK_CARRO primary key (IDCARRO)
)
go

/*==============================================================*/
/* Table: CLASSEIDADE                                           */
/*==============================================================*/
create table CLASSEIDADE (
   IDCLASSEIDADE        int                  not null,
   CLASSEIDADE          char(256)            null,
   constraint PK_CLASSEIDADE primary key (IDCLASSEIDADE)
)
go

/*==============================================================*/
/* Table: CLASSEVENCIMENTO                                      */
/*==============================================================*/
create table CLASSEVENCIMENTO (
   IDCLASSEVENCIMENTO   int                  not null,
   CLASSEVENCIMENTO     char(256)            null,
   constraint PK_CLASSEVENCIMENTO primary key (IDCLASSEVENCIMENTO)
)
go

/*==============================================================*/
/* Table: CLIENTE                                               */
/*==============================================================*/
create table CLIENTE (
   IDCLIENTE            int                  not null,
   IDADE                int                  null,
   SEXO                 char(2)              null,
   VENCIMENTO           float                null,
   CASADO               char(10)             null,
   FILHOS               int                  null,
   constraint PK_CLIENTE primary key (IDCLIENTE)
)
go

/*==============================================================*/
/* Table: CONTAORDEM                                            */
/*==============================================================*/
create table CONTAORDEM (
   IDCONTAORDEM         int                  not null,
   TEMCONTAORDEM        char(256)            null,
   constraint PK_CONTAORDEM primary key (IDCONTAORDEM)
)
go

/*==============================================================*/
/* Table: CONTAPRAZO                                            */
/*==============================================================*/
create table CONTAPRAZO (
   IDCONTAPRAZO         int                  not null,
   TEMCONTAPRAZO        char(256)            null,
   constraint PK_CONTAPRAZO primary key (IDCONTAPRAZO)
)
go

/*==============================================================*/
/* Table: CREDITOHABITACAO                                      */
/*==============================================================*/
create table CREDITOHABITACAO (
   IDCREDITOHABITACAO   int                  not null,
   TEMCREDITOHABITACAO  char(256)            null,
   constraint PK_CREDITOHABITACAO primary key (IDCREDITOHABITACAO)
)
go

/*==============================================================*/
/* Table: REGIAO                                                */
/*==============================================================*/
create table REGIAO (
   IDREGIAO             int                  not null,
   REGIAO               char(256)            null,
   constraint PK_REGIAO primary key (IDREGIAO)
)
go

/*==============================================================*/
/* Table: TEMPO                                                 */
/*==============================================================*/
create table TEMPO (
   IDTEMPO              int                  not null,
   MES                  int                  null,
   ANO                  int                  null,
   constraint PK_TEMPO primary key (IDTEMPO)
)
go

alter table CAMPANHAMARKETING
   add constraint FK_CAMPANHA_RELATIONS_CLIENTE foreign key (IDCLIENTE)
      references CLIENTE (IDCLIENTE)
go

alter table CAMPANHAMARKETING
   add constraint FK_CAMPANHA_RELATIONS_CLASSEID foreign key (IDCLASSEIDADE)
      references CLASSEIDADE (IDCLASSEIDADE)
go

alter table CAMPANHAMARKETING
   add constraint FK_CAMPANHA_RELATIONS_REGIAO foreign key (IDREGIAO)
      references REGIAO (IDREGIAO)
go

alter table CAMPANHAMARKETING
   add constraint FK_CAMPANHA___CREDITOH foreign key (IDCREDITOHABITACAO)
      references CREDITOHABITACAO (IDCREDITOHABITACAO)
go

alter table CAMPANHAMARKETING
   add constraint FK_CAMPANHA____CARRO foreign key (IDCARRO)
      references CARRO (IDCARRO)
go

alter table CAMPANHAMARKETING
   add constraint FK_CAMPANHA_____TEMPO foreign key (IDTEMPO)
      references TEMPO (IDTEMPO)
go

alter table CAMPANHAMARKETING
   add constraint FK_CAMPANHA______CONTAORD foreign key (IDCONTAORDEM)
      references CONTAORDEM (IDCONTAORDEM)
go

alter table CAMPANHAMARKETING
   add constraint FK_CAMPANHA_______CONTAPRA foreign key (IDCONTAPRAZO)
      references CONTAPRAZO (IDCONTAPRAZO)
go

alter table CAMPANHAMARKETING
   add constraint FK_CAMPANHA________CLASSEVE foreign key (IDCLASSEVENCIMENTO)
      references CLASSEVENCIMENTO (IDCLASSEVENCIMENTO)
go

