/***************************************************************************
 *   Copyright (C) 2013 by Fabrizio Montesi <famontesi@gmail.com>          *
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

include "account_manager/AccountManager.iol"
include "JpsrAuthAggregator.iol"
include "config.iol"

type JpsrAuthMessage:void {
	.authData:CheckUserKeyType
}

interface extender JpsrAuthExtender {
OneWay:
	*(JpsrAuthMessage)
RequestResponse:
	*(JpsrAuthMessage)(void) throws AuthenticationFailed(string)
}

inputPort JpsrAggregatorInput {
Location: Location_JpsrAggregator
Protocol: sodeps {
	.ssl.keyStore = "keystore.jks";
	.ssl.keyStorePassword = KeystorePassword
}
Interfaces: JpsrAuthAggregatorInterface
Aggregates: JpsrService with JpsrAuthExtender
}

define checkAuth
{
	checkUserKey@AccountManager( request.authData )()
}

courier JpsrAggregatorInput {
	[ interface TargetServiceInterface( request ) ] {
		checkAuth;
		forward( request )
	}
	
	[ interface TargetServiceInterface( request )( response ) ] {
		checkAuth;
		forward( request )( response )
	}
}

embedded {
Jolie:
	TargetService in JpsrService
}

main
{
	shutdown()() { nullProcess };
	exit
}