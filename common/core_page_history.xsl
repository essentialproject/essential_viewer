<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xpath-default-namespace="http://protege.stanford.edu/xml" exclude-result-prefixes="pro xalan eas" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xslt" xmlns:pro="http://protege.stanford.edu/xml" xmlns:eas="http://www.enterprise-architecture.org/essential">
	<!--<xsl:output method="html"/>-->
	<xsl:import href="core_utilities.xsl"/>

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
	
	 28.01.2009 JWC	Added table tags around the tr after moved header and footer to divs 
	 28.01.2009 JWC Migrated to divs 
	 10.11.2011	JWC Re-worked the page history breadcrumb list. 
	 11.11.2011	JWC	Revised structure of breadcrumb object - no longer HTML code but structured String.
	 17.06.2014	JWC Fixed a bug in translating / i18n the label for the history entry
	 15.06.2018	JMK protect text rendering in javascript
	 01.10.2024 NJW Convert to pure javascript history
-->
	
	<xsl:template match="node()" name="Page_History">
		<style>
			.pageHistoryPanel{
				max-height: 160px;
				overflow-y: auto;
			}
		</style>
		<div id="pageHistoryContainer">

			<script>
				// Function to add the current page title and URL to history
				function addPageToHistory() {
					const pageTitle = document.title; // Get the title of the current page
					let pageUrl = window.location.href.split('#')[0]; // Remove fragment part (after '#')
				
					let history = JSON.parse(localStorage.getItem('pageHistory')) || []; // Fetch existing history or set an empty array
				
					// Create an object with the page title and URL
					const pageEntry = { title: pageTitle, url: pageUrl };
				
					// Check if the page is already in the history (based on the URL)
					const isPageInHistory = history.some(entry => entry.url === pageUrl);
					if (!isPageInHistory) {
						history.unshift(pageEntry); // Add the new page entry to the start of the array
					}
				
					// Limit the history to the latest 50 entries
					if (history.length > 50) {
						history = history.slice(0, 50);
					}
				
					// Store the updated history in local storage
					localStorage.setItem('pageHistory', JSON.stringify(history));
				}
				
				// Function to display the history as clickable links
				function displayHistory() {
					const historyList = document.getElementById('history-list');
					let history = JSON.parse(localStorage.getItem('pageHistory')) || [];
				
					// Clear the existing list
					historyList.innerHTML = '';
				
					// Loop through the history and create list items with links
					history.forEach(entry => {
						const listItem = document.createElement('li');
						const link = document.createElement('a');
						link.textContent = entry.title;
						link.href = entry.url;
						listItem.appendChild(link);
						historyList.appendChild(listItem);
					});
				}
				$('document').ready(function(){
					addPageToHistory();
					displayHistory();
				});

				</script>

			<div class="pageHistoryPanel bottom-15">
				<ul id="history-list">
				</ul>
			</div>

		</div>
	</xsl:template>
</xsl:stylesheet>
