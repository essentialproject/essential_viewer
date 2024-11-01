
				var doc, classList, classSlots;
				var jsonResult = [];
				var selections = {};
				var selectPairs=[];
				var pairs=[];
				var classSlots;
				var stakeholderList=[];
				var multiple;
				var worksheets = {};
				var workbook
				//array of names

				$(document).ready(function(){
                
					$("#fileUpload").change(function(e){
						$('#filespinner').show();
						var reader = new FileReader();
						reader.onload = function(e) {
							var data = e.target.result;
							workbook = XLSX.read(data, {type: 'binary'});
							var sheetNames = workbook.SheetNames;
							$('#worksheetSelect').empty(); // Clear previous options
							worksheets = {}; // Clear previous data
				
							sheetNames.forEach(function(sheetName) {
								console.log('sheetName', sheetName);
								var sheet = workbook.Sheets[sheetName];
						
								// Check if the sheet is empty
								if (XLSX.utils.sheet_to_json(sheet).length > 0) {
									// Sheet has data, convert to HTML
									worksheets[sheetName] = XLSX.utils.sheet_to_html(sheet, {editable: true});
									$('#worksheetSelect').append(new Option(sheetName, sheetName));
								}
								
							});
						
							$('#worksheetSelect').trigger('change'); // Update the table
							$('#filespinner').hide();

						
				
						};
				
						reader.readAsBinaryString(e.target.files[0]);
					});

					function exportSheets() {
						var wbout = XLSX.write(workbook, {bookType:'xlsx', type: 'binary'});

						// Trigger download (using the s2ab function to convert string to ArrayBuffer)
						saveAs(new Blob([s2ab(wbout)], {type:"application/octet-stream"}), "ExportedWorkbook.xlsx");
					
					}
					
					function s2ab(s) {
						var buf = new ArrayBuffer(s.length);
						var view = new Uint8Array(buf);
						for (var i=0; i<s.length; i++) view[i] = s.charCodeAt(i) & 0xFF;
						return buf;
					}

					$('#exportXLJson').on('click',function(){
						exportSheets()
					})
					

					// new worksheet
					$("#addSheetButton").click(function() {
						// Assuming 'workbook' is your workbook object
						if (!workbook) {
							alert("No workbook available");
							return;
						}
					
						// Prompt user for new sheet name
						var newSheetName = prompt("Enter name for new sheet:");
						if (!newSheetName) {
							alert("Sheet name is required.");
							return;
						}
					
						// Check if sheet name already exists
						if (workbook.SheetNames.includes(newSheetName)) {
							alert("Sheet name already exists. Please choose a different name.");
							return;
						}
					
						// Create a new empty sheet
						var emptyRows = new Array(10);
						for (var i = 0; i < emptyRows.length; i++) {
							emptyRows[i] = new Array(15); // Each row has 15 empty cells
							for (var j = 0; j < 15; j++) {
								emptyRows[i][j] = ""; // Initialize each cell with an empty string
							}
						}
					
						// Create a new sheet with 10 rows and 15 columns
						var newSheet = XLSX.utils.aoa_to_sheet(emptyRows);
				
						workbook.Sheets[newSheetName] = newSheet;
						workbook.SheetNames.push(newSheetName);
					
						// Update the UI (assuming you have a select element for sheet names)
						$('#worksheetSelect').append(new Option(newSheetName, newSheetName));

						worksheets[newSheetName] = XLSX.utils.sheet_to_html(newSheet, {editable: true});
						// Optionally, you might want to switch to the new sheet here
						// This depends on how your UI handles sheet changes
					});

					//add new row
					$("#addRowButton").click(function() {
						console.log('adding')
						if (!workbook) {
							alert("No workbook available");
							return;
						}
					
						// Determine the currently selected sheet
						var currentSheetName = $('#worksheetSelect').val();
						if (!currentSheetName) {
							alert("No sheet selected");
							return;
						}
					
						var currentSheet = workbook.Sheets[currentSheetName];

						console.log('currentSheet',currentSheet)
					
						// Determine the number of columns in the last row of the current sheet
						var lastRowNumber = XLSX.utils.decode_range(currentSheet['!ref']).e.r;
						var lastRow = currentSheet[XLSX.utils.encode_row(lastRowNumber)];
						var numberOfColumns = lastRow ? Object.keys(lastRow).length : 0;
					
						// Create an empty row with the same number of columns
						var newRow = new Array(numberOfColumns).fill("");
					
						// Add the new row to the current sheet
						XLSX.utils.sheet_add_aoa(currentSheet, [newRow], {origin: -1});
					
						// Update the worksheets object with the new sheet's HTML representation
						worksheets[currentSheetName] = XLSX.utils.sheet_to_html(currentSheet, {editable: true});
					
						// Refresh UI to include the new row in the current sheet
						// This step depends on how your UI is set up
						updateTable()
					});
					
					$(document).on('click', '.delete-row-btn', function() {
						console.log('del')
						if (!workbook) {
							alert("No workbook available");
							return;
						}
					
						var currentSheetName = $('#worksheetSelect').val();
						if (!currentSheetName) {
							alert("No sheet selected");
							return;
						}
					
						var currentSheet = workbook.Sheets[currentSheetName];
						console.log('currentSheet',currentSheet)
						// Find a cell in the same row and extract the row number from its ID
						var cellId = $(this).closest('tr').find('td').first().attr('id');
						if (!cellId) {
							alert("Cannot find the row number.");
							return;
						}
					
						// Extract row number from the cell ID (e.g., "sjs-B14" -> 14)
						var rowNumMatch = cellId.match(/(\d+)$/);
						if (!rowNumMatch) {
							alert("Invalid row number.");
							return;
						}
					
						var rowNum = parseInt(rowNumMatch[0]) - 1; // Adjust for 0-based index
				
						// Use the custom function to delete the row
						deleteRow(currentSheet, rowNum);
					
						// Update the worksheets object with the new sheet's HTML representation
						worksheets[currentSheetName] = XLSX.utils.sheet_to_html(currentSheet, {editable: true});
					
						// Refresh UI to reflect the row deletion
						$('#sheetContainer').html(worksheets[currentSheetName]);
						updateTable();
					});
					

					function deleteRow(sheet, rowToDelete) {
						var range = XLSX.utils.decode_range(sheet['!ref']);
						if (rowToDelete >= range.s.r && rowToDelete <= range.e.r) {
							for (var R = rowToDelete; R < range.e.r; ++R) {
								for (var C = range.s.c; C <= range.e.c; ++C) {
									sheet[XLSX.utils.encode_cell({r: R, c: C})] = sheet[XLSX.utils.encode_cell({r: R + 1, c: C})];
								}
							}
							delete sheet[XLSX.utils.encode_cell({r: range.e.r, c: range.e.c})];
							range.e.r--;
							sheet['!ref'] = XLSX.utils.encode_range(range);
						}
					}
					
					
					
					// Existing file upload handler remains unchanged
					
				
					$('#worksheetSelect').on('change', function() {
						updateTable();
						$('#appType').hide();
						$('#appTypeforAPR').hide()
					});
				
					$('#startRow').on('change', function() {
						if ($('#worksheetSelect').val()) {
							updateTable();
						}
					});
				
					function updateTable() {
						var selectedSheet = $('#worksheetSelect').val();
						var startRow = 6; // Convert to zero-based index
					
						if (!worksheets[selectedSheet]) {
							$('.table-container').html('');
							return;
						}
					
						var parser = new DOMParser();
						doc = parser.parseFromString(worksheets[selectedSheet], 'text/html');
					
						// Remove rows before the starting row
						$(doc).find('tr').slice(0, startRow).remove();
					
						// Now append delete button to each row except the first one (which is now the actual first visible row)
						$(doc).find('tr').each(function(index) {
							// Skip the first row (header)
							if (index !== 0) {
								$(this).append('<td><button class="btn btn-danger btn-xs delete-row-btn" id="delete-row-btn">Delete</button></td>');
							}
						});
					
						$('.table-container').html($(doc).find('table').prop('outerHTML'));
					}
					
						
						essPromise_getAPIElements('/essential-utility/v3', '/classes')
						.then(function(response) {
							return response.classes.filter((d) => {
								return d.isAbstract == false && d.superClasses.includes('EA_Class')
							});
						})
						.then(function(classes) { 
							
							console.log('classes',classes)
							classes.forEach((cls) => {
								
								$('#classes').append('<option value="'+cls.name+'">'+cls.name+'</option>')
							});
							
							$('#classes').select2({width:'200px'});

							$('#classes').on('change', function(){
								let className = $(this).val();
								
								$('#spinner').show()
 
								essPromise_getAPIElements('/essential-system/v1', 'class-layouts/' + className).then(function(slotLayoutResponse) {
									console.log('slotLayoutResponse', slotLayoutResponse);
									let slotsMap = {};
								
									slotLayoutResponse.slotLayoutGroups.forEach(group => {
										group.slots.forEach(slot => {
											slotsMap[slot.name] = slot.cardinality;
										});
									});
								
									essPromise_getAPIElements('/essential-utility/v3', 'classes/' + className + '/slots').then(function(slotResponse) {
										classSlots = slotResponse;
										classSlots.slots = classSlots.slots.filter(slot => {
											if (!slot.description.includes("DEPRECATED")) {
												if (slotsMap[slot.name]) {
													slot.cardinality = slotsMap[slot.name];
												}
												return true;
											}
											return false;
										});
								
										console.log('classSlots...', classSlots);
										classSlots.slots=classSlots.slots.sort((a, b) => a.name.localeCompare(b.name));
										multiple = classSlots.slots.filter(slot => slot.cardinality=='multiple');
								 		$('.mapper').show()
										$('#spinner').hide()
									});
								});
								
							})

						})
				});

				

				$('#slotInfo').on('click', function(){
					toggleRightPanel();
					console.log('cs', classSlots)
					if ($.fn.DataTable.isDataTable('#myTable')) {
						// Destroy the existing DataTable
						$('#myTable').DataTable().destroy();
					}
					
					$('#slotInformation').html(slotTemplate(classSlots));
					$('#slotTable').dataTable();
				})

				function toggleRightPanel() {
					var panel = document.getElementById('rightPanel');
					panel.classList.toggle('open');
				}
				
				$('#mapper').on('click', function(){
					pairs=[];
					var firstRowCells = $(doc).find('tr').first().find('td');
				  	console.log('firstRowCells', firstRowCells);
					var list = $('#columnValuesList');
					list.empty(); // Clear existing list items
					let hasHeaderRow=false;
					let options = '';
					classSlots.slots.forEach((e) => {
						options += '<option value="' + e.name + '">' + e.name + '</option>';
					});

					
					firstRowCells.each(function(index, cell) {
						$('#startRow').removeClass('headerRowColour')
						var cellValue = $(cell).text().trim();
 
						if(cellValue.toLowerCase()=='id'){
							pairs.push({"column":cellValue , "name": "id", "type":""})
						}
	 
						if (!cellValue.includes('Check') && !cellValue =='' ) {
							hasHeaderRow=true;
							// Create a select element with a unique ID
							var selectId = 'select-' + index;
							var listItem = $('<span><b>' + cellValue + '</b>: <br/><select class="selectSlot" id="' + selectId + '" name="'+cellValue+'"><option value="">Select</option>' + options + '</select></span><br/>');
							if(cellValue=='ID' || cellValue =='id'){
								listItem = $('<span> <span style="display:none"><select class="selectSlot"  id="' + selectId + '" name="'+cellValue+'"><option value="id" disabled="true" selected="true">id</option></select></span></span><br/>The IDs in the sheet are:<br/><input type="radio" id="newVals" name="idSelection" value="newValues"  checked="true"/><label for="newValues">New</label><br/><input type="radio" id="existingVal" name="idSelection" value="existingValues"/><label for="existingValues">Extracted from the repository</label><br/>');
								
							}else{
								hasHeaderRow=true;
								listItem = $('<span><b>' + cellValue + '</b>:<br/> <select class="selectSlot" id="' + selectId + '" name="'+cellValue+'"><option value="">Select</option>' + options + '</select></span><span  id="'+selectId+'Span" style="display:none;"><br/><b>Class</b>: <select class="selectSlot" id="' + selectId + 'Class" name="'+cellValue+'Class"><option value="">Select</option></select><br/></span><br/>');
								
							}
						
							list.append(listItem);
							
							function updateOrPush(array, obj) {
								const index = array.findIndex(item => item.column === obj.column);
					 
								if (index >= 0) {
									// Update existing object
									return array[index] = obj;
								} else {
									// Push new object
									return array.push(obj);
								}
							}

							// Initialise Select2 on the newly created select element
							$('#' + selectId).select2({width:'250px'});
							$('#' + selectId+'Class').select2({width:'250px'});

						//	$('#'+ selectId).val(cellValue).trigger('change');
							
							$('#' + selectId).on('change', function() {
								$('#' + selectId+'Class').empty();
								let selectedValue = $(this).find('option:selected').text();
								if (selectedValue !== undefined && selectedValue !== "") {
									if(selectedValue =='Select'){
										pairs=pairs.filter((e)=>{
											return e.column !=cellValue;
										})
										 
									}else{
								
									let match=classSlots.slots.find((d)=>{
										return d.name==selectedValue
									});

									console.log('m', match)
									   
										if(match.allowedValues && match.allowedValues?.length>1){

											let allValuesHaveLengthGreaterThanOne = match.allowedValues.every(value => value.length > 1);

											if (allValuesHaveLengthGreaterThanOne) {
												if(match.valueType=='Boolean'){
													updateOrPush(pairs, {"column":cellValue , "name": selectedValue, "type":"", "drop": selectId}) 
												}
												else{

													updateOrPush(pairs, {"column":cellValue , "name": selectedValue, "type":"", "drop": selectId}) 
													$('#'+selectId+'Span').show();
												
													let newSelect=$('#'+selectId+'Class')
													newSelect.append('<option value="">Select</option>');
													// Add options based on allowedValues in the match but if stakholders then only show a2r
													if(match.allowedValues.includes('ACTOR_TO_ROLE_RELATION') && match.allowedValues.length<5){
														newSelect.append('<option value="ACTOR_TO_ROLE_RELATION">ACTOR_TO_ROLE_RELATION</option>');
													}
													else{
														match.allowedValues.forEach(function(value) {
															newSelect.append('<option value="' + value + '">' + value + '</option>');
														});
													}
												}
											}else{
												updateOrPush(pairs, {"column":cellValue , "name": selectedValue, "type":"", "drop": selectId}) 
											}
										
										
										}else if(match.allowedValues?.length==1) {
											updateOrPush(pairs, {"column":cellValue , "name": selectedValue, "type":match.allowedValues[0], "drop": selectId, "cardinality":match.cardinality}) 

											if(match.allowedValues=='APP_PRO_TO_PHYS_BUS_RELATION'){
												$('#appType').show();
											}
											if(match.name=='provided_by_application_provider_roles') {
												console.log('match', match)
												$('#appTypeforAPR').show();
											}

										}
										else{ 
										updateOrPush(pairs, {"column":cellValue , "name": selectedValue, "type":"", "drop": selectId,"cardinality":match.cardinality}) 
										}
									}
								} else {
									//do nothing
								}
							 
							});
							$('#' + selectId+'Class').on('change', function() {
								let id=$(this).attr('id').replace("Class", "");
							 
							 	let mapped = pairs.find((p)=>{
									return p.drop==id;
								});
							 
								mapped.type=$(this).find('option:selected').text();
								 
								checkForRelations($(this).find('option:selected').text(), mapped.drop);
								 
							})
					
						}
					});
					 
					if(hasHeaderRow==true){
						$('#startRow').removeClass('headerRowColour')
					panelShift();
					}else{
						$('#startRow').addClass('headerRowColour') 
					}
   
				});

				$('#panelClose').on('click', function(){
					panelShift();
				})

	function panelShift(){
		var panel = document.getElementById('leftPanel');
		var content = document.querySelector('.main-content');
		panel.classList.toggle('open');
		content.classList.toggle('shifted');
	}
				
				// check For Relations so can add classes
function checkForRelations(selectedClass, col){
 
	let focusItem=pairs.find((p)=>{
		return p.drop==col;
	})
	 
	 
	if(selectedClass=='ACTOR_TO_ROLE_RELATION'){


		$('#stakeholderModal').modal('show');
		
		$('#saveStakeholders').off().on('click', function(){
		 
			var selectedValue = $('input[type="radio"][name="selection"]:checked').val();
			let thisRole, thisActorType, thisRoleType;
			 
			if(selectedValue=='useHeader'){
				thisRole=focusItem.column;
			}else{
				thisRole=$('#actorTextBox').val();
			}
			thisActorType=$('#actorType').val();
			if(thisActorType.includes('Group')){
				thisRoleType='Group_Business_Role';
			}else{
				thisRoleType='Individual_Business_Role';
			}
	 
			focusItem.name= focusItem.name
			focusItem['act_to_role_from_actor']=  {"className": thisActorType}
			focusItem['act_to_role_to_role']={"className": thisRoleType , "name":thisRole}

			const newItem = {
				...focusItem,
				'index': focusItem.drop.replace("select-", ""),
				'act_to_role_from_actor': {"className": thisActorType},
				'act_to_role_to_role': {"className": thisRoleType , "name": thisRole}
			};
			
			// Push the new object into stakeholderList
			stakeholderList.push(newItem);
  
		});
	} 
}


$('#saveMapping').on('click', function(){
	let fileNm = $('#fileUpload').val();
	let wsheet=$('#worksheetSelect').val().replace(/ /g, "_");

	// Step 1: Retrieve the existing object
	let storedData = localStorage.getItem(fileNm);
 

	let dataObject = storedData ? JSON.parse(storedData) : {};

	// Step 2: Update the specific array
	dataObject[fileNm] = dataObject[fileNm] || {};
	dataObject[fileNm][wsheet] = JSON.stringify(pairs) || []; 

	// Step 3: Save the updated object
	localStorage.setItem(fileNm, JSON.stringify(dataObject));
 
})
$('#loadMapping').on('click', function(){
	let fileNm = $('#fileUpload').val();
	let wsheet=$('#worksheetSelect').val().replace(/ /g, "_");
	let fetchedVal=localStorage.getItem(fileNm)
	let fetchedValJSON=JSON.parse(fetchedVal)

if (fetchedVal) {
    let fetchedValJSON = JSON.parse(fetchedVal);
    console.log('load', fetchedValJSON)

	if (fetchedValJSON[fileNm][wsheet]) {
		console.log('load2', JSON.parse(fetchedValJSON[fileNm][wsheet]))
		JSON.parse(fetchedValJSON[fileNm][wsheet]).forEach(item => {
			// Assuming 'drop' contains the ID of the select box
			const selectBoxId = item.drop;
	
			if (selectBoxId) {
				// Find the select box
				const selectBox = $('#' + selectBoxId);
				let found = false;
	
				// Debugging: Log the current item 
	
				// Iterate over each option
				selectBox.find('option').each(function() {
					let optionText = $(this).text().trim();
	
					// Debugging: Log the option being checked
			 
	
					if (optionText === item.name) {
			 
						selectBox.val($(this).val()).trigger('change');
						found = true; 
	
						return false; // break the loop
					}
				});
	
				// If no matching option was found, log an error or take necessary action
				if (!found) {
					console.error('No matching option found for', item.name);
				}
			}
		});
	}
}else{
console.log('problems')
}
})

				$('#generateJson').click(function() {
					$('#appType').hide();
					$('#appTypeforAPR').hide()
				
					jsonResult = [];
					selections = {};
				 
					selectPairs=[];
					let slotIndex=0;
					// Get the selected values from the panel

					pairs.forEach((e)=>{
						  
					 
					var columnIndex = getColumnIndexByName(doc, e.column, 0);  
					e['index']=columnIndex;
					if(selections[e.name]){
						//exists
						selections[e.name+columnIndex] = columnIndex; 
					}else{
						selections[e.name] = columnIndex; 
					}
					})
					idValue = $('input[type="radio"][name="idSelection"]:checked').val();

					const copyPairs = Object.assign({}, pairs);
					 
					if(idValue=='newValues'){
						pairs = pairs.filter((p)=>{
							return p.name!='id';
						})
					}
 
					createTable()
					  
				});


function createTable(){ 	
	
	const array2Mapping = stakeholderList.reduce((acc, item) => {
		acc[item.index] = item;
		return acc;
	  }, {});
 	
	// Iterate over each row in the table and map the data

	$('.table-container tr').each(function(rowIndex, tr) {
		if(rowIndex > 0) { // Skip the header row
			var rowData = {};
			$(tr).find('td').each(function(cellIndex, td) {
				var key = Object.keys(selections).find(key => selections[key] === cellIndex);
				if(key) { 
					rowData[key] = $(td).text();
				}
			});

			var nonEmptyValues = Object.values(rowData).filter(value => value !== '');
			var isIdKey = Object.keys(rowData).some(key => key.toLowerCase() === 'id' &&  rowData[key] === '');
			if (nonEmptyValues.length > 0 && !(nonEmptyValues.length === 1 && isIdKey)) {
				rowData['className']=$('#classes').val();
				jsonResult.push(rowData);
			}
		}
	});
 
	const stakeholderArray=[];
	function consolidateDynamicProperties(obj, basePropertyName) {
	 
		// Initialize an array to hold the values
		const consolidatedValues = [];
		
	
		// Regular expression to match dynamic properties (e.g., 'basePropertyName4')
		const regex = new RegExp(`^${basePropertyName}\\d+$`);
	
		let classNm=pairs.find((p)=>{
			return p.name == basePropertyName
		})
		 
		function addToConsolidatedValues(name, ctype, o, ky) {
	 
			if(ctype=='ACTOR_TO_ROLE_RELATION'){
		 
				if(ky){
					stakeholderArray.push({"id": o.name, name:o[ky], "key":[ky]})
				}
			}
			else{
				if (name) {  // Check if 'name' is not empty, null, or undefined
			 
					consolidatedValues.push({ 
						name: name, 
						className: ctype
					});
				}
			}
		}
	
		// Check if the base property exists and is not empty, then add it to the consolidated values
		if (obj.hasOwnProperty(basePropertyName)) { 
			addToConsolidatedValues(obj[basePropertyName], classNm.type, obj, basePropertyName);
			delete obj[basePropertyName]; // Optionally, remove the original base property
			 
		}
	
		// Iterate over the object keys
		for (const key in obj) {
			if (obj.hasOwnProperty(key) && regex.test(key)) {
				// If the key matches the pattern and value is not empty, transform its value and add it to the array
		  
				addToConsolidatedValues(obj[key], classNm.type, obj, key);
				
				// Optionally, delete the original dynamic property
				delete obj[key];
				 
			}
		}
		 
		// Assign the consolidated array of objects to the base property
		obj[basePropertyName] = consolidatedValues;
	 
		return obj;
	}

	function findDuplicateNames(data) {
		const nameCounts = {};
		const duplicates = [];
	
		// Count each name
		data.forEach(item => {
			nameCounts[item.name] = (nameCounts[item.name] || 0) + 1;
		});
	
		// Find names that appear more than once
		for (const name in nameCounts) {
			if (nameCounts[name] > 1) {
				duplicates.push(name);
			}
		}
	
		return duplicates;
	}
	
	const duplicateNames = findDuplicateNames(pairs);
	 
 
	jsonResult.forEach((o)=>{
	 
		duplicateNames.forEach((nm) => {
 
				consolidateDynamicProperties(o, nm);
  
		});
 
		if (o.className === 'Physical_Process') { 
		 
			o['name']= o.process_performed_by_actor_role +' performing '+ o.implements_business_process;
			pairs.push({id:"name", name:"name"})
				
			
			}
			

	}) 
 
	stakeholderArray.forEach((st)=>{
		st['index']= selections[st.key[0]]
	}) 
	
	// Function to transform the array into the desired object structure for each data object
	function transformArrayToObject(arr, dataObject) {
	//	console.log('arr',arr);
	//	console.log('dataObject',dataObject);
		const resultObject = {};
		resultObject['className']=$('#classes').val();

		// add names for classes based on relations

		let selectedClass = $('#classes').val();
		let roleName, serviceName;
		
		switch (selectedClass) {
			case 'Application_Provider_Role':
				roleName = dataObject['role_for_application_provider'];
				serviceName = dataObject['implementing_application_service'];
				break;
			case 'Technology_Product_Role':
			case 'Technology_Product_Build_Role':
				roleName = dataObject['role_for_technology_provider'];
				serviceName = dataObject['implementing_technology_component'];
				break;
			default:
				// Optionally handle other cases or do nothing
				break;
		}
		
		if (roleName && serviceName) {
			resultObject['name'] = roleName + ' as ' + serviceName;
		}
		 
		arr.forEach(item => {
	  
			if (item.type) {
				createObject(resultObject,item, dataObject)
			} else {
				resultObject[item.name] = dataObject[item.name] || null;
			}
		});
 //code to build stakeholder structure
	const groupedResult = stakeholderArray.reduce((acc, item) => {
		const match = array2Mapping[item.index];
		if (match) {
		  const stakeholder = {
			className: "ACTOR_TO_ROLE_RELATION",
			name: `${item.name} as ${match.act_to_role_to_role.name}`,
			act_to_role_to_role: match.act_to_role_to_role,
			act_to_role_from_actor: {
			  className: match.act_to_role_from_actor.className,
			  name: item.name
			}
		  };
	  
		  if (!acc[item.id]) {
			acc[item.id] = { className: "Data_Subject", name: item.id, stakeholders: [] };
		  }
	  
		  acc[item.id].stakeholders.push(stakeholder);
		}
		return acc;
	  }, {});
	  
	  // If stakeholders in the array then structure the actor to role code 
	  if(duplicateNames.includes('stakeholders')){
	  const finalResult = Object.values(groupedResult);
	 
	  let stks=Object.values(groupedResult).filter((e)=>{return e.name==resultObject.name})
  
		if(stks.length >0){
		resultObject.stakeholders=stks[0].stakeholders
		} 
	  }
		return resultObject;
	}
	
	//check for relationship patterns

	

	function createObject(obj, data, dob) {
	 /*
 console.log('obj', obj);
 console.log('data', data);
 console.log('dob', dob);
 */

		 if(!data.hasOwnProperty('cardinality')){
			console.log('get card')
			let match=classSlots.slots.find((e)=>{
				return e.name==data.name
			})
			data['cardinality']=match.cardinality

		 }
			if(data.type=='APP_PRO_TO_PHYS_BUS_RELATION'){
			 
				let classForApp=$('#appTypeSelect').val();
				if (dob[data.name].includes(' as ')) {
					obj[data.name] = [{
						className: data.type,
						name: dob[data.name] || null,
						apppro_to_physbus_from_appprorole: {"className": "Application_Provider_Role","name":dob[data.name]}
					}];
				}else{
					obj[data.name] = [{
						className: data.type,
						name: dob[data.name] || null,
						apppro_to_physbus_from_apppro: {"className": classForApp,"name":dob[data.name]}
					}];
				}
				//
			}
			
			else if (data.type === 'ACTOR_TO_ROLE_RELATION') { 
			 
			const actorName = dob['stakeholders']; 
		 
			// Create a new object for act_to_role_from_actor to avoid shared reference issues
			const actToRoleFromActor = {
				...data.act_to_role_from_actor, // copy existing properties
				name: actorName || dob.process_performed_by_actor_role// set/update the name
			}; 
			// Construct the new object

			if (obj[data.name]) {
				// Add the new object to the existing array
				obj[data.name].push({
					className: data.type, 
					name: (dob[data.name] ? dob[data.name] + ' as ' : '') + (data.act_to_role_to_role.name || ''),
					act_to_role_to_role: data.act_to_role_to_role,
					act_to_role_from_actor: actToRoleFromActor
				});
			} else {
				// Create a new array with the new object
				obj[data.name] = [{
					className: data.type, 
					name: (dob[data.name] ? dob[data.name] + ' as ' : '') + (data.act_to_role_to_role.name || ''),
					act_to_role_to_role: data.act_to_role_to_role,
					act_to_role_from_actor: actToRoleFromActor
				}];
			}
			// console.log('new a2r obj', obj)
		}
		else if ((dob.className === "Composite_Application_Provider" || dob.className === "Application_Provider") && data.name ==="provides_application_services") {
 
			if (obj[data.name]) {
				console.log('already exists');
					obj[data.name].push({
						className: data.type,
						name: obj.name + ' as ' + dob[data.name]|| null,
						implementing_application_service: {
							className: 'Application_Service',
							name: dob.provides_application_services
						}
					});
				}
				else	{
					 
					obj[data.name] = [{
						className: data.type,
						name: obj.name + ' as ' + dob[data.name]|| null,
						implementing_application_service: {
							className: 'Application_Service',
							name: dob.provides_application_services
						}
					}];
				}	
		}else if ((dob.className === "Technology_Product" || dob.className === "Technology_Product_Build") && data.name ==="implements_technology_components") {
			let cls='Technology_Component';
			if( dob.className.includes("Build")){ 
				cls='Technology_Composite';
			}
 
			if (obj[data.name]) {
				console.log('already exists');
					obj[data.name].push({
						className: data.type,
						name: obj.name + ' as ' + dob[data.name]|| null,
						implementing_technology_component: {
							className:cls,
							name: dob.implements_technology_components
						}
					});
				}
				else	{
				 
					obj[data.name] = [{
						className: data.type,
						name: obj.name + ' as ' + dob[data.name]|| null,
						implementing_technology_component: {
							className: cls,
							name: dob.implements_technology_components
						}
					}];
				}	
		}else if ((dob.className === "Technology_Component" || dob.className === "Technology_Product_Build") && data.name ==="realised_by_technology_products") {
			let cls='Technology_Product';
			if( dob.className.includes("Composite")){ 
				cls='Technology_Product_Build';
			}
 
			if (obj[data.name]) {
				console.log('already exists');
					obj[data.name].push({
						className: data.type,
						name: obj.name + ' as ' + dob[data.name]|| null,
						role_for_technology_provider: { 
							className: cls,
							name: dob.realised_by_technology_products
						}
					});
				}
				else	{
					 
					obj[data.name] = [{
						className: data.type,
						name: obj.name + ' as ' + dob[data.name]|| null,
						role_for_technology_provider: {
							className: cls,
							name: dob.realised_by_technology_products
						}
					}];
				}	
		} 
	 
			else if ((dob.className === "Application_Service" || dob.className === "Composite_Application_Service") && data.name ==="provided_by_application_provider_roles") {
				let classForApp=$('#appTypeforAPRSelect').val();
				if (obj[data.name]) {
					console.log('already exists');
						obj[data.name].push({
							className: data.type,
							name: obj.name + ' as ' + dob[data.name]|| null,
							role_for_application_provider: { 
								className: classForApp,
								name: dob.provided_by_application_provider_roles
							}
						});
					}
					else	{
						 
						obj[data.name] = [{
							className: data.type,
							name: obj.name + ' as ' + dob[data.name]|| null,
							role_for_application_provider: {
								className: classForApp,
								name: dob.provided_by_application_provider_roles
							}
						}];
					}	
			}
		else {
			// Handling other types
	 
				 if(data.cardinality=='multiple'){  
					if (Array.isArray(dob[data.name])) {
						 
						obj[data.name] = dob[data.name]
					}else{
						if(dob[data.name]!=''){
							obj[data.name] = [{
								className: data.type,
								name: dob[data.name] || null
							}];
						}
					}
				}else{
					if(dob[data.name]!=''){
						obj[data.name] = {
							className: data.type,
							name: dob[data.name] || null
						};
					}
				}
			 
		}
 
	}
	
	// Transform each object in the data array

	let transformedDataArray = jsonResult.map(dataObject => transformArrayToObject(pairs, dataObject));
	console.log('transformedDataArray',transformedDataArray)
	if(transformedDataArray[0].className=='Physical_Process' && Array.isArray(transformedDataArray[0].phys_bp_supported_by_app_pro) &&   transformedDataArray[0].phys_bp_supported_by_app_pro.length>0){
		let combinedResults = transformedDataArray.reduce((acc, obj) => {
			// Check if the object with the same name already exists in the accumulator
			if (acc[obj.name]) {
				// If it exists, push the current phys_bp_supported_by_app_pro into the array
				acc[obj.name].phys_bp_supported_by_app_pro.push(obj.phys_bp_supported_by_app_pro[0]);
			} else {
				// If it does not exist, create a new object and start an array for phys_bp_supported_by_app_pro
				acc[obj.name] = { ...obj, phys_bp_supported_by_app_pro: obj.phys_bp_supported_by_app_pro };
			}
			return acc;
		}, {});
		
		// Convert the combinedResults object back into an array
		let combinedArray = Object.values(combinedResults);
		transformedDataArray=combinedArray
		 
	} else if((transformedDataArray[0].className=='Composite_Application_Provider' || transformedDataArray[0].className=='Application_Provider') && Array.isArray(transformedDataArray[0].provides_application_services) &&  transformedDataArray[0].provides_application_services.length>0){
		console.log('transformedDataArray',transformedDataArray)
		let combinedResults = transformedDataArray.reduce((acc, obj) => {
			
			// Check if the object with the same name already exists in the accumulator
			if (acc[obj.name]) {
				// If it exists, push the current provides_application_services into the array
				acc[obj.name].provides_application_services.push(obj.provides_application_services[0]);
			} else {
				// If it does not exist, create a new object and start an array for phys_bp_supported_by_app_pro
				acc[obj.name] = { ...obj, provides_application_services: obj.provides_application_services };
			}
			return acc;
		}, {});
		
		// Convert the combinedResults object back into an array
		let combinedArray = Object.values(combinedResults);
		transformedDataArray=combinedArray
		 
	}else if((transformedDataArray[0].className=='Technology_Product' || transformedDataArray[0].className=='Technology_Product_Build') && Array.isArray(transformedDataArray[0].implements_technology_components) &&  transformedDataArray[0].implements_technology_components.length>0){
		let combinedResults = transformedDataArray.reduce((acc, obj) => {
			console.log('acc', acc)
			console.log('obj', obj)
			// Check if the object with the same name already exists in the accumulator
			if (acc[obj.name]) {
				// If it exists, push the current implements_technology_components into the array
				acc[obj.name].implements_technology_components.push(obj.implements_technology_components[0]);
			} else {
				// If it does not exist, create a new object and start an array for phys_bp_supported_by_app_pro
				acc[obj.name] = { ...obj, implements_technology_components: obj.implements_technology_components };
			}
			return acc;
		}, {});
		
		// Convert the combinedResults object back into an array
		let combinedArray = Object.values(combinedResults);
		transformedDataArray=combinedArray
		 
	}else if((transformedDataArray[0].className=='Technology_Component' || transformedDataArray[0].className=='Technology_Composite') &&  Array.isArray(transformedDataArray[0].realised_by_technology_products) && transformedDataArray[0].realised_by_technology_products.length>0){
		let combinedResults = transformedDataArray.reduce((acc, obj) => {
			console.log('acc', acc)
			console.log('obj', obj)
			// Check if the object with the same name already exists in the accumulator
			if (acc[obj.name]) {
				// If it exists, push the current realised_by_technology_products into the array
				acc[obj.name].realised_by_technology_products.push(obj.realised_by_technology_products[0]);
			} else {
				// If it does not exist, create a new object and start an array for phys_bp_supported_by_app_pro
				acc[obj.name] = { ...obj, realised_by_technology_products: obj.realised_by_technology_products };
			}
			return acc;
		}, {});
		 
		// Convert the combinedResults object back into an array
		let combinedArray = Object.values(combinedResults);
		transformedDataArray=combinedArray
		 
	}else if((transformedDataArray[0].className=='Application_Service' || transformedDataArray[0].className=='Composite_Application_Service') && Array.isArray(transformedDataArray[0].provides_application_services) &&  transformedDataArray[0].provided_by_application_provider_roles.length>0){
		let combinedResults = transformedDataArray.reduce((acc, obj) => {
			console.log('acc', acc)
			console.log('obj', obj)
			// Check if the object with the same name already exists in the accumulator
			if (acc[obj.name]) {
				// If it exists, push the current provided_by_application_provider_roles into the array
				acc[obj.name].provided_by_application_provider_roles.push(obj.provided_by_application_provider_roles[0]);
			} else {
				// If it does not exist, create a new object and start an array for phys_bp_supported_by_app_pro
				acc[obj.name] = { ...obj, provided_by_application_provider_roles: obj.provided_by_application_provider_roles };
			}
			return acc;
		}, {});
		 
		// Convert the combinedResults object back into an array
		let combinedArray = Object.values(combinedResults);
		transformedDataArray=combinedArray
		 
	}
	console.log('ta', transformedDataArray);
	function combineObjectsWithSameName(array) {
		const combinedObjects = {};
	
		array.forEach(item => {
			if (!combinedObjects[item.name]) {
				combinedObjects[item.name] = { ...item };
			} else {
				// Iterate over all properties in the item
				for (const prop in item) {
					// Check if the property is an array and needs to be merged
					if (Array.isArray(item[prop])) {
						if (combinedObjects[item.name][prop]) {
							combinedObjects[item.name][prop] = [
								...combinedObjects[item.name][prop],
								...item[prop]
							];
						} else {
							combinedObjects[item.name][prop] = [...item[prop]];
						}
					} else {
						// For non-array properties, you might want to overwrite or do something else
						combinedObjects[item.name][prop] = item[prop];
					}
				}
			}
		});
	
		return Object.values(combinedObjects);
	}
	  

	let repoJSON=combineObjectsWithSameName(transformedDataArray);
console.log('repoJSON',repoJSON)
	 sendToRepository(repoJSON);

}


function mergeObjects(obj1, obj2) {
    // Helper function to merge two objects
    function mergeTwoObjects(o1, o2) {
        for (const key in o2) {
            if (o2.hasOwnProperty(key)) {
                if (Array.isArray(o2[key])) {
                    o1[key] = o1[key] || [];
                    o1[key] = mergeArrays(o1[key], o2[key]);
                } else if (typeof o2[key] === 'object' && o2[key] !== null) {
                    o1[key] = o1[key] || {};
                    mergeTwoObjects(o1[key], o2[key]);
                } else {
                    o1[key] = o2[key];
                }
            }
        }
    }

    // Helper function to find an item in an array by name
    function findItemByName(array, itemName) {
        return array.find(el => el.name === itemName);
    }

    // Helper function to merge arrays of objects
    function mergeArrays(array1, array2) {
        const merged = [...array1];
        array2.forEach(item2 => {
            const matchingItem = findItemByName(merged, item2.name);
            if (matchingItem) {
                mergeTwoObjects(matchingItem, item2);
            } else {
                merged.push(item2);
            }
        });
        return merged;
    }

    // Start merging obj2 into obj1
    mergeTwoObjects(obj1, obj2);
    return obj1;
}
 
 
function sendToRepository(data){
	let slotList='';
	multiple.forEach((m)=>{
		slotList=slotList+'^'+m.name;
	})
	const uri = 'classes/'+ data[0].className +'/instances?filter=&maxdepth=1&slots=name'+slotList;
	const encoded = encodeURI(uri);
  
	essPromise_getAPIElements('/essential-utility/v3', encoded)
	.then(function(response) {
		 
		 data = data.map(d => {
			let match = response.instances.find(r => d.id == r.id || d.name == r.name);
			console.log('match', match);
			if (match) {
				const mergedObject = mergeObjects(match, d);
				return mergedObject; // Return the merged object to replace d
			}
			return d; // If no match, return d as it is
		}); 
		data=data.filter((d)=>{
			return d.name !== null
		})

		let jsonToLoad={"instances":data}
		
		console.log('data3',data)
		$('#dataCount').text(data.length)
		$('#mapSpinner').show();
		essPromise_createAPIElement('/essential-utility/v3', jsonToLoad, 'instances/batch?reuse=true')
		.then(function(response) {
			console.log('response', response)
			$('#mapSpinner').hide();
		})
	}) 
 
}

function getColumnIndexByName(doc, columnName, rowIndex) {
	// Find the nth row based on the provided rowIndex
	var headers = $(doc).find('table').find('tr').eq(rowIndex).find('td, th');
	
	for (var i = 0; i < headers.length; i++) {
		if ($(headers[i]).text().trim() === columnName) {
			return i; // Return the zero-based index of the column
		}
	}
	return -1; // Return -1 if the column name is not found
}



$('#loadMappingFile').off().on('click', function(){
	console.log('loading')
	$('#jsonfileInput').click();
})

$('#jsonfileInput').change(function(event) {
	console.log('loadinfileing')
    let file = event.target.files[0];

    if (file) {
        // Create a FileReader to read the file
        let reader = new FileReader();
        reader.onload = function(e) {
            let contents = e.target.result;

            // Assuming the file content is a valid JSON
            try {
                let json = JSON.parse(contents);

                // Get the file name from another input field
                let fileNm = $('#fileUpload').val();

                if (fileNm) {
                    // Save the JSON to local storage
                    localStorage.setItem(fileNm, JSON.stringify(json));
                    
                }  
            } catch (error) {
                alert('Error parsing JSON file: ' + error.message);
            }
        };
        reader.readAsText(file);
    } else {
        alert('No file selected.');
    }
});


$('#saveMappingFile').off().on('click', function(){
	console.log('saving')
	let fileNm = $('#fileUpload').val();
    let data = localStorage.getItem(fileNm);

    if (data) {
        // Convert data to JSON format
        let json = JSON.stringify(JSON.parse(data), null, 4); // Beautify the JSON

        // Create a Blob from the JSON
        let blob = new Blob([json], {type: 'application/json'});

        // Create a link and set the URL using createObjectURL
        let url = URL.createObjectURL(blob);
        let a = document.createElement('a');
        a.href = url;
        a.download = fileNm.split('\\').pop() + '.json'; // Extract filename and add .json extension

        // Append link to the body, trigger click, and remove it
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

        // Revoke the object URL to free up resources
        URL.revokeObjectURL(url);
    } else {
        alert('No data found for the specified file name in local storage.');
    }
})

			