CREATE TABLE locals (
	id integer NOT NULL,
	continent varchar(255),
	countryCode varchar(255),
	stateProvince varchar(255),
	county varchar(255),
	locality varchar(255),
	decimalLatitute double precision,
	decimalLongigude double precision,
	CONSTRAINT locals_pk PRIMARY KEY (id)
);

CREATE TABLE event (
	id integer NOT NULL,
	catalognumber varchar(255) NOT NULL,
	recordedby varchar(255),
	eventdate DATE,
	higherGeography varchar(255),
	eventRemarks varchar(255),
	prepMaterial varchar(255),
	CONSTRAINT event_pk PRIMARY KEY (catalognumber)
);

CREATE TABLE bioInfo (
	id serial NOT NULL,
	specimenType varchar(10),
	species varchar(255),
	scientificName varchar(255),
	verbatimScientificName varchar(255),
	sp_kingdom varchar(255),
	sp_phylum varchar(255),
	sp_class varchar(255),
	sp_order varchar(255),
	sp_family varchar(255) NOT NULL,
	sp_genus varchar(255) NOT NULL,
	genericName varchar(255) NOT NULL,
	specificEpithet varchar(255) NOT NULL,
	infraspecificEpithet varchar(255) NOT NULL,
	iucnLevel varchar(5) NOT NULL,
	CONSTRAINT bioInfo_pk PRIMARY KEY (id)
);

CREATE TABLE pubInfo (
	id serial NOT NULL,
	taxonRank varchar(12),
	taxonomicStatus varchar(12),
	publishingCountry varchar(4),
	hasCoordenates BOOLEAN,
	hasGeospatialIssues BOOLEAN,
	CONSTRAINT pubInfo_pk PRIMARY KEY (id)
);

CREATE TABLE bioKeys (
	specimentId integer NOT NULL,
	taxonKey integer,
	acceptedTaxonKey integer,
	kingdomKey integer,
	phylumKey integer,
	classKey integer,
	orderKey integer,
	familyKey integer,
	genusKey integer,
	speciesKey integer NOT NULL,
	CONSTRAINT bioKeys_pk PRIMARY KEY (specimentId)
);

CREATE TABLE pubevent (
	eventId varchar(255) NOT NULL,
	pubId integer NOT NULL
);

CREATE TABLE localevent (
	eventId varchar(255) NOT NULL,
	localId integer NOT NULL
);

CREATE TABLE specimenevent (
	eventId varchar(255) NOT NULL,
	specimenId integer NOT NULL
);

ALTER TABLE bioKeys ADD CONSTRAINT bioKeys_fk0 FOREIGN KEY (specimentId) REFERENCES bioInfo(id);

ALTER TABLE localevent ADD CONSTRAINT localevent_fk0 FOREIGN KEY (localId) REFERENCES locals(id);
ALTER TABLE localevent ADD CONSTRAINT localevent_fk1 FOREIGN KEY (eventId) REFERENCES event(catalognumber);

ALTER TABLE pubevent ADD CONSTRAINT pubevent_fk0 FOREIGN KEY (eventId) REFERENCES event(catalognumber);
ALTER TABLE pubevent ADD CONSTRAINT pubevent_fk1 FOREIGN KEY (pubId) REFERENCES pubInfo(id);

ALTER TABLE specimenevent ADD CONSTRAINT specimentevent_fk0 FOREIGN KEY (specimenId) REFERENCES bioInfo(id);
ALTER TABLE specimenevent ADD CONSTRAINT specimentevent_fk1 FOREIGN KEY (eventId) REFERENCES event(catalognumber);

create or replace function populate()
returns void as
$$
begin
insert into localevent
	select a.catalognumber,b.id from event as a
	join locals as b on a.id = b.id;
insert into pubevent
	select a.catalognumber,b.id from event as a
	join pubinfo as b on a.id = b.id;
insert into specimenevent
	select a.catalognumber,b.id from event as a
	join bioinfo as b on a.id = b.id;
alter table event drop column id; 
end;
$$
language plpgsql;







