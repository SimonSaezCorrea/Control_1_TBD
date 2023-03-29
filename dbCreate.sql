create table Cliente(
	id_cliente int primary key,
	nombre varchar(100) not null,
	nacionalidad varchar(100) not null
);

create table Modelo(
	id_modelo int primary key,
	nombre varchar(100) not null
);

create table Avion(
	id_avion int primary key,
	fecha date not null,
	id_modelo int not null,
	foreign key (id_modelo) references Modelo(id_modelo)
);

create table Compania(
	id_compania int primary key,
	nombre varchar(100) not null,
	id_avion int,
	foreign key (id_avion) references Avion(id_avion)
);

create table Cliente_Compania(
	id_cliente int not null,
	id_compania int not null,
	foreign key (id_cliente) references Cliente(id_cliente),
	foreign key (id_compania) references Compania(id_compania)
);

create table Vuelo(
	id_vuelo int primary key,
	id_compania int not null,
	foreign key (id_compania) references Compania(id_compania)
);

create table Cliente_Vuelo(
	id_Cliente int not null,
	id_vuelo int not null,
	foreign key (id_cliente) references Cliente(id_cliente),
	foreign key (id_vuelo) references Vuelo(id_vuelo)
);

create table Seccion(
	id_seccion int primary key,
	nombre varchar(100) not null
);

create table Costo(
	id_costo int primary key,
	cantidad int not null
);

create table Pasaje(
	id_pasaje int primary key,
	fecha date not null,
	lugar varchar(100) not null,
	id_seccion int not null,
	id_costo int not null,
	id_vuelo int not null,
	foreign key (id_seccion) references Seccion(id_seccion),
	foreign key (id_vuelo) references Vuelo(id_vuelo),
	foreign key (id_costo) references Costo(id_costo)
);

create table Sueldo(
	id_sueldo int primary key,
	cantidad int not null,
	fecha_inscrito date not null
);

create table Empleado(
	id_empleado int primary key,
	nombre varchar(100) not null,
	rol varchar(100) not null,
	id_sueldo int,
	id_compania int,
	foreign key (id_sueldo) references Sueldo(id_sueldo),
	foreign key (id_compania) references Compania(id_compania)
);

create table Emp_Vuelo(
	id_empleado int not null,
	id_vuelo int not null,
	foreign key (id_empleado) references Empleado(id_empleado),
	foreign key (id_vuelo) references Vuelo(id_vuelo)
);