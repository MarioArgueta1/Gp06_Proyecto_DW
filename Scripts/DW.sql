DROP DATABASE IF EXISTS AmarettoDW
go
CREATE DATABASE AmarettoDW
go
USE AmarettoDW

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FACTTRANSACCIONES') and o.name = 'FK_FACTTRAN_RELATIONS_DIMPRODU')
alter table FACTTRANSACCIONES
   drop constraint FK_FACTTRAN_RELATIONS_DIMPRODU
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FACTTRANSACCIONES') and o.name = 'FK_FACTTRAN_RELATIONS_DIMUBICA')
alter table FACTTRANSACCIONES
   drop constraint FK_FACTTRAN_RELATIONS_DIMUBICA
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FACTTRANSACCIONES') and o.name = 'FK_FACTTRAN_RELATIONS_DIMCLIEN')
alter table FACTTRANSACCIONES
   drop constraint FK_FACTTRAN_RELATIONS_DIMCLIEN
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('FACTTRANSACCIONES') and o.name = 'FK_FACTTRAN_RELATIONS_DIMTIEMP')
alter table FACTTRANSACCIONES
   drop constraint FK_FACTTRAN_RELATIONS_DIMTIEMP
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DIMCLIENTE')
            and   type = 'U')
   drop table DIMCLIENTE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DIMPRODUCTO')
            and   type = 'U')
   drop table DIMPRODUCTO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DIMTIEMPO')
            and   type = 'U')
   drop table DIMTIEMPO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DIMUBICACION')
            and   type = 'U')
   drop table DIMUBICACION
go

if exists (select 1
            from  sysobjects
           where  id = object_id('FACTTRANSACCIONES')
            and   type = 'U')
   drop table FACTTRANSACCIONES
go

/*==============================================================*/
/* Table: DIMCLIENTE                                            */
/*==============================================================*/
create table DIMCLIENTE (
   IDCLIENTE            int identity(1,1)    not null,
   IDCLIENTEN           int                  not null,
   NOMBRE               varchar(250)         not null,
   DIRECCION            varchar(300)         not null,
   CIUDAD               varchar(300)         not null,
   PAIS                 varchar(100)         not null,
   EMAIL                varchar(250)         not null,
   FECHADENACIMIENTO    datetime             not null,
   GENERO               varchar(10)          not null,
   constraint PK_DIMCLIENTE primary key (IDCLIENTE)
)
go

/*==============================================================*/
/* Table: DIMPRODUCTO                                           */
/*==============================================================*/
create table DIMPRODUCTO (
   IDPRODUCTO           int identity(1,1)    not null,
   IDPRODUCTON          int                  not null,
   NOMBRE               varchar(250)         not null,
   CATEGORIA            varchar(250)         not null,
   DESCRIPCION          varchar(500)         not null,
   PRECIOUNITARIO       decimal(5,2)         not null,
   STOCK                int                  not null,
   constraint PK_DIMPRODUCTO primary key (IDPRODUCTO)
)
go

/*==============================================================*/
/* Table: DIMTIEMPO                                             */
/*==============================================================*/
create table DIMTIEMPO (
   IDTIEMPO             int    not null,
   FECHACOMPLETA        datetime             not null,
   DIADELASEMANA        int                  not null,
   NUMERODEDIADELMES    int                  not null,
   NUMERODEDIAENGENERAL int                  not null,
   NOMBREDELDIA         varchar(15)          not null,
   NOMBREDELDIAABREVIADO varchar(3)           not null,
   BANDERDIALUNESAVIERNRES varchar(25)          not null,
   NUMEROSEMANAENELANO  int                  not null,
   NUMERODESEMANAENGENERAL int                  not null,
   FECHADEINICIODESEMANA datetime             not null,
   CLAVEFECHAINICIODESEMANA int                  not null,
   NUMERODEMES          int                  not null,
   NUMERODEMESENGENERAL int                  not null,
   NOMBREDELMES         varchar(15)          not null,
   NOMBREDELMESABREVIADO varchar(3)           not null,
   CUARTO               int                  not null,
   NUMERODEANO          int                  not null,
   ANOMES               int                  not null,
   MESFISCAL            int                  not null,
   CUARTOFISCAL         int                  not null,
   ANOFISCAL            int                  not null,
   BANDERAFINDEMES      varchar(50)          not null,
   FECHADEMISMODIAHACEUNANO datetime             not null,
   constraint PK_DIMTIEMPO primary key (IDTIEMPO)
)
go

/*==============================================================*/
/* Table: DIMUBICACION                                          */
/*==============================================================*/
create table DIMUBICACION (
   IDUBICACION          int identity(1,1)    not null,
   IDUBICACIONN         int                  not null,
   PAIS                 varchar(100)         not null,
   CIUDAD               varchar(300)         not null,
   DIRECCION            varchar(300)         not null,
   MONEDA               varchar(200)         not null,
   constraint PK_DIMUBICACION primary key (IDUBICACION)
)
go

/*==============================================================*/
/* Table: FACTTRANSACCIONES                                     */
/*==============================================================*/
create table FACTTRANSACCIONES (
   IDPRODUCTO           int                  not null,
   IDUBICACION          int                  not null,
   IDCLIENTE            int                  not null,
   IDTIEMPO             int                  not null,
   TIPOTRANSACCION      varchar(50)          not null,
   CANTIDAD             int                  not null,
   PRECIOUNITARIO       decimal(5,2)         not null,
   TOTALTRANSACCION     decimal(8,2)         not null,
   COSTOTRASLADO        decimal(8,2)         not null,
   COSTOALMACEN         decimal(8,2)         not null,
   COSTOINVENTARIO      decimal(8,2)         not null,
   TIEMPOENTREGADIAS    int                  not null,
   DESCUENTO            decimal(8,2)         not null,
   COSTOTOTALTRANSACCION decimal(10,2)       not null,
   constraint PK_FACTTRANSACCIONES primary key (IDPRODUCTO, IDUBICACION, IDCLIENTE, IDTIEMPO)
)
go

alter table FACTTRANSACCIONES
   add constraint FK_FACTTRAN_RELATIONS_DIMPRODU foreign key (IDPRODUCTO)
      references DIMPRODUCTO (IDPRODUCTO)
go

alter table FACTTRANSACCIONES
   add constraint FK_FACTTRAN_RELATIONS_DIMUBICA foreign key (IDUBICACION)
      references DIMUBICACION (IDUBICACION)
go

alter table FACTTRANSACCIONES
   add constraint FK_FACTTRAN_RELATIONS_DIMCLIEN foreign key (IDCLIENTE)
      references DIMCLIENTE (IDCLIENTE)
go

alter table FACTTRANSACCIONES
   add constraint FK_FACTTRAN_RELATIONS_DIMTIEMP foreign key (IDTIEMPO)
      references DIMTIEMPO (IDTIEMPO)
go

