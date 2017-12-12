CREATE TABLE userroles (
	id serial NOT NULL,
	role_title VARCHAR(100) NOT NULL,
	PRIMARY KEY (id)
);

INSERT INTO userroles(id, role_title) 
	VALUES  (1, 'Administrator'),
			(2, 'Unassigned'),
			(3, 'Judge'),
			(4, 'Singer'),
			(5, 'Artist'),
			(6, 'Mixer'),
			(7, 'Animator');

CREATE TABLE users (
    id serial NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    lastname VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(100) NOT NULL,
    username VARCHAR(100) UNIQUE NOT NULL,
    role_id INTEGER NOT NULL,
    user_icon BYTEA,
    PRIMARY KEY (id),
    CONSTRAINT users_role_id FOREIGN KEY(role_id) REFERENCES userroles(id)
);


CREATE TABLE chorusbattles (
	id serial NOT NULL PRIMARY KEY, 
	name VARCHAR(150) NOT NULL,
    description VARCHAR(500) NOT NULL,
    rules VARCHAR(500),
    prizes VARCHAR(500),
    video_link VARCHAR(150),
    start_date TIMESTAMP WITHOUT TIME ZONE,
    no_of_rounds INTEGER NOT NULL,
    creator_id INTEGER NOT NULL REFERENCES users(id)
);
"""
__tablename__ = 'rounds'
    id = db.Column(db.Integer, primary_key = True) #: Primary key to identify the round. 
    chorusbattle = db.Column(db.Integer, db.ForeignKey('chorusbattles.id')) #: The chorus battle the round belongs to.
    theme = db.Column(db.String(500)) #: User-inputted theme for the round of the chorus battle.
    deadline = db.Column(db.DateTime(timezone=True)) #: Deadline for the submissions of the round.
    round_number = db.Column(db.Integer) #: Round number to show the progression of the chorus battle.
"""

CREATE TABLE entries (
	id SERIAL NOT NULL PRIMARY KEY,
	chorusbattle INTEGER NOT NULL REFERENCES chorusbattles(id), 
	team_id INTEGER NOT NULL REFERENCES teams(id),
	round_number INTEGER NOT NULL,
	title VARCHAR(100),
	description VARCHAR(500),
	submission_date TIMESTAMP WITH TIME ZONE,
	video_link VARCHAR(500)
);


CREATE TABLE rounds (
	id serial NOT NULL,
	chorusbattle INTEGER NOT NULL,
	theme VARCHAR(500),
	deadline TIMESTAMP WITH TIMEZONE,
	round_number INTEGER,
	PRIMARY KEY (id),
	CONSTRAINT chorusbattle_id FOREIGN KEY(chorusbattle) REFERENCES chorusbattles(id)
);

CREATE TABLE teams (
	id serial NOT NULL PRIMARY KEY,
	chorusbattle INTEGER NOT NULL REFERENCES chorusbattles(id),
	team_name VARCHAR(100) NOT NULL,
	leader_id INTEGER NOT NULL REFERENCES users(id),
	team_logo BYTEA
);


CREATE TABLE judges (
	user_id INTEGER REFERENCES users(id),
	chorusbattle_id INTEGER REFERENCES chorusbattles(id),
	PRIMARY KEY (user_id, chorusbattle_id)
);

CREATE TABLE chorusbattle_entries (
	entry_id INTEGER REFERENCES entries(id),
	chorusbattle_id INTEGER REFERENCES chorusbattles(id),
	PRIMARY KEY (entry_id, chorusbattle_id)
);

CREATE TABLE user_teams (
	user_id INTEGER REFERENCES users(id),
	team_id INTEGER REFERENCES teams(id),
	member_status VARCHAR(100) NOT NULL,
	PRIMARY KEY (user_id, team_id)
);

ALTER TABLE teams ADD COLUMN team_name VARCHAR(100) NOT NULL, ADD COLUMN leader_id INTEGER NOT NULL REFERENCES users(id), ADD COLUMN team_logo BYTEA;
ALTER TABLE user_teams ADD COLUMN member_status VARCHAR(100) NOT NULL;
ALTER TABLE rounds 
	ADD COLUMN theme VARCHAR(500),
	ADD COLUMN deadline TIMESTAMP WITH TIME ZONE,
	ADD COLUMN round_number INTEGER;
