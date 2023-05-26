function getSelectValues(select) {
    var result = [];
    var options = select && select.options;
    var opt;
  
    for (var i=0, iLen=options.length; i<iLen; i++) {
      opt = options[i];
  
      if (opt.selected) {
        result.push(opt.value || opt.text);
      }
    }
    return result;
  }

function easApiPerform(value){
	function f(resolveFunc,rejectFunc){
		setTimeout(function(){
			resolveFunc(value);
		},100);
	}
	return f;
}

function easTimeMachineAddToFilteredInstances(filteredInstances,inScopeLayerName,inScopeInstanceType,inScopeInstance){
    //first find the layer, add if not there
    var layer,instances,found=false;
    for(var i=0;i<filteredInstances.length;i++){
        var layer=filteredInstances[i];
        if(layer.layer===inScopeLayerName){
            found=true;
            break;
        }
    }
    if(found===false){
        layer={
            layer:inScopeLayerName,
            instances:{}
        };
        filteredInstances.push(layer);
    }
    //now find the instance type
    found=false;
    for(var instanceType in layer.instances){
        if(instanceType===inScopeInstanceType){
            found=true;
            instances=layer.instances[instanceType];
            break;
        }
    }
    if(found===false){
        layer.instances[inScopeInstanceType]=[];
        instances=layer.instances[inScopeInstanceType];
    }
    //now see if the instance has already been added
    found=false;
    for(var i=0;i<instances.length;i++){
        var instance=instances[i];
        if(instance.id===inScopeInstance.id){
            found=true;
            break;
        }
    }
    if(found===false){
        instances.push(inScopeInstance);
    }
    return filteredInstances;
}

function easTimeMachineRemoveFromFilteredInstances(filteredInstances,inScopeLayer,inScopeInstanceType,inScopeInstance){
    for(var i=0;i<filteredInstances.length;i++){
        var layer=filteredInstances[i];
        if(layer.layer===inScopeLayer){
            for(var instanceType in layer.instances){
                if(instanceType===inScopeInstanceType){
                    var instances=layer.instances[instanceType];
                    for(var j=0;j<instances.length;j++){
                        var instance=instances[j];
                        if(instance.id===inScopeInstance.id){
                            instances.splice(j,1);
                            j--;
                        }
                    }
                }
            }
        }
    }
    return filteredInstances;
}

function easTimeMachineAddMissingAdds(layers){
    //first pass of the planned actions look for REMOVEs/ENHANCEs that have no ADD before them and insert an ADD for 1970-01-01
    for(var i=0;i<layers.length;i++){
        var layer=layers[i];
        for(var instanceType in layer.plannedActions){
            var instanceActions=layer.plannedActions[instanceType];
            var instIdsAdded={};
            for(var j=0;j<instanceActions.length;j++){
                var action=instanceActions[j];
                switch(action.actionType){
                    case 'Enhancement Change':
                    case 'Removal Change':
                        if(instIdsAdded[action.instId]!==true){
                            var newAction={};
                            for(var field in action){
                                newAction[field]=action[field];
                            }
                            newAction.end='1970-01-01';
                            newAction.actionType='Creation Change';
                            instanceActions.unshift(newAction);
                            instIdsAdded[action.instId]=true;
                        }
                        break;
                    default:
                        instIdsAdded[action.instId]=true;
                        break;
                }
            }
        }
    }
    return layers;
}

function easTimeMachineApplyAction(filteredInstances,rmMonthStop,action,inScopeLayer,inScopeInstanceType,inScopeInstance){
    if(action.instId===inScopeInstance.id){
        if(rmMonthStop.localeCompare(action.end)>=0){
            switch(action.actionType){
                case 'Creation Change':
                    filteredInstances=easTimeMachineAddToFilteredInstances(filteredInstances,inScopeLayer,inScopeInstanceType,inScopeInstance);
                    break;
                case 'Removal Change':
                    filteredInstances=easTimeMachineRemoveFromFilteredInstances(filteredInstances,inScopeLayer,inScopeInstanceType,inScopeInstance);
                    break;
            }
        }
    }
    return filteredInstances;
}

function easTimeMachineApplyPlan(filteredInstances,roadmaps,plans,projects,rmMonthStop,layer,inScopeInstanceType,inScopeInstance){
    for(var instanceType in layer.plannedActions){
        if(instanceType===inScopeInstanceType){
            var instanceActions=layer.plannedActions[instanceType];
            for(var h=0;h<instanceActions.length;h++){
                var action=instanceActions[h];
                var actionRoadmapIds=action.roadmapId.split(' ');
                var found=false;
                for(var i=0;i<actionRoadmapIds.length;i++){
                    if(roadmaps.includes(actionRoadmapIds[i])){
                        found=true;
                        break;
                    }
                }
                if(roadmaps.length===0 || found===true){
                    //now do the same for plans
                    if(plans.length===0 || plans.includes(action.planId)){
                        //now do the same for projects
                        if(projects.length===0 || action.changeActivityId.length===0 || projects.includes(action.changeActivityId)){
                            filteredInstances=easTimeMachineApplyAction(filteredInstances,rmMonthStop,action,layer.layer,inScopeInstanceType,inScopeInstance);
                        }
                    }
                }
            }
        }
    }
    return filteredInstances;
}


var easApi={
    getPlansForLayers:function(layers){
        var plans=[];
        for(var i=0;i<easDataApi.plans.length;i++){
            for(var j=0;j<layers.length;j++){
                if(layers[j]===easDataApi.plans[i].layer){
                    plans.push(easDataApi.plans[i]);
                }
            }
        }
        var callback=easApiPerform(plans);
		var promise=new Promise(callback);
		return promise;
    },
    getLayers:function(){
        return new Promise(easApiPerform(easDataApi.plans));
    },
    getRPP:function(){
        return new Promise(easApiPerform(easDataApi.rpp));
    }
};

var easTimeMachine={
    initRMEnablement:function(requiredLayers,refreshCallBackFunction){
        function onGotLayers(layers){
            self.layers=easTimeMachineAddMissingAdds(layers);
            refreshCallBackFunction();
        }
        var self=this;
        easApi.getPlansForLayers(requiredLayers).then(onGotLayers);
    },
    getRMInstances:function(rmMonthStop,roadmaps,plans,projects,inScopeInstances){
        var filteredInstances=[];

        //if instance ID in inScopeInstances then apply it to our current set of instances, e.g ADD/REMOVE/ENHANCE
        for(var i=0;i<inScopeInstances.length;i++){
            var inScopeLayer=inScopeInstances[i];
            for(var inScopeInstanceType in inScopeLayer){
                for(var j=0;j<this.layers.length;j++){
                    var layer=this.layers[j];                    
                    var inScopeInstanceIds=inScopeLayer[inScopeInstanceType];
                    for(var k=0;k<inScopeInstanceIds.length;k++){
                        var inScopeInstance=inScopeInstanceIds[k];
                        filteredInstances=easTimeMachineApplyPlan(filteredInstances,roadmaps,plans,projects,rmMonthStop,layer,inScopeInstanceType,inScopeInstance);
                    }
                }
            }//for(var instanceType in inScopeLayer){
        }
        return filteredInstances;
    }
}

function initRMEnablementClick(){
    function refreshCallBackFunction(){
        div.innerHTML='Refresh called!';
    }
    var div=document.getElementById('easTimeMachineRefreshDiv');
    div.innerHTML='Calling initRMEnablement...';
    var requiredLayers=getSelectValues(document.getElementById('easTimemachineLayers'));
    easTimeMachine.initRMEnablement(requiredLayers,refreshCallBackFunction);
}

function onGetRMInstancesClick(){
    var rmMonthStop=document.getElementById('rmMonthStop').value;
    var roadmaps=getSelectValues(document.getElementById('easTimemachineRoadmaps'));
    var plans=getSelectValues(document.getElementById('easTimemachinePlans'));
    var projects=getSelectValues(document.getElementById('easTimemachineProjects'));
    var filteredInstances=easTimeMachine.getRMInstances(rmMonthStop,roadmaps,plans,projects,easDataApi.inScopeInstances.allInstances);
    var div=document.getElementById('easTimeMachineRefreshDiv');
    div.innerHTML=JSON.stringify(filteredInstances);
}

function easTimechineOnBodyLoad(){
    function onGotRPP(rpp){
        function onGotLayers(layers){
            var select=document.getElementById('easTimemachineLayers');
            for(var i=0;i<layers.length;i++){
                select.innerHTML+='<option value="'+layers[i].layer+'">'+layers[i].layer+'</option>';
            }
        }
        var select=document.getElementById('easTimemachineRoadmaps');
        for(var i=0;i<rpp.roadmaps.length;i++){
            select.innerHTML+='<option value="'+rpp.roadmaps[i].id+'">'+rpp.roadmaps[i].name+'</option>';
        }
        select=document.getElementById('easTimemachinePlans');
        for(var i=0;i<rpp.plans.length;i++){
            select.innerHTML+='<option value="'+rpp.plans[i].id+'">'+rpp.plans[i].name+'</option>';
        }
        select=document.getElementById('easTimemachineProjects');
        for(var i=0;i<rpp.changeActivities.length;i++){
            select.innerHTML+='<option value="'+rpp.changeActivities[i].id+'">'+rpp.changeActivities[i].name+'</option>';
        }
        easApi.getLayers().then(onGotLayers);    
    }
    easApi.getRPP().then(onGotRPP);
}

window.addEventListener('load',easTimechineOnBodyLoad,false);