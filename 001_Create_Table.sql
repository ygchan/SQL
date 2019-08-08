-- Table with member's information
create table member
(
	member_id smallint unsigned,
    fname varchar(20),
    lname varchar(20),
    gender char(1),
    constraint pk_member primary key (member_id)
);
