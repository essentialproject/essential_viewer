Handlebars.registerHelper('some', function (array, key) {
 
    return array && array.some(item => item[key]);
});

Handlebars.registerHelper('anyRoleContains', function(arr, role, options) {
    return arr.some(i => i.role === role);
});
 


Handlebars.registerHelper('getType', function(arg1, arg2, options) {
    if(arg1){

    return arg1.substring(0, arg1.indexOf("_"));
    }
});



Handlebars.registerHelper('formatDate', function(arg1) {
   
    if(arg1){
        return formatDateforLocale(arg1, currentLang)
    }
})		

Handlebars.registerHelper('formatCurrency', function(arg1, arg2, options) {
    var formatter = new Intl.NumberFormat(undefined, {  });
    if(arg1){
    return formatter.format(arg1);
    }
});

Handlebars.registerHelper('styles', function (value, classNm) {

    let match = styles.filter((a)=>{
        return a.valueClass == classNm && a.name == value
    }) 

    if(match.length > 0){
        return 'background-color:'+ match[0].backgroundColor +'; color:'+ match[0].textColour +';padding:3px'; 
    }
});

Handlebars.registerHelper('breaklines', function (html) {
    html = html.replace(/(\r<li&gt;)/gm, '<li&gt;');
    html = html.replace(/(\r)/gm, '<br/>');
    return new Handlebars.SafeString(html);
});

Handlebars.registerHelper('ifContains', function (arg1, arg2, options) {
    if (arg1.role.includes(arg2)) {
        return '<label>' + arg1.role + '</label><ul class="ess-list-tags"><li class="tagActor">' + arg1.actor + '</li></ul>'
    }
});

Handlebars.registerHelper('ifEquals', function (arg1, arg2, options) {
    return (arg1 == arg2) ? options.fn(this) : options.inverse(this);
});

/**
* Manage stakeholders Information
* 
* Separate group and invidual actors and group by actors
**/
function getIndivAndGroupActorsStakeholders(focusProduct) {
   
    let indivStakeholders = focusProduct.stakeholders?.filter((f) => { return f.type != 'Group_Actor' });
    focusProduct['orgStakeholders'] = focusProduct.stakeholders?.filter((f) => { return f.type == 'Group_Actor' });

    if(indivStakeholders){
        let indivStakeholdersList = d3.nest()
            .key(function (d) { return d.actor; })
            .entries(indivStakeholders);

        indivStakeholdersList?.forEach((d) => {
            let sid = focusProduct.stakeholders?.find((s) => {
                return s.actor == d.key
            })
            d['id'] = sid.actorId;
            d['name'] = d.key;
        });
        focusProduct['indivStakeholdersList'] = indivStakeholdersList;
    }
    if(focusProduct.orgStakeholders){
        let orgStakeholdersList = d3.nest()
            .key(function (d) { return d.actor; })
            .entries(focusProduct.orgStakeholders);

        orgStakeholdersList.forEach((d) => {
            let sid = focusProduct.stakeholders.find((s) => {
                return s.actor == d.key
            })
            d['id'] = sid.actorId;
            d['name'] = d.key;
        })
        focusProduct['orgStakeholdersList'] = orgStakeholdersList;
    }
    return focusProduct;
}

function updateFilterProperties(prods, filters) {
               
  // Create a mapping of slotName to filter values for quick lookup
  const filterMap = {};
  filters.forEach(filter => {
      filterMap[filter.slotName] = filter.values;
  });

  // Iterate over each app and update properties
  prods.forEach(app => {
      
      for (const property in app) {
      
          if (filterMap[property]) {
              // Match the app property values with the corresponding filter values
              app[property] = app[property].map(id => {
                  const match = filterMap[property].find(value => value.id === id);
                  return match || { id }; // If no match is found, keep the original id
              });
          }
      }
  });

  return prods;
}

function activateStakeholdersDataTable() {
    $('.dt_stakeholders tfoot th').each(function () {
        let stakeholdertitle = $(this).text();
        $(this).html('<input type="text" placeholder="Search ' + stakeholdertitle + '" />');
    });

    stakeholdertable = $('.dt_stakeholders').DataTable({
        scrollY: "350px",
        scrollCollapse: true,
        paging: false,
        info: false,
        sort: true,
        responsive: true,
        columns: [{ "width": "30%" }, { "width": "30%" }],
        dom: 'Bfrtip',
        buttons: ['copyHtml5', 'excelHtml5', 'csvHtml5', 'pdfHtml5', 'print']
    });

    stakeholdertable.columns().every(function () {
        var that = this;

        $('input', this.footer()).on('keyup change', function () {
            if (that.search() !== this.value) {
                that
                    .search(this.value)
                    .draw();
            }
        });
    });

    stakeholdertable.columns.adjust();
}

function setPlanandProjectInformation (techInstance){
    let thisElements=projectElementMap.filter((p)=>{
		return p.impactedElement == techInstance.id
	})
 
	let thisPlanElementMap
	thisElements.forEach((e)=>{
		 thisPlanElementMap=planElementMap.filter((d)=>{
			return d.id!=e.id;
		})
		e['planInfo']={"id":e.planid, "name":e.plan, "className":"Enterprise_Strategic_Plan"};
		e['projectInfo']={"id":e.projectID, "name":e.projectName, "className":"Project"}
	})
 
	let thisPlanElements=planElementMap.filter((p)=>{
		return p.impactedElement == techInstance.id
	})
 
	let thisProj=[];
	let thisPlan=[]; 
	thisPlanElements.forEach((d)=>{
		thisPlan.push(d)
	})

	thisElements.forEach((d)=>{
		let thisProjDetail=plans.allProject.find((p)=>{
			return d.projectID==p.id
		})
		thisProj.push(thisProjDetail);
		if(thisProjDetail.proposedStartDate){
			d['projForeStart']=thisProjDetail.proposedStartDate;
			d['projActStart']=thisProjDetail.actualStartDate;
			d['projForeEnd']=thisProjDetail.forecastEndDate;
			d['projTargEnd']=thisProjDetail.targetEndDate;
		}
		let thisPlans=plans.allPlans.find((p)=>{
			return d.planid==p.id
		})
		
		thisPlan.push(thisPlans)
	})

	/* indirect via tpr
	let thisaprProj=[];
	let thisaprPlan=[]; 
	focusApp.allServices.forEach((f)=>{
	let thisaprElements=projectElementMap?.filter((p)=>{
		return p.impactedElement == f.id
	})
 
	let thisPlanElementMap
	thisaprElements?.forEach((e)=>{
		 thisPlanElementMap=planElementMap.filter((d)=>{
			return d.id!=e.id;
		})
	})
	  
	let thisaprPlanElements=thisPlanElementMap?.filter((p)=>{
		return p.impactedElement == f.id
	})
	  
	thisaprPlanElements?.forEach((d)=>{
		thisaprPlan.push(d)
	})

	thisaprElements?.forEach((d)=>{
		let thisProjDetail=plans.allProject.find((p)=>{
			return d.projectID==p.id
		})
		d['planInfo']={"id":d.planid, "name":d.plan, "className":"Enterprise_Strategic_Plan"};
		d['projectInfo']={"id":d.projectID, "name":d.projectName, "className":"Project"}
		 
		thisProjDetail['plan']=d.plan;
		thisProjDetail['planId']=d.planid;
		thisProjDetail['apraction']=d.action;
		if(thisProjDetail){
			thisaprProj.push(thisProjDetail);
		}
		if(thisProjDetail.proposedStartDate){
			d['projForeStart']=thisProjDetail.proposedStartDate;
			d['projActStart']=thisProjDetail.actualStartDate;
			d['projForeEnd']=thisProjDetail.forecastEndDate;
			d['projTargEnd']=thisProjDetail.targetEndDate;
		}
		let thisaprPlans=plans.allPlans.find((p)=>{
			return d.planid==p.id
		})
		if(thisaprPlans){
			 
			thisaprPlan.push(thisaprPlans)
		}
	})
       
})  

let resApr = {};
thisaprPlan?.forEach(a => resApr[a.id] = {...resApr[a.id], ...a});
thisaprPlan = Object.values(resApr);
 
focusApp['aprplans']=thisaprPlan;
focusApp['aprprojects']=thisaprProj;

focusApp['aprprojectElements']=thisaprProj;

*/

    let res = {};
    if(thisPlan){
        thisPlan.forEach(a => {
            if (a) {
            res[a.id] = { ...res[a.id], ...a };
            }
        });
        
        thisPlan = Object.values(res);
    }else{
        thisPlan=[]
    }
    techInstance['plans']=thisPlan;
    techInstance['projects']=thisProj;
}
var styles, nodeMap, costTotalTemplate, plans, ccy, filters, lifecycles; 
var projectElementMap=[];
var planElementMap=[];

$('document').ready(function () {

    var panelFragment = $("#panel-template").html();
    panelTemplate = Handlebars.compile(panelFragment);

    var selectFragment = $("#select-template").html();
    selectTemplate = Handlebars.compile(selectFragment);

    var costTotalFragment = $("#costTotal-template").text();
 	costTotalTemplate = Handlebars.compile(costTotalFragment); 

    var standardScopeFragment = $("#standardScope-template").text();
    standardScopeTemplate = Handlebars.compile(standardScopeFragment); 
     
    Handlebars.registerHelper('styler', function(arg1) {
        let match = plans.styles.find((d)=>{
            return d.id == arg1
        })

        return match 
            ? `background-color:${match.colour};color:${match.textColour};`
            : 'background-color:#ffffff;color:#000000;';
    })

    var getInstanceById = function(data, id) {
        return data.find(item => item.id === id); // Adjust the condition based on your data structure
    };

  
//  promise_loadViewerAPIData(viewAPIDataProds, data => getInstanceById(data.technology_products, focusProductId)),  
    Promise.all([
        promise_loadViewerAPIData(viewAPIDataProds),  
        promise_loadViewerAPIData(viewAPIDataProdsSuppliers), 
        promise_loadViewerAPIData(viewAPIDataAppMart),
        promise_loadViewerAPIData(viewAPIDataPhysProc),
        promise_loadViewerAPIData(viewAPIDataPlans),
        promise_loadViewerAPIData(viewAPIDataLifecycles)
        ]).then(function(responses) { 
            lifecycles=responses[5].all_lifecycles;
            lifecycleStyles=responses[5].lifecycleJSON

            const lifecycleStyleMap = new Map();

                lifecycleStyles.forEach(item => {
                  lifecycleStyleMap.set(item.id, item);
              });
  
             responses[5].technology_lifecycles=[];
            filters=responses[1].filters;
          //  styles = responses[0].styles 
            plans = responses[4];
            ccy=responses[2].ccy

           styles = responses[1].filters.flatMap(item => 
            item.values.map(value => ({
                ...value,
                valueClass: item.valueClass
            }))
            ); 

          // create plans structure, use pairs for speed
          
					plans.allProject.forEach((p)=>{
					 
						p.p2e?.forEach((pe)=>{
							pe['projectName']=p.name;
							pe['projectID']=p.id;
							projectElementMap.push(pe)

							let clrs= plans.styles.find((s)=>{
								return s.id==pe.actionid;
							});
							if(clrs){
							pe['colour']=clrs.colour;
							pe['textColour']=clrs.textColour;
							}
							else{
								pe['colour']='#d3d3d3';
								pe['textColour']='#000000';
							}
						})
					});

					<!-- get any plans where no project exists but the tech is mapped -->
					plans.allPlans.forEach((p)=>{
						p.planP2E?.forEach((pe)=>{
							pe['name']=p.name;
							pe['id']=p.id;
							planElementMap.push(pe)

							let clrs= plans.styles.find((s)=>{
								return s.id==pe.actionid;
							});
							if(clrs){
							pe['colour']=clrs.colour;
							pe['textColour']=clrs.textColour;
							}
							else{
								pe['colour']='#d3d3d3';
								pe['textColour']='#000000';
							}
						})
					});


          //end of plans

          const productToApplications = new Map();

          responses[2].application_technology.forEach(app => {
            const appId = app.id;
            const appName = app.name;

                app.environments.forEach(env => {
               
                    env.products.forEach(product => {
                        const productId = product.prod;
                        if (!productToApplications.has(productId)) {
                            productToApplications.set(productId, []);
                        }
                        productToApplications.get(productId).push({ id: appId, name: appName, className: "Application_Provider", environment: env.role, nodes: env.nodes, colour: env.colour, backgroundColour:env.backgroundColour, usage: product.compname  });
                    });
                });
            });

            // Convert the Map to an array for logging or further processing
            const techresult = Array.from(productToApplications.entries()).map(([productId, apps]) => ({
                productId,
                apps
            }));
  
            const mergeById = (responses) => {
                const mergedMap = new Map();
            
                // Iterate through both response arrays
                responses.forEach(response => {
                    response.technology_products?.forEach(product => {
                        // Use 'id' as the key and update with the latest entry
                        mergedMap.set(product.id, { ...mergedMap.get(product.id), ...product });
                    });
                });
            
                // Convert the Map back to an array
                return Array.from(mergedMap.values());
            };
            
            const productsList = mergeById(responses);

            var products = productsList.map(product => {
                const matchingApps = techresult.find(item => item.productId === product.id);
                return {
                    ...product,
                    applications: matchingApps ? matchingApps.apps : []
                };
            });

            function mapProcessesToProducts(processes, products) {
                // Create a lookup map of apps to their corresponding processes
                const appToProcessMap = new Map();
            
                // Preprocess: index all apps in processes by ID
                processes.forEach(process => {
                    // Index apps in "appsviaservice"
                    process.appsviaservice.forEach(app => {
                        if (!appToProcessMap.has(app.appid)) {
                            appToProcessMap.set(app.appid, []);
                        }
                        appToProcessMap.get(app.appid).push({
                            id: process.processid,
                            name: process.processName,
                            org: process.org,
                            sites: process.sites,
                            className: 'Business_Process'
                        });
                    });
            
                    // Index apps in "appsdirect"
                    process.appsdirect.forEach(app => {
                        if (!appToProcessMap.has(app.id)) {
                            appToProcessMap.set(app.id, []);
                        }
                        appToProcessMap.get(app.id).push({
                            id: process.processid,
                            name: process.processName,
                            org: process.org,
                            sites: process.sites,
                            className: 'Business_Process'
                        });
                    });
                });
            
                
                // Iterate over products and map matched processes
                products.forEach(product => { 
                  product['className']="Technology_Product";
                    product.matchedProcesses = []; // Initialise matched processes
                    const seenProcessIds = new Set(); // Track added process IDs
            
                    product.applications.forEach(app => {
                        const matchedProcesses = appToProcessMap.get(app.id);
            
                        if (matchedProcesses) {
                            matchedProcesses.forEach(process => {
                                if (!seenProcessIds.has(process.id)) {
                                    seenProcessIds.add(process.id);
                                    product.matchedProcesses.push(process);
                                }
                            });
                        }
                    });
                    if(product.documents){
                      let docsCategory = d3.nest()
                      .key(function(d) { return d.type; })
                      .entries(product.documents);
                      
                      product['documents']=docsCategory;
                    }
                });
            }
            

            mapProcessesToProducts(responses[3].process_to_apps, products);
            products=products.sort((a, b) => a.name.localeCompare(b.name));
            const currentDate = new Date();

           // Pre-compute a map of lifecycles by productId for faster lookup
const lifecycleMap = lifecycles.reduce((map, lifecycle) => {
    if (!map[lifecycle.productId]) {
        map[lifecycle.productId] = [];
    }
    map[lifecycle.productId].push(lifecycle);
    return map;
}, {});

const fragment = document.createDocumentFragment(); // Use a document fragment for efficient DOM manipulation

products.forEach(product => {
    // Create and append the option element
    const option = new Option(product.name, product.id);
    fragment.appendChild(option);

    // Assign lifecycles using the precomputed map
    product['lifecycles'] = lifecycleMap[product.id] || [];

    // Process lifecycles for activeDate
    product.lifecycles.forEach(lifecycle => {
        let activeDate = null;
        let maxDate = null;

        lifecycle.dates.forEach(dateEntry => {
          if(dateEntry.type == 'Lifecycle_Status'){delete product.technology_provider_lifecycle_status}
          if(dateEntry.type == 'Vendor_Lifecycle_Status'){delete product.vendor_product_lifecycle_status}
          dateEntry['backgroundColour']= lifecycleStyleMap.get(dateEntry.id).backgroundColour
          dateEntry['colour']= lifecycleStyleMap.get(dateEntry.id).colour
            const date = new Date(dateEntry.dateOf);
            if (date <= currentDate && (!maxDate || date > maxDate)) {
                maxDate = date;
                activeDate = dateEntry;
            }
        });

        lifecycle.activeDate = activeDate;
    });
});

// Append all options to the dropdown at once
$('#subjectSelection').append(fragment);

 
            const updatedProds = updateFilterProperties(products, filters);
 
            focusProduct = products.find((e)=>{return e.id == focusProductId})

           

            drawView(focusProduct)
            $('#subjectSelection').off('change').on('change', function () {
                let selected = $(this).val();
                 
                focusProduct = products.find((e) => e.id == selected);
                drawView(focusProduct);
                // Redirect to the page to remove unnecessary JavaScript
            });
            $('#subjectSelection').select2();
            $('#subjectSelection').val(focusProductId).change();
           
        })
 
});

function drawView(productToShow){
 
  $('#selectMenu').html(selectTemplate(productToShow))
  $('.context-menu-techProdGenMenu').html('<i class="fa fa-bars"></i> Menu');
 

focusProduct = getIndivAndGroupActorsStakeholders(productToShow);

setPlanandProjectInformation(focusProduct)

focusProduct.comp.forEach((c)=>{
    c['technology_provider_lifecycle_status']=[c.strategic_lifecycle_status];
});

updateFilterProperties(focusProduct.comp, filters);

const collatedInfoStores = focusProduct.instances?.reduce((acc, instance) => {
    if (Array.isArray(instance.infoStores)) {
        acc.push(...instance.infoStores);
    }
    return acc;
}, []);

focusProduct['infoStores']=collatedInfoStores;

$('#mainPanel').html(panelTemplate(focusProduct))

calculateCosts(focusProduct)

$('.std-info-icon').click(function() { 
   let match = focusProduct.comp.find((e)=>{
        return e.id ==$(this).attr('easid')
    }) 
    $('#standardsModal').html(standardScopeTemplate(match.allStandards))
    
    $('#infoModal').fadeIn();
});

// Close modal on '×' button click
$('.std-close').click(function() {
    $('#infoModal').fadeOut();
});

// Close modal when clicking outside of modal content
$(window).click(function(event) {
    if ($(event.target).is('#infoModal')) {
        $('#infoModal').fadeOut();
    }
});

function generateForceChart(dataSet, containerId, wd, ht) {
 

    // Get container dimensions
    const width = wd;
    const height = ht;

    const graph = {
        nodes: [],
        links: []
    };

    // Process nodes and links
    const nodeMap = {};
    dataSet.prodUsages?.forEach(usage => {
        if (!nodeMap[usage.fromname]) {
            graph.nodes.push({ id: usage.fromname, name: usage.fromname });
            nodeMap[usage.fromname] = true;
        }
        if (!nodeMap[usage.toname]) {
            graph.nodes.push({ id: usage.toname, name: usage.toname });
            nodeMap[usage.toname] = true;
        }
        graph.links.push({ source: usage.fromname, target: usage.toname });
    });

    // Append an SVG to the container and a group for zoom
    const svg = d3.select(`#${containerId}`)
        .append("svg")
        .attr("width", width)
        .attr("height", height);

    // Append a group inside the SVG for zoom
    const zoomGroup = svg.append("g");

    // Define the zoom behaviour
    const zoom = d3.zoom()
        .scaleExtent([0.1, 5]) // Min and max zoom scale
        .on("zoom", () => {
            // Use d3.event.transform for D3 v5.9
            zoomGroup.attr("transform", d3.event.transform); 
        });

    // Apply zoom behaviour to the SVG
    svg.call(zoom);

    const simulation = d3.forceSimulation(graph.nodes)
        .force("link", d3.forceLink(graph.links).id(d => d.id).distance(350))
        .force("charge", d3.forceManyBody().strength(-350))
        .force("center", d3.forceCenter(width / 2, height / 2))
        .force("radial", d3.forceRadial(Math.min(width, height) / 3, width / 2, height / 2));

    const link = zoomGroup.append("g")
        .attr("class", "links")
        .selectAll("line")
        .data(graph.links)
        .enter().append("line")
        .attr("stroke-width", 2);

    const node = zoomGroup.append("g")
        .attr("class", "nodes")
        .selectAll("rect")
        .data(graph.nodes)
        .enter().append("rect")
        .attr('rx', 8) // Rounded corners
        .attr('ry', 8)
        .attr('height', 60) // Rectangle dimensions
        .attr('width', 140)
        .attr('fill', d => d.primary ? "#c0bfcf" : "#d0d9e2") // Colour based on condition
        .attr('stroke', '#000000') // Outline
        .call(d3.drag()
            .on('start', dragstarted)
            .on('drag', dragged)
            .on('end', dragended));

    const text = zoomGroup.append("g")
        .attr("class", "labels")
        .selectAll("text")
        .data(graph.nodes)
        .enter().append("text")
        .attr("text-anchor", "middle")
        .style("font-family", "Arial, sans-serif")
        .style("font-size", "0.8em")
        .each(function(d) {
            const parts = d.name.split(" as ");
            parts.forEach((part, index) => {
                d3.select(this)
                    .append("tspan")
                    .attr("dy", index === 0 ? "0em" : "1.2em")
                    .text(part);
            });
        });

    simulation.on("tick", () => {
        link
            .attr("x1", d => d.source.x)
            .attr("y1", d => d.source.y)
            .attr("x2", d => d.target.x)
            .attr("y2", d => d.target.y);

        node
            .attr("x", d => d.x - 70)
            .attr("y", d => d.y - 28);

        text
            .attr("x", d => d.x)
            .attr("y", d => d.y)
            .selectAll("tspan")
            .attr("x", d => d.x);
    });

    function dragstarted(event, d) {
        if (!event.active) simulation.alphaTarget(0.3).restart();
        d.fx = d.x;
        d.fy = d.y;
    }

    function dragged(event, d) {
        d.fx = event.x;
        d.fy = event.y;
    }

    function dragended(event, d) {
        if (!event.active) simulation.alphaTarget(0);
        d.fx = null;
        d.fy = null;
    }
}


// Data

const data = focusProduct.usages?.[0]?.techArchitectures ?? [];

const techarch = document.getElementById("techarch");
techarch.innerHTML = "";

// Create the nav-tabs container
const navTabs = document.createElement("ul");
navTabs.className = "nav nav-tabs";
navTabs.id = "tabList";
navTabs.setAttribute("role", "tablist");
techarch.appendChild(navTabs);

// Create the tab-content container
const tabContent = document.createElement("div");
tabContent.className = "tab-content";
tabContent.id = "techarchstab";
techarch.appendChild(tabContent);

// Generate tabs and content dynamically
data.forEach((item, index) => {
    // Create and append a tab
    let tbname=item.name.split(" - ")[0];
    const tab = document.createElement("li");
    tab.className = index === 0 ? "active" : ""; // Set the first tab as active
    tab.innerHTML = `<a href="#content-${index}" data-toggle="tab"> `+tbname+ `</a>`;
    navTabs.appendChild(tab);

    // Create and append tab content
    const content = document.createElement("div");
    content.className = `tab-pane fade ${index === 0 ? "in active" : ""}`;
    content.id = `content-${index}`;
    if(item.prodUsages.length > 0){
      content.innerHTML = `<div id="chart-${index}" class="chart-container" style="width: 100%; height: 100vh;"></div>`;
      tabContent.appendChild(content);
      
      // Get container dimensions with fallback values
      const chartContainer = document.getElementById(`chart-${index}`);
      const { clientWidth: width = 1000, clientHeight: height = 600 } = chartContainer;

      const adjustedWidth = width  <  400 ? 1000 : width;
      const adjustedHeight = height < 400 ? 600 : height; 

      // Generate the force chart
      generateForceChart(item, `chart-${index}`, adjustedWidth, adjustedHeight);
    }else{
      content.innerHTML = `<br/>No usages defined for this technology architecture`
      tabContent.appendChild(content);
    }
 
});


/* future
var markers = [];
let locations=[]
focusProduct.matchedProcesses.forEach((p)=>{
    p.sites.forEach((s)=>{
        if (s.long && s.lat && !isNaN(s.long) && !isNaN(s.lat)) {
           locations2.push(s)
        }
    })
})

console.log('locs', locations)
var map = L.map('map');

        // Add OpenStreetMap tiles
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);

        // Data array
        var locations = [
            {
                "id": "store_55_Class1331",
                "name": "Frankfurt",
                "long": "8.6820917",
                "lat": "50.1106444"
            },
            {
                "id": "store_55_Class747",
                "name": "London",
                "long": "-0.1276474",
                "lat": "51.5073219"
            },
            {
                "id": "store_681_Class170003",
                "name": "Global",
                "long": "",
                "lat": ""
            },
            {
                "id": "store_681_Class90007",
                "name": "Iceland",
                "long": "-18",
                "lat": "65"
            }
        ];

        var markers = [];

        // Add markers for each location
        locations.forEach(function(location) {
            if (location.long && location.lat) { // Only add markers with valid coordinates
                var marker = L.circleMarker([location.lat, location.long], {
                    radius: 8,
                    color: 'red',
                    className: 'blinking'
                }).addTo(map);

                // Add a popup with location name
                marker.bindPopup(`<strong>${location.name}</strong>`);
                markers.push([location.lat, location.long]);
            }
        });

        // Fit map to markers with padding
        if (markers.length > 0) {
            map.fitBounds(markers, { padding: [40, 40] });
        }
*/
activateStakeholdersDataTable();
$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
  
    $($.fn.dataTable.tables(true)).DataTable().columns.adjust();
});

}

function calculateCosts(focus) {  
let defaultCurrency = ccy.find(ccy => ccy.default === "true");   

if (!defaultCurrency || Object.keys(defaultCurrency).length === 0) {
	 
    defaultCurrency = rcCcyId || {};
}

const calculateDefaultCosts = (costArray, currencyArray) => {
   
    let defaultExchangeRate = defaultCurrency ? parseFloat(defaultCurrency.exchangeRate) : 1;
  
      if(isNaN(defaultExchangeRate)){defaultExchangeRate=1} 
    return costArray?.map(cost => {
        const matchingCurrency = currencyArray.find(ccy => ccy.ccySymbol === cost.component_currency);
        let exchangeRate = matchingCurrency ? parseFloat(matchingCurrency.exchangeRate) : 1;
        if(isNaN(exchangeRate)){exchangeRate=1}
        const defaultCost = parseFloat(cost.cost) * (exchangeRate / defaultExchangeRate); 
        return {
            ...cost,
            defaultCost: defaultCost.toFixed(2)
        };
    });
};

const updatedCosts = calculateDefaultCosts(focus.costs, ccy);

focus.costs=updatedCosts

  let costByCategory = [];
  let costByType = [];
  let costByFreq = [];
  if (focus.costs) {
    costByCategory = d3
      .nest()
      .key(function (d) {
        return d.costCategory;
      })
      .rollup(function (v) {
        return {
          total: d3.sum(v, function (d) {
            return d.defaultCost;
          }),
        };
      })
      .entries(focus.costs);

    costByType = d3
      .nest()
      .key(function (d) {
        return d.name;
      })
      .rollup(function (v) {
        return {
          total: d3.sum(v, function (d) {
            return d.defaultCost;
          }),
        };
      })
      .entries(focus.costs);

    costByFreq = d3
      .nest()
      .key(function (d) {
        return d.costType;
      })
      .rollup(function (v) {
        return {
          total: d3.sum(v, function (d) {
            return d.defaultCost;
          }),
        };
      })
      .entries(focus.costs);
  }
  calculateCosts(focus)
  function calculateCosts(focus) {
   
    let costDivider;
    let fromDateArray = [];
    let toDateArray = [];
    let totalAnnualCost = 0;
    let totalMonthlyCost = 0;
    let monthsActive = 0;
    let today = new Date();
    let nextMonth = new Date();
    nextMonth.setMonth(today.getMonth() + 1);
    
    if (focus.costs) {
        focus.costs.forEach((d) => {
    
            let numericCost = parseFloat(d.cost); // Convert string to number
     
            let costDivider = 1; // Default: 1 (full cost)
     
            // Determine how to distribute costs
            if (d.costType === "Adhoc_Cost_Component") {
                return; // Skip Adhoc costs in monthly and annual calculations
            } else if (d.costType === "Annual_Cost_Component") {
                costDivider = 12; // Spread annual cost over 12 months
            } else if (d.costType === "Quarterly_Cost_Component") {
                costDivider = 1; // Apply cost every 3 months
            } else if (d.costType === "Monthly_Cost_Component") {
                costDivider = 1; // Already a monthly cost
            }
    
            d.monthlyAmount = numericCost / costDivider; // Base calculation
     
            // **Guard code** to handle NaN for monthlyAmount
            if (isNaN(d.monthlyAmount)) {
                d.monthlyAmount = 0; // Set to 0 if NaN
            }
    
            let fromDate = d.fromDate ? new Date(d.fromDate) : today;
            let toDate = d.toDate ? new Date(d.toDate) : nextMonth;
    
            // If toDate is not set, make it 12 months from fromDate, assumes no date so just a recurring cost
            if (!d.toDate) {
                toDate.setFullYear(toDate.getFullYear() + 1);
            }
     
            // **Keep monthsActive for other calculations**
            monthsActive = (toDate.getFullYear() - fromDate.getFullYear()) * 12 + (toDate.getMonth() - fromDate.getMonth()) + 1; 
    
            // **Condition for Annual Cost**
            if (d.costType === "Annual_Cost_Component") {
                totalAnnualCost += numericCost; // Add the full cost for the year
            } else if (d.costType === "Quarterly_Cost_Component") {
                for (let i = 0; i < 12; i++) {
                    if (i % 3 === 0) { // Apply cost every 3 months
                        totalAnnualCost += d.monthlyAmount
     
                    }
                }
            } else if (d.costType === "Monthly_Cost_Component") {
         
                totalAnnualCost += d.monthlyAmount * 12; // Monthly cost components
            }
             
        });
    }
     
    // **Fix totalMonthlyCost Calculation**
    // If the period is less than 12 months, calculate based on the actual period
     
    if (monthsActive < 12) {
        if(monthsActive==0){
            monthsActive=1;
        }
    
        totalMonthlyCost = totalAnnualCost / monthsActive;
    } else {
        totalMonthlyCost = totalAnnualCost / 12; // Spread across 12 months if the period is full-year or more
    }
     
    // Format cost output
    let costNumbers = {};
      
    let formatter = new Intl.NumberFormat(undefined, { style: "currency", currency: defaultCurrency.ccyCode  });
    if (isNaN(totalMonthlyCost)) {
        totalMonthlyCost = 0; // Set to 0 if NaN
    }
    
    costNumbers['annualCost'] = formatter.format(Math.round(totalAnnualCost));
    costNumbers['monthlyCost'] = formatter.format(Math.round(totalMonthlyCost));
     
     
    if (focus.costs) {
        focus.costs.forEach((d) => {
            if (d.fromDate) fromDateArray.push(d.fromDate);
            if (d.toDate) toDateArray.push(d.toDate);
        });
    }
    
    // **Fix sorting issue**
    fromDateArray.sort((a, b) => new Date(a) - new Date(b));
    toDateArray.sort((a, b) => new Date(a) - new Date(b));
    
    let momentStartFinYear = moment(fromDateArray[0]);
    let momentEndFinYear = moment(toDateArray[toDateArray.length - 1]);
    
    if (momentEndFinYear.isBefore(moment())) {
        momentEndFinYear = moment();
    }
    
    let costChartRowList = [];
    let costCurrency;
    
    // **Iterate over each cost component**
    focus.costs?.forEach(function (aCost) {
        let numericCost = parseFloat(aCost.cost); // Ensure cost is a number
    
        // **Ensure numericCost is valid**
        if (isNaN(numericCost)) {
            console.error(`Invalid cost for:`, aCost);
            numericCost = 0; // Default to zero to avoid NaN propagation
        }
    
        // **Fix cost validity period**
      let thisFromDate = aCost.fromDate ? new Date(aCost.fromDate) : today;
      let thisToDate = aCost.toDate ? new Date(aCost.toDate) : nextMonth;
        let thisStart = moment(thisFromDate, 'YYYY-MM-DD', true);
        let thisEnd = moment(thisToDate, 'YYYY-MM-DD', true);
    
        // **Ensure valid dates before proceeding**
        if (!thisStart.isValid() || !thisEnd.isValid()) {
            console.error(`Invalid date range for:`, aCost);
            return; // Skip this cost entry
        }
    
        thisStart = moment.max(thisStart, momentStartFinYear);
        thisEnd = moment.min(thisEnd, momentEndFinYear);
    
        // **Fix month count calculation (ensure inclusive of both start and end months)**
        let monthCount = thisEnd.diff(thisStart, 'months') + 1;
    
        // **Ensure monthCount is valid**
        if (isNaN(monthCount) || monthCount  <= 0) {
            console.error(`Invalid monthCount for:`, aCost, `Calculated monthCount:`, monthCount);
            monthCount = 1; // Ensure at least 1 month
        }
        aCost['monthCount'] = Math.ceil(monthCount);
    
        // **Fix monthStart calculation**
        let monthStart = thisStart.diff(momentStartFinYear, 'months');
        if (isNaN(monthStart) || monthStart  <  0) {
            console.error(`Invalid monthStart for:`, aCost, `Calculated monthStart:`, monthStart);
            monthStart = 0; // Ensure valid 0-based index
        }
        aCost['monthStart'] = Math.floor(monthStart);
    
        // **Ensure correct cost distribution**
        if (aCost.costType === "Adhoc_Cost_Component") {  
            aCost.monthlyAmount = numericCost / aCost.monthCount;
        } else if (aCost.costType === "Annual_Cost_Component") {
            aCost.monthlyAmount = numericCost / 12;
        } else if (aCost.costType === "Quarterly_Cost_Component") {
            aCost.monthlyAmount = numericCost; // Keep full amount but apply only every 3 months
        } else {
            aCost.monthlyAmount = numericCost;
        }
    
        // Assign currency dynamically
        costCurrency = aCost.ccy_code;
   
        // **Fix missing dates dynamically**
        if (!aCost.toDate) aCost['toDate'] = momentEndFinYear.format('YYYY-MM-DD');
        if (!aCost.fromDate || aCost.fromDate === '') aCost['fromDate'] = momentStartFinYear.format('YYYY-MM-DD');
    
        // **Fix total amount for valid months**
        aCost['inScopeAmount'] = Math.round(aCost['monthlyAmount'] * aCost['monthCount']);
    
        // **Fix costChartRow creation**
        let costChartRow = new Array(aCost.monthStart).fill(0); // Fill with zeros for inactive months
    
        if (aCost.costType === "Quarterly_Cost_Component") {
            for (let i = 0; i  <  aCost.monthCount; i++) {
                if ((i + aCost.monthStart) % 3 === 0) { // Apply cost every 3rd month
                    costChartRow.push(aCost.monthlyAmount);
                } else {
                    costChartRow.push(0); // Keep zero in other months
                }
            }
        } else {
            for (let i = 0; i  <  aCost.monthCount; i++) {
                costChartRow.push(aCost.monthlyAmount);
            }
        }
    
        costChartRowList.push(costChartRow);
    });
    
    // **Fix month-by-month cost distribution**
    let monthsListCount = momentEndFinYear.diff(momentStartFinYear, 'months') + 1;
    let monthsList = [];
    let sumsList = Array(monthsListCount).fill(0);
    
    for (let i = 0; i  <  monthsListCount; i++) {
        monthsList.push(moment(momentStartFinYear).add(i, 'months').format('MM/YYYY'));
    
        let monthlyTotal = 0;
        costChartRowList.forEach((row) => {
            if (row[i]) {
                monthlyTotal += row[i];
            }
        });
    
        sumsList[i] = monthlyTotal;
    }
     
  cbcLabels = [];
  cbcVals = [];

  cbtLabels = [];
  cbtVals = [];

  cbfLabels = [];
  cbfVals = [];
  costByCategory.forEach((f) => {
    if (f.key == "undefined") {
      f["key"] = "Run Cost";
    }
    cbcLabels.push(f.key);
    cbcVals.push(f.value.total);
  });

  costByType.forEach((f) => {
    cbtLabels.push(f.key);
    cbtVals.push(f.value.total);
  });

  let totalCost = 0;
  costByFreq.forEach((f) => {
    cbfLabels.push(f.key);
    cbfVals.push(f.value.total);
  });
 
  $("#ctc").html(costTotalTemplate(costNumbers));
  
ccy.forEach((c)=>{
	$('#ccySelect').append('<option value="'+c.id+'">'+c.ccyCode+'</option>');
})

$('#ccySelect').select2({
  width:'100px'
});

$('#ccySelect').on('change', function() {
  const currency = $(this).val();
  updateCharts(currency);
});

if(cbfLabels.length>0){
  const chartCostByFrequency = new Chart(document.getElementById("costByFrequency-chart"), {
    type: 'doughnut',
    data: {
      labels: cbfLabels,
      datasets: [
        {
          label: "Frequency",
          backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
          data: cbfVals
        }
      ]
    },
    options: {
      responsive: true,
      title: {
        display: true,
        text: 'Cost By Frequency'
      },
      legend: {
        position: "bottom",
        align: "middle"
      }
    }
  });
  
  // Repeat for other charts
  const chartCostByCategory = new Chart(document.getElementById("costByCategory-chart"), {
    type: 'doughnut',
    data: {
      labels: cbcLabels,
      datasets: [
        {
          label: "Type",
          backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
          data: cbcVals
        }
      ]
    },
    options: {
      responsive: true,
      title: {
        display: true,
        text: 'Cost By Category'
      },
      legend: {
        position: "bottom",
        align: "middle"
      }
    }
  });
  
  const chartCostByType = new Chart(document.getElementById("costByType-chart"), {
    type: 'doughnut',
    data: {
      labels: cbtLabels,
      datasets: [
        {
          label: "Type",
          backgroundColor: ["#3e95cd", "#8e5ea2", "#3cba9f", "#e8c3b9", "#c45850"],
          data: cbtVals
        }
      ]
    },
    options: {
      responsive: true,
      title: {
        display: true,
        text: 'Cost By Type'
      },
      legend: {
        position: "right",
        align: "middle"
      }
    }
  });
  
  const chartCostByMonth = new Chart(document.getElementById("costByMonth-chart"), {
    type: 'bar',
    data: {
      labels: monthsList,
      datasets: [
        {
          label: "Cost Per Month",
          backgroundColor: "#f5aa42",
          data: sumsList
        }
      ]
    },
    options: {
      responsive: true,
      scales: {
        yAxes: [{
          ticks: {
            beginAtZero: true,
            callback: function(value) {
              return new Intl.NumberFormat('en-US', { style: 'currency', currency: defaultCurrency.ccyCode }).format(value); // Change to the selected currency
            }
          }
        }]
      },
      plugins: {
        labels: false
      }
    }
  });

function updateCharts(currency) {
 
	let ccySelected=ccy.find(d => d.id == currency)
 	let rate = ccySelected.exchangeRate;
	let ccyCd = ccySelected.ccyCode;
	
  // Convert the rate to a float
  rate = parseFloat(rate); 

  if (isNaN(rate)) {
    rate = 1;
  } 
  // Remove the currency symbol and commas, then convert the string to a float
  let annualCostValue = parseFloat(costNumbers.annualCost.replace(/[^\d.-]/g, ''));
  let monthlyCostValue = parseFloat(costNumbers.monthlyCost.replace(/[^\d.-]/g, ''));

  // Multiply the costs by the exchange rate
  annualCostValue *= rate;
  monthlyCostValue *= rate;

	$('#regAnnual').text(new Intl.NumberFormat('en-US', { 
      style: 'currency', 
      currency: ccyCd 
    }).format(annualCostValue));

	$('#regMonthly').text(new Intl.NumberFormat('en-US', { 
      style: 'currency', 
      currency: ccyCd 
    }).format(monthlyCostValue));

  // Multiply the values by the exchange rate
  const updatedCbfVals = cbfVals.map(value => value * rate);
  const updatedCbcVals = cbcVals.map(value => value * rate);
  const updatedCbtVals = cbtVals.map(value => value * rate);
  const updatedSumsList = sumsList.map(value => value * rate);

    // Update the Y-axis label with the selected currency symbol
  chartCostByMonth.options.scales.yAxes[0].ticks.callback = function(value) {
    return new Intl.NumberFormat('en-US', { 
      style: 'currency', 
      currency: ccyCd 
    }).format(value);
  };

  // Update each chart
  chartCostByFrequency.data.datasets[0].data = updatedCbfVals;
  chartCostByCategory.data.datasets[0].data = updatedCbcVals;
  chartCostByType.data.datasets[0].data = updatedCbtVals;
  chartCostByMonth.data.datasets[0].data = updatedSumsList;

  // Re-render the charts
  chartCostByFrequency.update();
  chartCostByCategory.update();
  chartCostByType.update();
  chartCostByMonth.update();
}

    } 

        costtable = $('#dt_costs').DataTable({ 
            paging: false,
            deferRender:    true,
            scrollY:        350,
            scrollCollapse: true,
            info: true,
            sort: true, 
            responsive: false, 
            dom: 'Bfrtip',
            buttons: [
                'copyHtml5', 
                'excelHtml5',
                'csvHtml5',
                'pdfHtml5',
                'print'
            ]
         });

         /*
         $('.dt_costs tfoot th').each(function () {
            console.log('t', $(this))
            let costtitle = $(this).text();
            $(this).html('<input type="text" placeholder="Search ' + costtitle + '" />');
        });
        
         costtable.columns().every( function () {
            let that = this;
                $( 'input', this.footer() ).on( 'keyup change', function () {
                if ( that.search() !== this.value ) {
                that
                .search( this.value )
                .draw();
                }
                } );
            });
        costtable.columns.adjust()
         */
}
}


