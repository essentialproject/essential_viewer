Handlebars.registerHelper('some', function (array, key) {
 
    return array && array.some(item => item[key]);
});

Handlebars.registerHelper('styles', function (value) {
    
    let match = styles.find((a)=>{
        return a.id == value
    }) 

    if(match?.length > 0){
        return 'background-color:'+ match.backgroundColour +'; color:'+ match.textColour 
    }
});

Handlebars.registerHelper('breaklines', function (html) {
    html = html.replace(/(\r&lt;li&gt;)/gm, '&lt;li&gt;');
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
function getIndivAndGroupActorsStakeholders(focusNode) {
    let indivStakeholders = focusNode.stakeholders?.filter((f) => { return f.type != 'Group_Actor' });
    focusNode['orgStakeholders'] = focusNode.stakeholders?.filter((f) => { return f.type == 'Group_Actor' });

    if(indivStakeholders){
        let indivStakeholdersList = d3.nest()
            .key(function (d) { return d.actor; })
            .entries(indivStakeholders);

        indivStakeholdersList?.forEach((d) => {
            let sid = focusNode.stakeholders?.find((s) => {
                return s.actor == d.key
            })
            d['id'] = sid.actorId;
            d['name'] = d.key;
        });
        focusNode['indivStakeholdersList'] = indivStakeholdersList;
    }
    if(focusNode.orgStakeholders){
        let orgStakeholdersList = d3.nest()
            .key(function (d) { return d.actor; })
            .entries(focusNode.orgStakeholders);

        orgStakeholdersList?.forEach((d) => {
            let sid = focusNode.stakeholders.find((s) => {
                return s.actor == d.key
            })
            d['id'] = sid.actorId;
            d['name'] = d.key;
        })
        focusNode['orgStakeholdersList'] = orgStakeholdersList;
    }
    return focusNode;
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
var styles, nodeMap

$('document').ready(function () {

    var panelFragment = $("#panel-template").html();
    panelTemplate = Handlebars.compile(panelFragment);

    var selectFragment = $("#select-template").html();
    selectTemplate = Handlebars.compile(selectFragment);

    Promise.all([
        promise_loadViewerAPIData(viewAPIDataNodes) 
        ]).then(function(responses) { 
            styles = responses[0].styles
            let nodes = responses[0].nodes
            let appSoftwareMap = responses[0].appSoftwareMap

            nodes?.forEach((node) => {
                var option = new Option(node.name, node.id);
                $('#subjectSelection').append($(option))
   
                node.instances?.forEach((i)=>{
                    i.app?.software_architectures.forEach((s)=>{
                       
                    })
                })
            });

            nodeMap = new Map();
            nodes?.forEach(node => {
                nodeMap.set(node.id, node);
            });
        
            focusNode = nodes.find((e)=>{return e.id == focusNodeId})
            drawView(focusNode)
            $('#subjectSelection').off('change').on('change', function () {
                let selected = $(this).val();
                console.log(selected);
                focusNode = nodes.find((e) => e.id == selected);
                drawView(focusNode);
                // Redirect to the page to remove unnecessary JavaScript
            });
            $('#subjectSelection').select2();
            $('#subjectSelection').val(focusNodeId).change();
           
        })


  
});

function drawView(nodeToShow){
   
    // Step 2: Function to get connected nodes (both inbound and outbound)
    function getConnectedNodes(nodeId) {
        const node = nodeMap.get(nodeId); 
   
        if (!node) return { outbound: [], inbound: [] };
    
        const outbound = (node.outboundConnections || [])
            .map(id => nodeMap.get(id))
            .filter(connectedNode => connectedNode !== undefined)
            .map(connectedNode => ({ id: connectedNode.id, name: connectedNode.name,  icon: connectedNode.technology_node_type?.icon}));
    
        const inbound = (node.inboundConnections || [])
            .map(id => nodeMap.get(id))
            .filter(connectedNode => connectedNode !== undefined)
            .map(connectedNode => ({ id: connectedNode.id, name: connectedNode.name,  icon: connectedNode.technology_node_type?.icon }));
    
        return { outbound, inbound };
    }
 
    $('#selectMenu').html(selectTemplate(nodeToShow))
    $('.context-menu-techNodeGenMenu').html('<i class="fa fa-bars"></i> Menu');
console.log('fn', nodeToShow)

    let nodes=[nodeToShow]
    // Step 3: Iterate through each node to build the graph
    nodes?.forEach(node => {
        const graphNodes = [];
        const graphEdges = [];
   
        // Get both outbound and inbound connections
        const { outbound: firstLevelOutbound, inbound: firstLevelInbound } = getConnectedNodes(node.id);
    
        // Handle Outbound Connections
        firstLevelOutbound?.forEach(conn => {
            graphNodes.push(conn);
            graphEdges.push({ from: node.id, to: conn.id });
    
            // Second Level Connections for Outbound
            const { outbound: secondLevelOutbound, inbound: secondLevelInbound } = getConnectedNodes(conn.id);
    
            // Outbound from second level
            secondLevelOutbound?.forEach(conn2 => {
                if (conn2.id !== node.id) {
                    graphNodes.push(conn2);
                    graphEdges.push({ from: conn.id, to: conn2.id });
                }
            });
    
            // Inbound to second level
            secondLevelInbound?.forEach(conn2 => {
                if (conn2.id !== node.id) {
                    graphNodes.push(conn2);
                    graphEdges.push({ from: conn2.id, to: conn.id });
                }
            });
        });
    
        // Handle Inbound Connections
        firstLevelInbound?.forEach(conn => {
            graphNodes.push(conn);
            graphEdges.push({ from: conn.id, to: node.id });
    
            // Second Level Connections for Inbound
            const { outbound: secondLevelOutbound, inbound: secondLevelInbound } = getConnectedNodes(conn.id);
    
            // Outbound from second level
            secondLevelOutbound?.forEach(conn2 => {
                if (conn2.id !== node.id) {
                    graphNodes.push(conn2);
                    graphEdges.push({ from: conn.id, to: conn2.id });
                }
            });
    
            // Inbound to second level
            secondLevelInbound?.forEach(conn2 => {
                if (conn2.id !== node.id) {
                    graphNodes.push(conn2);
                    graphEdges.push({ from: conn2.id, to: conn.id });
                }
            });
        });
    
        // Remove duplicate nodes
        const uniqueNodesMap = new Map();
        graphNodes?.forEach(n => {
            if (!uniqueNodesMap.has(n.id)) {
                uniqueNodesMap.set(n.id, n);
            }
        });
        const uniqueNodes = Array.from(uniqueNodesMap.values());
    
        // Append the graph property to the node
        node.graph = {
            nodes: uniqueNodes,
            edges: graphEdges
        };
    });
    
 



focusNode = getIndivAndGroupActorsStakeholders(nodeToShow);

// Temp fix for ipAddress
let ipAddress = focusNode.attributes?.find(o => o.key === 'IP Address');
focusNode['IPAddress'] = ipAddress;
 
 
$('#mainPanel').html(panelTemplate(focusNode))
if(focusNode.graph.nodes.length > 0){
focusNode.graph.nodes.push({"id": focusNode.id, "name": focusNode.name, "primary": true, "icon": focusNode.technology_node_type?.icon})
generateForceChart(focusNode.graph)
}

activateStakeholdersDataTable()
$('a[data-toggle="tab"]').on('shown.bs.tab', function(e){ $($.fn.dataTable.tables(true)).DataTable() .columns.adjust(); } ); 

}

function generateForceChart(dataSet) {
    let nodes = dataSet.nodes;
    let edges = dataSet.edges;

    const graph = {
        nodes: nodes.map(node => Object.assign({}, node)),
        links: edges.map(edge => ({
            source: edge.from,
            target: edge.to
        }))
    };

    const width = 960, height = 600;
    const radius = 200;

    const svg = d3.select("svg")
        .attr("width", width)
        .attr("height", height);

    svg.append('defs').append('marker')
        .attr('id', 'arrowhead')
        .attr('viewBox', '-0 -5 10 10')
        .attr('refX', 23)
        .attr('refY', 0)
        .attr('orient', 'auto')
        .attr('markerWidth', 6)
        .attr('markerHeight', 6)
        .append('svg:path')
        .attr('d', 'M 0,-5 L 10 ,0 L 0,5')
        .attr('fill', '#999')
        .style('stroke', 'none');

    graph.nodes?.forEach((node, i) => {
        const angle = (i / graph.nodes.length) * 2 * Math.PI;
        node.x = width / 2 + radius * Math.cos(angle);
        node.y = height / 2 + radius * Math.sin(angle);
    });

    const simulation = d3.forceSimulation(graph.nodes)
        .force("link", d3.forceLink(graph.links)
            .id(d => d.id)
            .distance(150)
            .strength(0.2))
        .force("charge", d3.forceManyBody().strength(-150))
        .force("center", d3.forceCenter(width / 2, height / 2))
        .force("radial", d3.forceRadial(radius, width / 2, height / 2));

    const link = svg.append("g")
        .attr("class", "links")
        .selectAll("line")
        .data(graph.links)
        .enter().append("line")
        .attr("stroke-width", 2)
        .attr('marker-end', 'url(#arrowhead)');

    const node = svg.append("g")
        .attr("class", "nodes")
        .selectAll("g")
        .data(graph.nodes)
        .enter().append("g")
        .call(d3.drag()
            .on("start", dragstarted)
            .on("drag", dragged)
            .on("end", dragended));

    // Add rectangles with pastel colours
    node.append("rect")
        .attr('y', -30)
        .attr('x', -42)
        .attr('rx', 8)
        .attr('ry', 8)
        .attr('height', 60)
        .attr("width", 85)
        .attr("fill", d => d.primary ? "#c0bfcf" : "#d0d9e2") // Orange for primary, pastel green for others
        .attr("stroke", "#000000");

    // Node labels
   /* node.append("text")
        .attr("dx", 0)
        .attr("dy", 4)
        .attr("text-anchor", "middle")
        .text(d => d.name);
*/
    // Add Font Awesome icons using foreignObject
    node.append("foreignObject")
        .attr("x", -42) // Adjust position relative to the rect
        .attr("y", -20)
        .attr("width", 85)
        .attr("height", 56)
        .append("xhtml:div")
        .style("font-size", "10px")
        .style("text-align", "center") 
        .style("font-family", "Verdana")
        .html(d => { 
            return `<i class="fa ${d.icon || 'fa-circle'}" style="font-size:14px"></i><br/>` + d.name;
        }); // Default to 'fa-circle'
    simulation.on("tick", () => {
        link
            .attr("x1", d => d.source.x)
            .attr("y1", d => d.source.y)
            .attr("x2", d => d.target.x)
            .attr("y2", d => d.target.y);

        node
            .attr("transform", d => `translate(${d.x},${d.y})`);
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
