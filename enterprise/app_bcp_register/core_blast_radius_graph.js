function flattenData(root) {
  let nodes = [], links = [], types = [];
  const visited = new Set();

  function traverse(node, depth) {
    if (visited.has(node.id)) return;
    visited.add(node.id);

    // add the node itself
    nodes.push({ id: node.id, name: node.name, depth });

    // 1) existing dependencies
    if (node.dependencies) {
      node.dependencies.forEach(child => {
        links.push({ source: node.id, target: child.id });
        traverse(child, depth + 1);
      });
    }

    // 2) ALSO handle any apps array
    if (node.apps) {
 
      node.apps.forEach(child => {
        links.push({ source: node.id, target: child.id });
        links.push({ source: node.id, target: child.id }); 
        traverse(child, depth + 1);
      });
    }

    // 3) (and your provided_by_application_provider_roles, if you still need that)
    if (node.provided_by_application_provider_roles) {
      node.provided_by_application_provider_roles.forEach(child => {
        links.push({ source: node.id, target: child.id });
        traverse(child, depth + 1);
      });
    }
  }

  traverse(root, 0);
  return { nodes, links, types };
}

function renderBlastRadiusGraph(svgId, graphData, elOfInterestId, onClickCallBack) {
 
    const brElOfInterestId = elOfInterestId;

    eventforGraphId= graphData.id;
 
    const { nodes, links } = flattenData(graphData);
    //const { nodes, links } = flattenData(testData);
    //console.log('nodes', nodes);
    const svg = d3.select('#' + svgId),
        width = +svg.attr("width"),
        height = +svg.attr("height");
        g = svg.append("g"); 

    // Define radial distance for each depth
    const zoom = d3.zoom()
        .scaleExtent([0.5, 10])  // Limit scale range between 0.5x and 10x
        .on("zoom", (event) => {
            g.attr("transform", event.transform);  // Apply zoom and pan transformations
        });

    svg.call(zoom);  // Apply zoom behavior to the SVG

    function getRadiusForDepth(depth) {
        const baseRadius = 60; // Base radius for level 1 nodes
        return depth * baseRadius; // Each level is spaced out by an additional baseRadius units
    }

    // Define a link distance function that accounts for depth to keep children closer to their parents
    function linkDistance(d) {
        const depthDifference = d.target.depth - d.source.depth;
        if (depthDifference === 1) {
            return 100; // Shorter distance for immediate children
        } else {
            return 100; // Longer distance for unrelated links
        }
    }
 
    const uniqueDepths = [...new Set(nodes.map(node => node.depth))].sort();

    // Calculate unique depths and maximum depth for scaling force strengths
    const maxDepth = Math.max(...uniqueDepths);
    
    // Create and style nodes and links
    // Links
    const linkElements = g.append("g")
        .attr("class", "links")
        .selectAll("line")
        .data(links)
        .enter().append("line")
        .style("stroke-width", "1px")
        .style("stroke", "black")
        .style("opacity", 0.2); // Start with an invisible link

    // Gradually display links
   
    linkElements.transition()
        .delay((d, i) => i * 150) // Adjust delay time based on your needs
        .duration(500)
        .style("opacity", 1)

    const tooltip = d3.select("body").append("div")
    .attr("class", "tooltip");

    const nodeElements = g.append("g")
        .attr("class", "nodes")
        .selectAll("circle")
        .data(nodes)
        .enter().append("circle")
        .attr("r", d => d.id === brElOfInterestId ? 8 : d.id === eventforGraphId ? 8: 6)
        .attr("easradii", d => d.id === brElOfInterestId ? 12 : d.id === eventforGraphId ? 12: 9) // required to stop mouseover event firing too quickly and shrinking the circle
        .attr("fill", d => d.id === brElOfInterestId ? "#ea9999" : d.id === eventforGraphId ? "#c79dcc" : "#47bfa5")
 // Conditional fill color eventforGraphId
        .attr("stroke", d => d.id === brElOfInterestId ? "red": d.id === eventforGraphId ? "#b147bf" : "none")  // Conditional stroke color
        .attr("stroke-width", d => d.id === brElOfInterestId ? 3: d.id === eventforGraphId ? 3 : 1)  
        .style("opacity", 1)
        .on("mouseover", function(event, d) {
            
            d3.select(this)
            .transition()
            .duration(300)
            .attr("r", d3.select(this).attr("r") * 1.5) // Increase radius
            .style("opacity", 0.6);  //
        }) 
        .on("mouseout", function() {
            d3.select(this)
            .transition()
            .duration(300)
            .attr("r", d3.select(this).attr("easradii") / 1.5) // Reset radius
            .style("opacity", 1);  // Reset opacity
        })
        .on("click", function(event, d) {
            //console.log('CLICKED ON:', d);
            /* if(d?.className == "Business_Continuity_Event") {
                if(onClickCallBack) {
                    onClickCallBack(d, brElOfInterestId);
                }
            } */
            // event ID is eventforGraphId  app ID is brElOfInterestId
            //let TESTTEXT='Hello<br/> Hello<br/> Hello<br/> Hello<br/> Hello<br/> Hello<br/> '
            //$('#ess-event-blast-radius-node-dets').html(TESTTEXT)
        });

        // Fade in nodes
    nodeElements.transition()
        .delay((d, i) => i * 150) // Adjust delay to control timing
        .duration(500)
        .style("opacity", 1); // Fade to visible


    const textElements = g.append("g")
        .attr("class", "texts")
        .selectAll("text")
        .data(nodes)
        .enter().append("text")
        .text(d => d.name)
        .attr("font-size", d => d.id === brElOfInterestId ? 15: d.id === eventforGraphId ? 15 : 8)
        .attr("font-family", "verdana")
        .attr("dx", d => d.id === brElOfInterestId ? -2 : -2)
        .attr("dy", 2);

        

    // Initialize force simulation
    const simulation = d3.forceSimulation(nodes)
        .force("link", d3.forceLink(links).id(d => d.id).distance(50).strength(0.7)) // Adjust strength for tighter or looser link grouping
        .force("charge", d3.forceManyBody().strength(-400)) // Increase repulsive force to spread nodes more evenly
        .force("radial", d3.forceRadial(d => getRadiusForDepth(d.depth), width / 2, height / 2).strength(0.8)) // Ensure nodes align to their depths
        .on("tick", ticked);
        
    function ticked() {
        nodeElements.attr("cx", d => d.x).attr("cy", d => d.y);
        linkElements.attr("x1", d => d.source.x).attr("y1", d => d.source.y)
                    .attr("x2", d => d.target.x).attr("y2", d => d.target.y);
        textElements.attr("x", d => d.x + 12).attr("y", d => d.y + 4);
    }

    g.selectAll("circle.depth-circle").data(uniqueDepths)
        .enter().append("circle")
        .attr("class", "depth-circle")
        .attr("cx", (width / 2)-10)
        .attr("cy", (height / 2)+2)
        .attr("r", depth => getRadiusForDepth(depth))
        .style("fill", "none")
        .style("stroke", "#e3e3e3")
        .style("stroke-dasharray", "3,3");


    // Drag functionality to enhance interaction
    svg.call(d3.drag()
        .container(svg.node())
        .subject(() => simulation.find(d3.event.x, d3.event.y))
        .on("start", dragstarted)
        .on("drag", dragged)
        .on("end", dragended));

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