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

type SumRequest:void {
	.authData:void {
		.username:string
		.key:string
	}
	.x:int
	.y:int
}

interface CalculatorInterface {
RequestResponse:
	sum(SumRequest)(int) throws AuthenticationFailed( string )
}

include "console.iol"

outputPort Calculator {
Location: "socket://localhost:9100/"
Protocol: sodeps {
	.ssl.trustStore = "../client.jks"
}
Interfaces: CalculatorInterface
}

main
{
	install( AuthenticationFailed => println@Console( main.AuthenticationFailed )() );
	r.authData.username = "test@test.org";
	r.authData.key = "mypwd";
	r.x = 4;
	r.y = 6;
	sum@Calculator( r )( result );
	println@Console( result )()
}