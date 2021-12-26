CREATE TABLE narthex_crm_db.client ( 
	id                   int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	email_address        varchar(127)  NOT NULL UNIQUE,
	creation_timestamp   timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	permission_scope     enum('admin')  NOT NULL,
	last_login_timestamp      timestamp,
	active               bit  NOT NULL DEFAULT 1,
	pass_hash            char(246) NOT NULL
) engine=InnoDB;

CREATE TABLE narthex_crm_db.donation_campaign ( 
	id                   int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	name                 varchar(63)  NOT NULL,
	notes                text,
	start_date           date  NOT NULL,
	end_date             date  NOT NULL,
	created_by           int  NOT NULL,
	creation_timestamp   timestamp   DEFAULT CURRENT_TIMESTAMP,
	modified_by          int  NOT NULL,
	modification_timestamp timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	archived             bit  NOT NULL DEFAULT 0   
 ) engine=InnoDB;

CREATE INDEX idx_donation_campaign_time_range ON narthex_crm_db.donation_campaign ( start_date, end_date );

ALTER TABLE narthex_crm_db.donation_campaign MODIFY start_date date  NOT NULL   COMMENT 'UTC date';

ALTER TABLE narthex_crm_db.donation_campaign MODIFY end_date date  NOT NULL   COMMENT 'UTC date';

CREATE TABLE narthex_crm_db.event ( 
	id                   int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	name                 varchar(63)  NOT NULL,
	`date`               date  NOT NULL,
	location             varchar(63),
	created_by           int  NOT NULL,
	creation_timestamp   timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by          int  NOT NULL,
	modification_timestamp timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	archived             bit  NOT NULL DEFAULT 0   
 ) engine=InnoDB;

CREATE INDEX idx_event_date ON narthex_crm_db.event ( `date` );

ALTER TABLE narthex_crm_db.event MODIFY `date` date  NOT NULL   COMMENT 'UTC date';

CREATE TABLE narthex_crm_db.ministry ( 
	id                   int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	name                 varchar(63)  NOT NULL,
	color                mediumint UNSIGNED NOT NULL,
	created_by           int  NOT NULL,
	creation_timestamp   timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by          int  NOT NULL,
	modification_timestamp timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	archived             bit  NOT NULL DEFAULT 0   
 ) engine=InnoDB;

CREATE TABLE narthex_crm_db.donation ( 
	id                   int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	household_id         int  NOT NULL,
	donation_campaign_id int,
	`date`               date  NOT NULL,
	amount               decimal(9,2)  NOT NULL,
	notes                text,
	created_by           int  NOT NULL,
	creation_timestamp   timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by          int  NOT NULL,
	modification_timestamp timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	archived             bit  NOT NULL DEFAULT 0   
 ) engine=InnoDB;

CREATE INDEX idx_donation_amount ON narthex_crm_db.donation ( amount );

CREATE INDEX idx_donation_date ON narthex_crm_db.donation ( `date` );

ALTER TABLE narthex_crm_db.donation MODIFY `date`  date  NOT NULL COMMENT 'UTC date';

CREATE TABLE narthex_crm_db.event_attendance ( 
	event_id             int  NOT NULL,
	person_id            int  NOT NULL,
	date_registered      date  NOT NULL DEFAULT (current_date),
	attended             bit  NOT NULL DEFAULT 0,
	created_by           int  NOT NULL,
	creation_timestamp   timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by          int  NOT NULL,
	modification_timestamp timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_event_attendance PRIMARY KEY ( event_id, person_id )
) engine=InnoDB;

ALTER TABLE narthex_crm_db.event_attendance MODIFY date_registered date  NOT NULL DEFAULT (current_date)  COMMENT 'UTC date';

CREATE TABLE narthex_crm_db.household ( 
	id                   int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	head_id              int  NOT NULL,
	name                 varchar(100)  NOT NULL,
	address_line_1       varchar(127)  NOT NULL,
	address_line_2       varchar(127),
	city                 varchar(63)  NOT NULL,
	state                varchar(63)  NOT NULL,
	postal_code          varchar(15)  NOT NULL,
	country              char(2)  NOT NULL,
	created_by           int  NOT NULL,
	creation_timestamp   timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by          int  NOT NULL,
	modification_timestamp timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	archived             bit  NOT NULL DEFAULT 0   
 ) engine=InnoDB;

CREATE INDEX idx_household_country ON narthex_crm_db.household ( country );

CREATE INDEX idx_household_name ON narthex_crm_db.household ( name );

CREATE TABLE narthex_crm_db.milestone ( 
	id                   int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	person_id            int  NOT NULL,
	`type`               enum('baptism', 'marriage')  NOT NULL,
	event_date           date  NOT NULL,
	notes                text,
	created_by           int  NOT NULL,
	creation_timestamp   timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by          int  NOT NULL,
	modification_date    timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	archived             bit  NOT NULL DEFAULT 0   
 ) engine=InnoDB;

CREATE INDEX idx_milestone_date ON narthex_crm_db.milestone ( event_date );

ALTER TABLE narthex_crm_db.milestone MODIFY event_date date  NOT NULL   COMMENT 'UTC date';

CREATE TABLE narthex_crm_db.ministry_delegation ( 
	ministry_id          int  NOT NULL,
	person_id            int  NOT NULL,
	created_by           int  NOT NULL,
	creation_timestamp   timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by          int  NOT NULL,
	modification_timestamp timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_ministry_delegation PRIMARY KEY ( ministry_id, person_id )
 ) engine=InnoDB;

CREATE TABLE narthex_crm_db.person ( 
	id                   int  NOT NULL  AUTO_INCREMENT  PRIMARY KEY,
	household_id         int  NOT NULL,
	first_name           varchar(100)  NOT NULL,
	last_name            varchar(100)  NOT NULL,
	gender               enum('male', 'female')  NOT NULL,
	primary_phone_number varchar(31),
	email_address        varchar(127),
	birth_date           date  NOT NULL,
	title                varchar(63),
	created_by           int  NOT NULL,
	creation_timestamp   timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_by          int  NOT NULL,
	modification_timestamp timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP,
	archived             bit  NOT NULL DEFAULT 0   
 ) engine=InnoDB;

CREATE INDEX idx_person_name ON narthex_crm_db.person ( first_name, last_name );

CREATE INDEX idx_person_birth_date ON narthex_crm_db.person ( birth_date );

ALTER TABLE narthex_crm_db.person MODIFY birth_date date  NOT NULL   COMMENT 'UTC date';

CREATE TABLE narthex_crm_db.relationship ( 
	`type`               varchar(31)  NOT NULL,
	date_started         date  NOT NULL,
	first_person_id      int  NOT NULL,
	second_person_id     int  NOT NULL,
	CONSTRAINT pk_relationship PRIMARY KEY ( first_person_id, second_person_id )
 ) engine=InnoDB;

ALTER TABLE narthex_crm_db.relationship MODIFY date_started date  NOT NULL   COMMENT 'UTC date';

ALTER TABLE narthex_crm_db.donation ADD CONSTRAINT fk_donation_household FOREIGN KEY ( household_id ) REFERENCES narthex_crm_db.household( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.donation ADD CONSTRAINT fk_donation_client_creation FOREIGN KEY ( created_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.donation ADD CONSTRAINT fk_donation_client_modification FOREIGN KEY ( modified_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.donation ADD CONSTRAINT fk_donation_donation_campaign FOREIGN KEY ( donation_campaign_id ) REFERENCES narthex_crm_db.donation_campaign( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.donation_campaign ADD CONSTRAINT fk_donation_campaign_client_creation FOREIGN KEY ( created_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.donation_campaign ADD CONSTRAINT fk_donation_campaign_client_modification FOREIGN KEY ( modified_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.event ADD CONSTRAINT fk_event_client_created FOREIGN KEY ( created_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.event ADD CONSTRAINT fk_event_client_modified FOREIGN KEY ( modified_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.event_attendance ADD CONSTRAINT fk_event_attendance_event FOREIGN KEY ( event_id ) REFERENCES narthex_crm_db.event( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.event_attendance ADD CONSTRAINT fk_event_attendance_person FOREIGN KEY ( person_id ) REFERENCES narthex_crm_db.person( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.event_attendance ADD CONSTRAINT fk_event_attendance_client_created FOREIGN KEY ( created_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.event_attendance ADD CONSTRAINT fk_event_attendance_client_modified FOREIGN KEY ( modified_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.household ADD CONSTRAINT fk_household_client_creation FOREIGN KEY ( created_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.household ADD CONSTRAINT fk_household_client_modification FOREIGN KEY ( modified_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.household ADD CONSTRAINT fk_household_person FOREIGN KEY ( head_id ) REFERENCES narthex_crm_db.person( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.milestone ADD CONSTRAINT fk_milestone_person FOREIGN KEY ( person_id ) REFERENCES narthex_crm_db.person( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.milestone ADD CONSTRAINT fk_milestone_client_creation FOREIGN KEY ( created_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.milestone ADD CONSTRAINT fk_milestone_client_modification FOREIGN KEY ( modified_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.ministry ADD CONSTRAINT fk_ministry_client_created FOREIGN KEY ( created_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.ministry ADD CONSTRAINT fk_ministry_client_modified FOREIGN KEY ( modified_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.ministry_delegation ADD CONSTRAINT fk_ministry_delegation_ministry FOREIGN KEY ( ministry_id ) REFERENCES narthex_crm_db.ministry( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.ministry_delegation ADD CONSTRAINT fk_ministry_delegation_person FOREIGN KEY ( person_id ) REFERENCES narthex_crm_db.person( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.ministry_delegation ADD CONSTRAINT fk_ministry_delegation_client_created FOREIGN KEY ( created_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.ministry_delegation ADD CONSTRAINT fk_ministry_delegation_client_modified FOREIGN KEY ( modified_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.person ADD CONSTRAINT fk_person_client_created FOREIGN KEY ( created_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.person ADD CONSTRAINT fk_person_client_modified FOREIGN KEY ( modified_by ) REFERENCES narthex_crm_db.client( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.person ADD CONSTRAINT fk_person_household FOREIGN KEY ( household_id ) REFERENCES narthex_crm_db.household( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.relationship ADD CONSTRAINT fk_relationship_first_person FOREIGN KEY ( first_person_id ) REFERENCES narthex_crm_db.person( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE narthex_crm_db.relationship ADD CONSTRAINT fk_relationship_second_person FOREIGN KEY ( second_person_id ) REFERENCES narthex_crm_db.person( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

