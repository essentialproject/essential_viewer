<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:pro="http://protege.stanford.edu/xml" xmlns:xalan="http://xml.apache.org/xslt" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xpath-default-namespace="http://protege.stanford.edu/xml">

	<!--
	* Copyright © 2008-2017 Enterprise Architecture Solutions Limited.
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
	* 
-->

	<xsl:template name="note">
		<!--Demo Site Label Code Starts Here-->
		<script type="text/javascript">
			$(document).ready(function(){
			$('#noteContent').hide();
			$('#note').draggable();
			
			$("#noteTitle").click(function(){
				$("#noteContainer").css( { 'width' : '300px', 'height' : 'auto' } ); 
				$('#noteContent').slideDown();	
				$('#noteContainer').resizable();
			});
			$("#closeNote").click(function(){
				$('#noteContainer').resizable('destroy');
				$('#noteContent').slideUp(200);
				$("#noteContainer").css( { 'width' : 'auto', 'height' : 'auto' } ); 		
			});
			
			
			
			});
		</script>
		<div id="note">
			<div class="bg-white" id="noteContainer">
				<div id="noteClip"/>
				<div class="fontBlack large" id="noteTitle">Note</div>
				<!--<div id="noteLink">
					<p><a class="text-default" href="#">Read more...</a></p>
				</div>-->
				<div id="noteContent">
					<p>This is a sample note which can contain any html.</p>
					<ul>
						<li>A List</li>
						<li>A List</li>
						<li>A List</li>
						<li>A List</li>
					</ul>
					<div class="verticalSpacer_10px"/>
					<div id="closeNote" class="pull-left">
						<a class="text-default fontBlack small" href="#">Close</a>
					</div>
					<div class="clear"/>
				</div>

			</div>
		</div>

		<!--Demo Site Label Code Ends Here-->
	</xsl:template>

</xsl:stylesheet>
