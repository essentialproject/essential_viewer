<%--
 *
 * 
 * This JSP is used to create UML-based models leveraging the PlantUML
 * open source framework. 
 *
 * XSL parameter is used as parameter that defines the XSL to be used to create the model
 * PAGEXSL is a special parameter that defines the target HTML page that will include the 
 * rendered UML image.
 * All other parameters are used in the normal manner
 * 
 * Copyright (c)2011-2012 Enterprise Architecture Solutions ltd.
 * This file is part of Essential Architecture Manager, 
 * the Essential Architecture Meta Model and The Essential Project.
 *
 * Essential Architecture Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Essential Architecture Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Essential Architecture Manager.  If not, see <http://www.gnu.org/licenses/>.
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    	<meta http-equiv="refresh" content="3; url=../report"></meta>
        <title>Logout</title>
    </head>
    <body>
    	
    	<%@ page session="true"%>
    	
    	User '<%=request.getRemoteUser()%>' has been logged out.
    	
		<% session.invalidate(); %>
    	
    </body>
</html>