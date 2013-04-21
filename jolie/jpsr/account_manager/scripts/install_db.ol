/***************************************************************************
 *   Copyright (C) 2013 by Fabrizio Montesi    <famontesi@gmail.com>       *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Library General Public License as       *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public     *
 *   License along with this program; if not, write to the                 *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 *                                                                         *
 *   For details about the authors of this software, see the AUTHORS file. *
 ***************************************************************************/

include "console.iol"
include "database.iol"
include "runtime.iol"

define initDatabase
{
	i = 0;
	q.statement[i++] = "create table users (
		id integer generated always as identity primary key,
		email varchar(128) not null unique,
		password varchar(128) not null
	)";

	q.statement[i++] = "create table user_keys (
		id integer generated always as identity primary key,
		user_id int references users(id) on delete cascade,
		value varchar(128) not null unique
	)";

	executeTransaction@Database( q )()
}

main
{
	install( IOException => println@Console( main.IOException.stackTrace )() );
	install( ConnectionError => println@Console( main.ConnectionError )() );
	install( SQLException => println@Console( main.SQLException.stackTrace )() );

	loadLibrary@Runtime( "file:../lib/derby.jar" )();
	with( connectionInfo ) {
		.host = "";
		.driver = "derby_embedded";
		.port = 0;
		.database = "../db/account_manager";
		.username = "";
		.password = "";
		.attributes = "create=true"
	};
	println@Console( "Creating database." )();
	connect@Database( connectionInfo )();
	println@Console( "Database created. Running initialisation queries." )();

	initDatabase;
	
	println@Console( "Database initialised successfully." )()
}