const easConstants={
	dataVersion:'16',
	nullPlaceholder:'N/A',
	apiCataloguePath: 'enterprise/api/dashboards/core_api_el_dash_api_catalogue.xsl',
	apiURLPrefix: 'reportApi?XML=reportXML.xml&XSL='
};

//const apiCataloguePath = 'enterprise/api/dashboards/core_api_el_dash_api_catalogue.xsl';
//const apiURLPrefix = 'reportApi?XML=reportXML.xml&XSL=';
var easDataApi = {};
var easDataCatalogue = {};

function initDataSourcesDataTable(){
    
    var table = $('#dataSourcesTable').DataTable({
    paging: false,
    deferRender:    true,
    scrollY:        350,
    scrollCollapse: true,
    info: true,
    sort: true,
    responsive: false,
    columns: [
    	{ "width": "30%" },
    	{ "width": "50%" },
    	{ "width": "20%" }
      ]
    });

}

function easGetValuesFromForm(elements){
	var values={};
	for(var i=0;i<elements.length;i++){
		var element=elements[i];
		switch(element.type){
			case 'checkbox':
				values[element.name]=element.checked;
				break;
			default:
				values[element.name]=element.value;
				break;
		}
	}
	return values;
}
  
function easPopulateForm(elements,values){
	//validate incoming data
	if(typeof values==='object'){

	}else{
		values={};
	}

	for(var i=0;i<elements.length;i++){
		var element=elements[i];
		if(values[element.name]==null){

		}else{
			switch(element.type){
				case 'checkbox':
					element.checked=values[element.name];
					break;
				default:
					element.value=values[element.name];
					break;
			}
		}
	}
}
  
function DataSourceContainer(parent){
	this.parent=parent;
	this.domNode=null;
	this.formNode=null;
}
DataSourceContainer.prototype.html='<div><form id="newWidgetDialogDataSourcesForm"></form></div>';
DataSourceContainer.prototype.destroy=function(){
	this.domNode.parentNode.removeChild(this.domNode);
}
DataSourceContainer.prototype.init=function(parentNode){
	this.domNode=$.parseHTML(this.html)[0];
	parentNode.appendChild(this.domNode);
	this.formNode=this.domNode.children[0];
	this.show();
}

DataSourceContainer.prototype.getSelected=function(){
	var elements=this.formNode.elements;
	var selected=easGetValuesFromForm(elements);
	return selected;
}
DataSourceContainer.prototype.onSelectedChange=function(){
	//clear existing options
	this.optionsDiv.innerHTML='';
	var id=this.getSelected().id;
	this.parent.onDataSourceSelectedChange(this);
};
DataSourceContainer.prototype.show=function(){
	function onDataSources(dataSources){
		//go through and remove any that are already selected
		for(var i=0;i<self.parent.dataSourceContainers.length;i++){
			var dataSourceContainer=self.parent.dataSourceContainers[i];
			delete dataSources[dataSourceContainer.getSelected().id];
		}
		self.dataSources=dataSources;
		var numDataSources=0;
		var html='<select name="id" class="form-control bottom-10">';
		for(var id in dataSources){
			numDataSources=numDataSources+1;
			html+='<option value="'+id+'">'+dataSources[id].label+'</option>';
		}
		html+='</select><div></div>';
		if(numDataSources===0){
			html='No data sources available.';
		}
		self.formNode.innerHTML=html;
		if(self.formNode.children.length>0){
			self.formNode.children[0].addEventListener('change',function(){self.onSelectedChange()});
			self.optionsDiv=self.formNode.children[1];
			self.onSelectedChange();
		}
	}
	this.formNode.innerHTML='Loading...';
	var self=this;
	var previousDataSource=null;
	if(this.parent.dataSourceContainers.length>0){
		previousDataSource=this.parent.dataSourceContainers[0];
	}
	easApi.getDataSources(previousDataSource).then(onDataSources);
}
  
var newWidgetDialog={
	dataSourceContainers:[],
	dataSourcesNode:null,
	domNode:null,
	init:function(){
		this.dataSourcesNode=document.getElementById('newWidgetDialogDataSourcesContainer');
		this.domNode=document.getElementById('newWidgetDialog');
		this.nameInput=document.getElementById('newWidgetDialogName');
	},
	hide:function(){
		$(this.domNode).hide();
	},
	onAddAnotherDataSourceClick:function(){
		//we need to pass the previously selected data source
		//to the picker so it can fetch the meta and know what other
		//data sources to show
		var dataSourceContainer=new DataSourceContainer(this);
		dataSourceContainer.init(this.dataSourcesNode);
		this.dataSourceContainers.push(dataSourceContainer);
	},
	onAddClick:function(){
		if(!this.nameInput.value?.length > 0) {
			$('#newWidgetDialogError').text('The new table must have a name');
			return;
		}

		var dataSourceContainer,
			i,
			gridInfo={
			id:'id'+new Date().getTime()+parseInt(Math.random()*100)
		};
		var widgetInfo={
			dataSources:[],
			options:{
			},
			id:gridInfo.id,
			name: this.nameInput.value,
			type:'pivottable'
		};
		let tableDesc = $('#newWidgetDialogDesc').val();
		if(tableDesc?.length > 0) {
			widgetInfo.description = tableDesc;
		}

		var optionsForm=document.getElementById('newWidgetDialogFormpivottable');
		widgetInfo.options=easGetValuesFromForm(optionsForm.elements);
		console.log('Widget Info', widgetInfo);
		for(i=0;i<this.dataSourceContainers.length;i++){
			dataSourceContainer=this.dataSourceContainers[i];
			var values=dataSourceContainer.getSelected();
			if(values==null || values.id==null){

			}else{
				widgetInfo.dataSources.push(values);
			}
		}
 
		var select=document.getElementById('selectedWidgetSelect');
		select.innerHTML+='<option value="'+gridInfo.id+'">'+widgetInfo.name+'</option>';
		select.value=gridInfo.id;
		var data=easData;
		data.widgetInfo[gridInfo.id]=widgetInfo;
		onSelectedWidgetChange();
		$('#newTableModal').modal('hide');
	},
	onDataSourceSelectedChange:function(dataSourceContainer){
		//remove any data sources below this one
		var canRemove=false,
			i;
		for(i=0;i<this.dataSourceContainers.length;i++){
			if(canRemove){
				this.dataSourceContainers[i].destroy();
				this.dataSourceContainers.splice(i,1);
				i--;
			}else{
				if(this.dataSourceContainers[i]===dataSourceContainer){
					canRemove=true;
				}
			}
		}
	},
	onTypeChange:function(){
		if(this.optionsNode){
			$(this.optionsNode).hide();
		}
		var type='pivottable';
		this.optionsNode=document.getElementById('newWidgetDialogOptions'+type);
		$(this.optionsNode).show();
		if(this.dataSourceContainers.length===0){
			this.onAddAnotherDataSourceClick();
		}
	},
	resetDataSources:function(){
		var dataSourceContainer,
			i;
		for(i=0;i<this.dataSourceContainers.length;i++){
			dataSourceContainer=this.dataSourceContainers[i];
			dataSourceContainer.destroy();
		}
		this.dataSourceContainers=[];
	},
	show:function(){
		this.resetDataSources();
		this.onTypeChange();
		//this.nameInput.value='New Table';
		$(this.domNode).show();
	},
	//nameInput:null
}
  
//loads data stored in local storage
function loadStoredDashboards(){
	var data=localStorage.easDashboard;
	try{
		data=JSON.parse(data);
		console.log('Local Data', data);
		//check if old style of local data
		if(data.version!=easConstants.dataVersion){
			throw 'Wrong version';
		}
	}catch(err){
		//data=JSON.parse('{"version":"16","dashValues":{"rangeStart":"now - 12 months","rangeEnd":"now"},"widgetInfo":{"id16145178631974":{"id":"id16145178631974","name":"First Table","dataSources":[{"id":"store_389_Class10001"},{"id":"store_389_Class10116"},{"id":"store_389_Class10112"},{"id":"store_389_Class10114"},{"id":"qualifiers"}],"options":{"pivottableConfig":{"derivedAttributes":{},"hiddenAttributes":[],"hiddenFromAggregators":[],"hiddenFromDragDrop":[],"menuLimit":500,"cols":["Applications.name"],"rows":["Organisations.name"],"vals":[],"rowOrder":"key_a_to_z","colOrder":"key_a_to_z","exclusions":{},"inclusions":{},"unusedAttrsVertical":true,"autoSortUnusedAttrs":false,"showUI":true,"sorters":{},"inclusionsInfo":{},"aggregatorName":"Count","rendererName":"Table","rendererOptions":{"sort":{"direction":"desc","column_key":["AMS Fleet Solution"]}}}},"type":"pivottable"}},"widgets":[{"id":"id16145178631974","name":"Table 1"}]}');
		data=JSON.parse('{"version":"' + easConstants.dataVersion + '","dashValues":{"rangeStart":"now - 12 months","rangeEnd":"now"},"widgetInfo":{},"widgets":[]}');
	}

	return data;
}
  
function saveData(data){
	localStorage.setItem('easDashboard',JSON.stringify(data));
}
  
function easApiPerform(value){
	//console.log('Getting API Data', value);
	function f(resolveFunc,rejectFunc){
		setTimeout(function(){
			resolveFunc(value);
		},500);
	}
	return f;
}
  
function easFindQualifier(qualifierMeta,qualifiers,rawLabel,qualId){
	var field,
		qualInfo={
			label:rawLabel,
			name:easConstants.nullPlaceholder
		},
		row;

	//get the correct label
	if(qualifierMeta[rawLabel]==null){

	}else{
		qualInfo.label=qualifierMeta[rawLabel]['label'];
	}

	for(field in qualifiers){
		for(i=0;i<qualifiers[field].data.length;i++){
			row=qualifiers[field].data[i];
			if(row.id===qualId){
				qualInfo.name=row.name;
			}
		}
	}
	if(qualInfo.name==null){
		qualInfo.name=easConstants.nullPlaceholder;
	}
	return qualInfo;
}
  
function easCleanPivotRow(firstTableName,columns,row){
	var col;

	for(col in row){
		//get rid of any arrays or ids
		if(col==='id' || col.endsWith('.id') || row[col].constructor===Array){
			delete row[col];
		}else if(col.indexOf('.')===-1){
			//make sure every field is prefixed with their table name
			row[firstTableName+'.'+col]=row[col];
			let datasetLabel = getCanonicalLabel(firstTableName+'.'+col);
			canonicalDataLabels[firstTableName+'.'+col] = datasetLabel;
			delete row[col];
		}
	}
	//add the columns to our set of valid columns
	for(col in row){
		columns[col]=col;
	}
	
	return row;
}
  
function easCleanPivotData(firstTableName,data){
	var columns={},
		i,
		row;
	//remove any fields that are arrays
	for(i=0;i<data.length;i++){
		row=data[i];
		row=easCleanPivotRow(firstTableName,columns,row);
		data[i]=row;
	}
	//second pass, add any missing columns as N/A to get rid of null values
	for(i=0;i<data.length;i++){
		row=data[i];
		for(col in columns){
			if(row[col]==null){
				row[col]=easConstants.nullPlaceholder;
			}
		}
	}
	return data;
}
  
var canonicalDataLabels = {};

function easMergePivotRows(firstTableName,useNA,orginalColName,tableName,row,newrow){
	var col,
		mergedRow={};
	//copy original data across
	for(col in row){
		mergedRow[col]=row[col];
	}
	//deal with merging on a column that came from another table previously merged
	var parts=orginalColName.split('.');
	if(parts.length>1){
		parts.splice(parts.length-1,1);
		parts.push(tableName);
		tableName=parts.join('.');
	}else{
		tableName=firstTableName+'.'+tableName;
		
	}

	//now copy new data across but avoiding overwriting old data
	for(col in newrow){
		//prefix col with the table name of the new data
		mergedRow[tableName+'.'+col]=newrow[col];
		if(useNA || mergedRow[tableName+'.'+col]==null){
			mergedRow[tableName+'.'+col]=easConstants.nullPlaceholder;
		}
		let tableLabel = getCanonicalLabel(tableName+'.'+col);
		canonicalDataLabels[tableName+'.'+col] = tableLabel;
	}
	return mergedRow;
}

  
function easMergePivotData(mergedColumns,flattenedData,firstSet,newSetInfo){	
	var addedCol=false,
		col,
		i,
		j,
		merged,
		mergedData=[],
		mergedRow,
		newSet=newSetInfo.data,
		newrow,
		row;

	//so we need to look at the newSet, get the type, go through the meta.properties looking for a match, then we have our field name
	for(col in firstSet.meta.properties){
		if(mergedColumns.indexOf(col)>-1){
			continue;
		}
		if(firstSet.meta.properties[col].type===newSetInfo.data.meta.type){
			mergedColumns.push(col); //so we don't merge it again
			//for each row in our already flattened data
			for(i=0;i<flattenedData.length;i++){
				row=flattenedData[i];
				merged=false;
				//get the ids to use for merging
				var idsToMerge=row[col];
				if(idsToMerge==null){
					idsToMerge=[];
				}
				for(j=0;j<idsToMerge.length;j++){
					var id=idsToMerge[j];
					//find the appropriate row in the newSet 
					for(k=0;k<newSet.data.length;k++){
						newrow=newSet.data[k];
						if(newrow.id===id){
							mergedRow=easMergePivotRows(firstSet.meta.label,false,col,newSetInfo.data.meta.label,row,newrow);
							mergedData.push(mergedRow);
							merged=true;
							//we don't need to do any more copying for this row
							break;
						}
					}
				}
				if(merged===true){
					//we don't need to add the merged version
				}else{
					//deal with merging in another table but with N/A to indicate we had no match
					if(newrow==null){
						newrow=newSet.data[0];
					}
					mergedRow=easMergePivotRows(firstSet.meta.label,true,col,newSetInfo.data.meta.label,row,newrow);
					mergedData.push(row);
				}
			}
			flattenedData=mergedData;
			mergedData=[];
		}
	}
		
	//if we merge in the meta data then any data that can be merged
	//to this new table should also be merged
	for(col in newSetInfo.data.meta.properties){
		var canonicalName=firstSet.meta.label+'.'+newSetInfo.data.meta.label+'.'+col;
		if(firstSet.meta.properties[canonicalName]==null){
			firstSet.meta.properties[canonicalName]=newSetInfo.data.meta.properties[col];
			addedCol=true;
		}
		//if we have added any new columns for merging then we need to go back through
		//through all the other tables to see if another merge can be done again
	}
	

	//create a textarea and append it to the perge with out merged data
	/*var element=document.createElement('textarea');
	element.innerHTML=JSON.stringify(mergedData);
	document.body.appendChild(element);*/
	//console.log('Added Column', addedCol);
	//console.log('Flattened Data', flattenedData);
	return {
		addedCol:addedCol,
		data:flattenedData
	};
}

function getCanonicalLabel(canonicalName) {
	//let newName = canonicalName;
	//return newName.replace(/[.]/g, ' ');
	let labelSegments = canonicalName.split('.');
	let segmentCount = labelSegments.length;
	if(segmentCount == 1) {
		return labelSegments[segmentCount - 1];
	} else if(segmentCount == 2) {
		if(labelSegments[segmentCount - 1] == 'name') {
			return labelSegments[segmentCount - 2]
		} else {
			return labelSegments[segmentCount - 1] + ' (of ' + labelSegments[segmentCount - 2] + ')';
		}
	} else if(segmentCount > 1) {
		if(labelSegments[segmentCount - 1] == 'name') {
			return  labelSegments[segmentCount - 2] + ' (of ' + labelSegments[segmentCount - 3] + ')';
		} else {
			return labelSegments[segmentCount - 1] + ' (of ' + labelSegments[segmentCount - 2] + ')';
		}
	} else {
		return canonicalName;
	} 
}
  
var easApi={
	getAllData:function(dataSources){
		function resolveFunc(resolveFunc,rejectFunc){
			resolveFunc(dataSources);
		}

		function onData(resolveFunc,dataSource){
			function f(data){
				dataSource.data=data;
				getNextData(resolveFunc);
			}
			return f;
		}

		function getNextData(resolveFunc){
			//get the first source that has no data
			for(var i=0;i<dataSources.length;i++){
				var dataSource=dataSources[i];
				if(dataSource.data==null){
					easApi.getDataSource(dataSource).then(onData(resolveFunc,dataSource));
					return;
				}
			}

			//if we got here then we have all the data
			resolveFunc(dataSources);
		}

		//if the last data source isn't the qualifiers then put them on
		if(dataSources.length>0 && dataSources[dataSources.length-1].id!=='qualifiers'){
			dataSources.push({
				id:'qualifiers'
			});
		}

		var promise=new Promise(function(resolveFunc,rejectFunc){
			getNextData(resolveFunc);
		});

		return promise;
	},
	getDataSource:function(options){
		var data=JSON.parse(JSON.stringify(easDataApi[options.id]));
		//use dash range or override?
		var dashValues=easGetValuesFromForm(document.forms.namedItem('dash').elements);
		var start='';
		if(options.start && options.start.length>0){
			start=easParseDate(options.start);
		}else if(dashValues && dashValues.rangeStart && dashValues.rangeStart.length>0){
			start=easParseDate(dashValues.rangeStart);
		}
		if(start.length>0 && data.data!=null){
			//try to filter out data before our start
			for(var i=0;i<data.data.length;i++){
				if(data.data[i].x<start){
					data.data.splice(i,1);
					i--;
				}
			}
		}
			
		var end='';
		if(options.end && options.end.length>0){
			end=easParseDate(options.end);
		}else if(dashValues && dashValues.rangeEnd && dashValues.rangeEnd.length>0){
			end=easParseDate(dashValues.rangeEnd);
		}
		if(end.length>0 && data.data!=null){	
			//try to filter out data before our start
			for(var i=0;i<data.data.length;i++){
				if(data.data[i].x>end){
					data.data.splice(i,1);
					i--;
				}
			}
		}
		var callback=easApiPerform(data);
		var promise=new Promise(callback);
		return promise;
	},
	getDataSources:function(previousDataSource){
		function onPromiseCallback(resolveFunc,rejectFunc){
			function onDataSource(dataSource){
				//go through existing data sources
				//and remove any that aren't linked
				//PBB 20210426 not doing this anymore as people might merge the datasets all sorts of ways
				/*for(id in dataSources){
					var type=dataSources[id].type;
					var found=false;
					for(field in dataSource.meta.properties){
						if(dataSource.meta.properties[field].type===type){
							found=true;
							break;
						}
					}
					if(found){

					}else{
						delete dataSources[id];
					}
				}*/
				resolveFunc(dataSources);
			}
			//we need to fetch that data and look at the meta
			//for what data sources we can return
			self.getDataSource({
				id:previousDataSource.getSelected().id
			}).then(onDataSource);
		}
		
		var promise,
			self=this;

		//turn eas array of data sources in to dictionary
		var dataSources={};
		for(var i=0;i<easDataCatalogue.length;i++){
			var data=easDataCatalogue[i];
			dataSources[data.id]=data;
		}

		if(previousDataSource){
			promise=new Promise(onPromiseCallback);
		}else{
			var callback=easApiPerform(dataSources);
			promise=new Promise(callback);
		}
		return promise;
	},
	getWidgets:function(){
		var data=loadStoredDashboards();
		var callback=easApiPerform(data);
		var promise=new Promise(callback);
		return promise;
	}
}

function easGetQualifierData(sets){
	var i,
		qualifiers={};
	for(i=0;i<sets.length;i++){
		if(sets[i].id==='qualifiers'){
			qualifiers=sets[i].data;
			sets.splice(i,1);
			i--;
		}
	}
	return qualifiers;
}

function easApplyQualifiersToSet(qualifiers,set){
	var col,
		i,
		qualId,
		qualInfo,
		rawLabel,
		row,
		rowQualifiers;

	for(i=0;i<set.data.data.length;i++){
		row=set.data.data[i];
		for(col in row){
			if(col==='qualifiers'){
				rowQualifiers=row[col];
				for(rawLabel in rowQualifiers){
					qualId=rowQualifiers[rawLabel][0];
					qualInfo=easFindQualifier(set.data.meta.qualifiers,qualifiers,rawLabel,qualId);
					row[qualInfo.label]=qualInfo.name;
				}
				delete row[col];
			}
		}
	}
	return set;
}

function easApplyQualifiers(qualifiers,sets){
	var i,
		set;
	for(i=0;i<sets.length;i++){
		set=sets[i];
		set=easApplyQualifiersToSet(qualifiers,set);
	}
	return sets;
}
  
function loadWidget(widgetOptions,widgetInfo){
	function createOnDataCallBack(widgetId,elem,widgetInfo){
		function onData(data){
			function onConfigRefresh(config) {
				//create a copy of our pivot config and store it
				var config_copy = JSON.parse(JSON.stringify(config));
				//delete some values which are functions
				delete config_copy["aggregators"];
				delete config_copy["renderers"];
				//delete some bulky default values
				delete config_copy["rendererOptions"];
				delete config_copy["localeStrings"];
				easData.widgetInfo[widgetId].options.pivottableConfig=config_copy;

				// this is correct way to apply fixed headers with pivotUI
				nrecoPivotExt.initFixedHeaders($('#'+containerId+' table.pvtTable'));
				
				// apply boostrap styles to pvt UI controls
				$('#'+containerId+' select.pvtAttrDropdown:not(.form-control)').addClass('form-control input-sm');
				$('#'+containerId+' select.pvtAggregator:not(.form-control), #'+containerId+' select.pvtRenderer:not(.form-control)').addClass('form-control input-sm');
				$('#'+containerId+'>table:not(.table)').addClass('table');	
				saveTable();		
			}
			
			//now we have all the data create a pivot table
			var options=widgetInfo.options;
			var datasets=[];
			var mergedColumns=[];
			//first of all deal with the qualifier fields to make later merging simpler
			var qualifiers=easGetQualifierData(data);
			data=easApplyQualifiers(qualifiers,data);
			for(var i=0;i<data.length;i++){
				var ourset=data[i];
				if(i===0){
					datasets=datasets.concat(ourset.data.data);
				}else{
					var mergeResult=easMergePivotData(mergedColumns,datasets,data[0].data,ourset);
					datasets=mergeResult.data;
					if(mergeResult.addedCol===true){
						//do the merge again
						i=0;
					}
				}
			}
			
			//console.log(datasets)
			//now strip any array fields
			datasets=easCleanPivotData(data[0].data.meta.label,datasets);
			var derivers = $.pivotUtilities.derivers;
			var renderers = $.extend($.pivotUtilities.renderers,$.pivotUtilities.plotly_renderers);
			var config={
				unusedAttrsVertical:true //prevent properties being randomly rendered horizontally
			};
			if(options.pivottableConfig){
				config=JSON.parse(JSON.stringify(options.pivottableConfig));
			}
			config.attrsDictionary = canonicalDataLabels;
			/* config.attrsDictionary={
				'Applications.Business Capabilities.name':'<span class="">Business Capabilities</span>'
			} */
			config.renderers=renderers;
			//set the id of the div so we update the styling refresh
			var containerId=elem.dataset.easWidgetId;

			elem.id=containerId;
			config.onRefresh=onConfigRefresh;
			//console.log('Canaonical Data Labels', canonicalDataLabels);

			var nrecoPivotExt = new NRecoPivotTableExtensions({
				wrapWith: '<div class="pvtTableRendererHolder"></div>',  // special div is needed by fixed headers when used with pivotUI
				fixedHeaders : true,
				onSortHandler : function(sortOpts) {
					// save changed sort options in pivotUI state
					// this handler is needed only if you need to save state of user-configured report
					var pvtUIOpts = $('#'+containerId).data("pivotUIOptions");
					if (!pvtUIOpts.rendererOptions) pvtUIOpts.rendererOptions = {};
					pvtUIOpts.rendererOptions.sort = sortOpts;		
					if(!easData.widgetInfo[widgetId].options.pivottableConfig.rendererOptions){
						easData.widgetInfo[widgetId].options.pivottableConfig.rendererOptions={};
					}
					easData.widgetInfo[widgetId].options.pivottableConfig.rendererOptions.sort=sortOpts;
				},
				drillDownHandler: function (attrFilter) {
					// handle drill-down somehow
					alert('Drill-down for: '+JSON.stringify( attrFilter ) );
				}	
			});
			var stdRendererNames = ["Table","Table Barchart","Heatmap","Row Heatmap","Col Heatmap"];
			var wrappedRenderers = $.extend( {}, $.pivotUtilities.renderers);
			$.each(stdRendererNames, function() {
				var rName = this;
				wrappedRenderers[rName] = nrecoPivotExt.wrapTableRenderer(wrappedRenderers[rName]);
			});
			config.renderers=wrappedRenderers;
			$(elem).pivotUI(
				datasets,
				config
			);
			return;
		}
		return onData;
	}

	//create a container for the table then wait for the data to load
	var widgetTemplate='<div data-eas-widget-id="'+widgetOptions.id+'">Loading...</div>';
	var elem=$.parseHTML(widgetTemplate)[0];
	var container=document.getElementById('easContainer');
	container.innerHTML='';
	//var nameInput=document.getElementById('nameInput');
	//nameInput.value='';
	if(widgetInfo==null){
		return;
	}
	//nameInput.value=widgetOptions.name;
	$('#current-table-name').text(widgetInfo.name);
	let tableDesc = widgetInfo.description;
	if(!tableDesc) {
		tableDesc = ' ';
	} 
	$('#current-table-desc').text(tableDesc);
	container.appendChild(elem);
	switch(widgetInfo.type){
		case 'pivottable':
			easApi.getAllData(widgetInfo.dataSources).then(createOnDataCallBack(widgetOptions.id,elem,widgetInfo));
			break;				
		default:
			//do nothing
	}
}
		  
function onSelectedWidgetChange(){
	var elem=selectedWidgetSelect;
	//look at the chosen value and turn that in to a shown widget
	var id=elem.value;
	var widgetInfo=easData.widgetInfo[id];
	var name='';
	var i;
	for(i=0;i<elem.children.length;i++){
		if(elem.children[i].value===id){
			name=elem.children[i].innerHTML;
			break;
		}
	}
	loadWidget({id:id,name:name},widgetInfo);
    /***********************************
    Close the Sidebar
    ************************************/
   // $('#sidebar').addClass('active');
    //$('#sidebarShow').removeClass('active');
}


$(document).ready(function(){

    /***************************************************
    Initialise the sidebar and tabs
    ****************************************************/
    
    $('#sidebarHide').on('click', function () {
        $('#sidebar').addClass('active');
        $('#sidebarShow').removeClass('active');
    });
    
    $('#sidebarShow').on('click', function () {
        $('#sidebar').removeClass('active');
        $('#sidebarShow').addClass('active');
        $('html, body').animate({scrollTop: '0'}, 800);
    });
    
    $('#selectedWidgetSelect').select2();

	function onAddClick(){
		newWidgetDialog.show();
		$('#newTableModal').modal('hide')
	}
	
	$('#newTableModal').on('shown.bs.modal', function (e) {
        initDataSourcesDataTable();
    });

	function onCopyClick(){
		//get the currently selected widget
		var elem=selectedWidgetSelect;
		//look at the chosen value and turn that in to a shown widget
		var id=elem.value;
		if(easData.widgetInfo[id]){
			//create a deep copy of the current table
			var widgetInfo=JSON.parse(JSON.stringify(easData.widgetInfo[id]));
			widgetInfo.name=widgetInfo.name +' Copy';
			id=id+'copy';
			//insert as a new widget with a new id and modified name
			elem.innerHTML+='<option value="'+id+'">'+widgetInfo.name+'</option>';
			elem.value=id;
			var data=easData;
			widgetInfo.id=id;
			data.widgetInfo[id]=widgetInfo;
			onSelectedWidgetChange();
		}else{
			//nothing to copy
		}
	}

	function onExportClick(){
		//get currently selected
		var elem=selectedWidgetSelect;
		var id=elem.value;
		if(easData.widgetInfo[id]){
			//convert current table in to json and then in to a file download
			let myFile = new File([JSON.stringify(easData.widgetInfo[id])], easData.widgetInfo[id].name+".json",{type:"plain/text"});
			let url = URL.createObjectURL(myFile);
			let a = document.createElement("a");
			a.setAttribute('href',url);
			a.setAttribute("download",easData.widgetInfo[id].name+".json");
			a.click();
		}else{
			//nothing to export
		}
	}

	function onImportClick(){
		document.getElementById('importButton').style.display='none';
		document.getElementById('importFileInput').style.display='inline';
	}

	function onImportFileChange(event){
		function onFileLoad(event){
			try{
				var widgetInfo=JSON.parse(event.target.result);
				//make sure this has a unique id
				widgetInfo.id='id'+new Date().getTime()+parseInt(Math.random()*100);
				//copy in to our store of tables
				easData.widgetInfo[widgetInfo.id]=widgetInfo;
				//now select it
				var select=selectedWidgetSelect;
				select.innerHTML+='<option value="'+widgetInfo.id+'">'+widgetInfo.name+'</option>';
				select.value=widgetInfo.id;
				onSelectedWidgetChange();
			}catch(err){
				alert('Failed to parse JSON.');
			}
		}
		//for each uploaded file create a reader and attempt to load it	
		var file,i,reader;
		for(i=0;i<event.target.files.length;i++){
			file=event.target.files[i];
			reader=new FileReader();
			reader.addEventListener('load',onFileLoad);
			reader.readAsText(file);
		}
		//hide our file uploader and show the import button
		document.getElementById('importFileInput').style.display='none';
		document.getElementById('importButton').style.display='inline';
	}

	function onNameChange(){
		//update the name and description in our storage
		//var nameInput=document.getElementById('nameInput');
		var select=selectedWidgetSelect;
		var id=select.value;
		var i;
		for(i=0;i<select.children.length;i++){
			if(select.children[i].value===id){
				//select.children[i].innerHTML=nameInput.value;
				//let thisTable = easData.widgetInfo[id];
				easData.widgetInfo[id].name= $('#editWidgetDialogName').val();
				easData.widgetInfo[id].description= $('#editWidgetDialogDesc').val();
			}
		}
	}

	function onRemoveWidgetClick(){
		//redraw the select but missing out the currently selected widget
		var elem=selectedWidgetSelect;
		var id=elem.value;
		elem.innerHTML='';
		var i;
		for(i=0;i<easData.widgets.length;i++){
			if(id===easData.widgets[i].id){
				easData.widgets.splice(i,1);
				i--;
			}else{
				elem.innerHTML+='<option value="'+easData.widgets[i].id+'">'+easData.widgetInfo[easData.widgets[i].id].name+'</option>';
			}
		}
		if(easData.widgets.length>0){
			elem.value=easData.widgets[0].id;
		}
		onSelectedWidgetChange();
	}

	

	function onWidgets(data){
		var selectInfo,
			i,
			elem=selectedWidgetSelect;
		
		//populate the table select and load the first table
		for(i=0;i<data.widgets.length;i++){
			selectInfo=data.widgets[i];
			elem.innerHTML+='<option value="'+selectInfo.id+'">'+data.widgetInfo[selectInfo.id].name+'</option>';
			if(i===0){
				onSelectedWidgetChange();
			}
		}
	}

	//load the API Data
	loadAPIData()
	.then(someData => {
		//load our stored data
		easData = loadStoredDashboards();
		easPopulateForm(document.forms.namedItem('dash').elements,easData.dashValues);
		//initialise buttons and dialogs
		newWidgetDialog.init();
		easApi.getWidgets().then(onWidgets);
	});

	
	var elem=document.getElementById('selectedWidgetSelect');
	//elem.addEventListener('change',onSelectedWidgetChange);
	$('#selectedWidgetSelect').on('change', onSelectedWidgetChange);
	selectedWidgetSelect=elem;
	elem=document.getElementById('removeButton');
	elem.addEventListener('click',onRemoveWidgetClick);
	//elem=document.getElementById('nameInput');
	//elem.addEventListener('change',onNameChange);
	elem=document.getElementById('copyButton');
	elem.addEventListener('click',onCopyClick);
	elem=document.getElementById('exportButton');
	elem.addEventListener('click',onExportClick);
	elem=document.getElementById('importFileInput');
	elem.addEventListener('change',onImportFileChange);
	elem=document.getElementById('importButton');
	elem.addEventListener('click',onImportClick);
	elem=document.getElementById('newButton');
	elem.addEventListener('click',onAddClick);
	//elem=document.getElementById('saveButton');
	//elem.addEventListener('click',onSaveClick);
	window.addEventListener('resize',onWindowResize);

	$('#newTableModal').on('hidden.bs.modal', function (event) {
		$('#newWidgetDialogName').val(null);
		$('#newWidgetDialogDesc').val(null);
		$('#newWidgetDialogError').text(' ');
	});

	$('#editTableModal').on('show.bs.modal', function (event) {
		let select=selectedWidgetSelect;
		let id=select.value;
		let thisTable =easData.widgetInfo[id];

		$('#editWidgetDialogName').val(thisTable.name);
		$('#editWidgetDialogDesc').val(thisTable.description);
	});

	$('#editTableModal').on('hidden.bs.modal', function (event) {
		$('#editWidgetDialogName').val(null);
		$('#editWidgetDialogDesc').val(null);
		$('#editWidgetDialogError').text(' ');
	});

	$('#update-table-btn').on('click', function(evt) {
		//update the name and description in our storage
		//var nameInput=document.getElementById('nameInput');
		let newName = $('#editWidgetDialogName').val();
		if(!newName?.length > 0) {
			$('#editWidgetDialogError').text('The table must have a name');
			return;
		}

		let newDesc = $('#editWidgetDialogDesc').val();
		if(!newDesc?.length > 0) {
			newDesc = null;
		}

		/* var select=selectedWidgetSelect;
		var id=select.value;
		var i; */

		let id = $("#selectedWidgetSelect").val();
		//$("#selectedWidgetSelect option:selected" ).text('newName');
		
		easData.widgetInfo[id].name= newName;
		$('#current-table-name').text(newName);
		easData.widgetInfo[id].description= newDesc;
		if(newDesc) {
			$('#current-table-desc').text(newDesc);
		} else {
			$('#current-table-desc').text(' ');
		}
		let select=selectedWidgetSelect;
		for(i=0;i<select.children.length;i++){
			if(select.children[i].value===id){
				select.children[i].innerHTML=newName;	
			}
		}
		$("#selectedWidgetSelect").select2("destroy");
		$("#selectedWidgetSelect").select2();
		//$("#selectedWidgetSelect").trigger('change');
		saveTable();
		$('#editTableModal').modal('hide');
	});
});

async function loadAPIData() {
    let apiCatalogueURL = easConstants.apiURLPrefix + easConstants.apiCataloguePath;
    essFetchJSONDocument(apiCatalogueURL)
    .then(apiCatalogue => {
		easDataCatalogue = apiCatalogue.catalogue;
        if(easDataCatalogue?.length > 0) {
            let apiPromises = [];
            let apiSpecs = [];
            easDataCatalogue.forEach(apiSpec => {
                if(apiSpec.path) {
                    apiPromises.push(essFetchJSONDocument(easConstants.apiURLPrefix + apiSpec.path));
                    apiSpecs.push(apiSpec);
                }
            });
            if(apiPromises.length > 0) {
                Promise.all(apiPromises)
				.then(allAPISpecData => {
					allAPISpecData.forEach(function(apiData, apiIdx) {
						let thisSpec = apiSpecs[apiIdx];
						if(thisSpec) {
							easDataApi[thisSpec.id] = apiData;
						}
					});
					return easDataApi;
				});
            } else {
                console.log('No valid APIs defined');
				return easDataApi;
            }
        } else {
            console.log('No APIs defined');
			return easDataApi;
        }
    })
    .catch(e => {
        //coreModals.essShowError('Initialisation Error', ['Error loading copy template', e.message]);
        console.log('API Loading error', e);
    });
}

async function essFetchJSONDocument(aUrl) {
    let requestOptions = {
        method: 'GET',
        headers: {
            "Content-Type": "application/text"
        }
    };

    let response = await fetch(aUrl, requestOptions);

    if (!response.ok) {
        throw new Error(`Fetch Document Error: ${response.status}`);
    }
    return await response.json();
}

function saveTable(){
	var i,
		id,
		toSave=easData,
		widgets=[];
	var select=document.getElementById('selectedWidgetSelect');
	for(i=0;i<select.children.length;i++){
		widgets.push({
			id:select.children[i].value,
			name:select.children[i].innerHTML
		});
	}

	toSave.widgets=widgets;

	//remove widgetInfo we no longer need
	for(id in toSave.widgetInfo){
		var found = false;
		for(i=0;i<toSave.widgets.length;i++){
			if(id===toSave.widgets[i].id){
				found=true;
				break;
			}
		}
		if(found===false){
			delete toSave.widgetInfo[id];
		}else{
			for(i=0;i<toSave.widgetInfo[id].dataSources.length;i++){
				delete toSave.widgetInfo[id].dataSources[i].data;
			}
		}
	}

	//store dashboard settings
	toSave.dashValues=easGetValuesFromForm(document.forms.namedItem('dash').elements);

	saveData(toSave);
}

function onWindowResize(){
	//PBB hack to get graphs to resize
	for(var i=0;i<PLOTLYDIVS.length;i++){
		Plotly.Plots.resize(PLOTLYDIVS[i]);
	}
}

//globals
var easData=null;
var selectedWidgetSelect=null;
var PLOTLYDIVS=[];