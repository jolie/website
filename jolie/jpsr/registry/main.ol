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
include "JpsrRegistry.iol"

execution { concurrent }

inputPort JpsrRegistryPublicInput {
Location: Location_JpsrRegistry
Protocol: sodep
Interfaces: JpsrRegistryPublicInterface
}

inputPort JpsrRegistryPrivateInput {
Location: "local"
Interfaces: JpsrRegistryPrivateInterface
}

init { i = 0 }

main
{
	[ registerService( service )() {
		global.services.(service.name) << service
	} ] { nullProcess }
	
	[ getServiceList()( list ) {
		foreach( p : global.services ) {
			list.service[i] << global.services.(p)
		}
	} ] { nullProcess }
}
