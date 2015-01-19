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
include "message_digest.iol"
include "security_utils.iol"
include "string_utils.iol"

include "AccountManager.iol"

execution { concurrent }

inputPort AccountManagerInput {
Location: Location_AccountManager
Protocol: sodep
Interfaces: AccountManagerInterface
}

init
{
	install( IOException => println@Console( main.IOException.stackTrace )() );
	install( ConnectionError => println@Console( main.ConnectionError )() );
	install( SQLException => println@Console( main.SQLException.stackTrace )() );
	install( AuthenticationFailed => nullProcess );

	loadLibrary@Runtime( "file:account_manager/lib/derby.jar" )();
	with( connectionInfo ) {
		.host = "";
		.driver = "derby_embedded";
		.port = 0;
		.database = "account_manager/db/account_manager";
		.username = "";
		.password = ""
	};
	connect@Database( connectionInfo )()
	/*;
	md5@MessageDigest( "mypwd" )( d );
	q = "insert into users values (default, 'test@test.org', '" + d + "')";
	update@Database( q )()*/
}

main
{
	[ checkUserPassword( request )( response ) {
		q = "select id from users where email=:email and password=:password";
		q.email = request.username;
		md5@MessageDigest( request.password )( q.password );
		query@Database( q )( result );
		if ( #result.row < 1 ) {
			throw( AuthenticationFailed, "Invalid username or key" )
		};
		response = result.row.id
	} ] { nullProcess }
	
	[ checkUserKey( request )( response ) {
		q = "select k.id from users as u, user_keys as k where u.email=:email and u.id=k.user_id and k.value=:key";
		q.email = request.username;
		q.key = request.key;
		query@Database( q )( result );
		if ( #result.row < 1 ) {
			throw( AuthenticationFailed, "Invalid username or key" )
		}
	} ] { nullProcess }

	[ createUser( request )( response ) {
		q = "select id from users where email=:username";
		q.username = request.username;
		query@Database( q )( result );
		if ( #result.row > 0 ) {
			throw( InvalidUsername, "Username already in use" )
		};
	
		q = "insert into users values (default, :username, :password)";
		md5@MessageDigest( request.password )( q.password );
		update@Database( q )()
	} ] { nullProcess }
	
	[ changePassword( request )( response ) {
		c.username = request.username;
		c.password = request.password;
		checkUserPassword@AccountManager( c )( userid );
		
		q = "update users set password=:password where email=:username";
		q.username = request.username;
		q.password = request.password;
		update@Database( q )()
	} ] { nullProcess }
	
	[ existsUser( username )( b ) {
		q = "select id from users where email=:username";
		q.username = username;
		query@Database( q )( result );
		b = #result.row > 0
	} ] { nullProcess }

	[ createFreshPassword( request )( response ) {
		/* q = "select id from users where email=:username";
		q.username = request.username;
		query@Database( q )( result );
		if ( #result.row < 1 ) {
			throw( InvalidUsername, "Invalid username" )
		};*/

		// Generate random password
		createSecureToken@SecurityUtils()( token );
		token.begin = 0;
		token.end = 5;
		substring@StringUtils( token )( pwd );

		q = "update users set password=:password where email=:username";
		q.username = request.username;
		md5@MessageDigest( pwd )( q.password );
		update@Database( q )();
		response = pwd
	} ] { nullProcess }
	
	[ updateFreshKey( request )( response ) {
		checkUserPassword@AccountManager( request )( userid );

		q.statement[0] = "delete from user_keys where user_id=:user_id";
		q.statement[0].user_id = userid;
		q.statement[1] = "insert into user_keys values(default,:user_id,:key)";
		q.statement[1].user_id = userid;
		createSecureToken@SecurityUtils()( q.statement[1].key );
		executeTransaction@Database( q )( result )
	} ] { nullProcess }
}
