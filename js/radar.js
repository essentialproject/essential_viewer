// radar renderer

function polar_to_cartesian(r,t) {  
  var x = r * Math.cos(t);
  var y = r * Math.sin(t);
  return [x,y];
}

function identity(i) { return i; }

/**
 * Uses d3 to plot the radar
 */
function radar(id, data) {
	var width = data.width || 800, height = data.height || 600;
  var cx = width / 2, cy = height / 2;
  var horizonWidth = 0.95*(width > height ? height : width) / 2;
  var quad_angle = 2 * Math.PI / data.quadrants.length;
  var horizon_unit = horizonWidth / data.horizons.length;
  var color_scale = d3.scale.category10();
    
	var svg = d3.select(id).append('svg')
    .attr("width", width)
    .attr("height", height);
  svg.append('marker')
    .attr('id','arrow')
    .attr('orient',"auto")
    .attr('markerWidth', '2')
    .attr('markerHeight', '4')
    .attr('refX', 0.1)
    .attr('refY', 2)
    .append('path').attr('d', 'M0,0 V4 L2,2 Z');

  function process_radar_data(data, currentTime) {
    var currentTime = currentTime || new Date();
    // go through the data  
    var results = [];
    for (var i in data.data) {
      var entry = data.data[i];
      var history = entry.history.filter(function(e) {
        return (e.end == null || (e.end > currentTime && e.start < currentTime));
      })[0];
      
      var quadrant_delta = 0;

      // figure out which quadrant this is
      for (var j = 0, len = data.quadrants.length; j < len; j++) {
        if (data.quadrants[j] == history.quadrant) {
          quadrant_delta = quad_angle * j; 
        }
      }

      var theta = (history.position_angle * quad_angle) + quadrant_delta,
          r = history.position * horizonWidth,
          cart = polar_to_cartesian(r, theta);
      var blip = {
        id: i,
        name: entry.name,
        quadrant: history.quadrant,
        r: r,
        theta: theta,
        x: cart[0],
        y: cart[1]
      };

      if (history.direction) {
        var r2 = history.direction * horizonWidth,
            theta2 = (history.direction_angle * quad_angle) + quadrant_delta,
            vector = polar_to_cartesian(r2, theta2);

        blip.dx = vector[0] - cart[0]; 
        blip.dy = vector[1] - cart[1];
      }
      results.push(blip);
    }
    return results;
  }

  function add_horizons(base) {
    var horizons = base
      .append('g')
      .attr('class', 'horizons')
    horizons.selectAll('.horizon')
      .data(data.horizons, identity)
      .enter()
      .append('circle')
      .attr('r', function(d,i) { return (i + 1) * horizon_unit; } )
      .attr('cx', 0)
      .attr('cy', 0)
      .attr('class', 'horizon')
      .append('text')
       .attr("dy", "20px")
     .attr("dx", "20px")
       .style("text-anchor", "middle")
        .attr('class', 'name')
    .attr("color", "red")
        .text(function(d) { return d[0]; });
  }

  function add_quadrants(base) {
    // add the quadrants
    var quadrants = base
      .append('g')
      .attr('class', 'quadrants')
    function quadrant_class(d) {
      return 'quadrant quadarant-' + d.name.toLowerCase().replace(/ /, '-');
    }

    quadrants.selectAll('line.quadrant')
      .data(data.quadrants, identity)
      .enter().append('line')
      .attr('x1', 0)
      .attr('y1', 0)
      .attr('x2', function(d,i) {
        return (Math.cos(quad_angle * i) * horizonWidth);
      })
      .attr('y2',  function(d,i) {
        return (Math.sin(quad_angle * i) * horizonWidth);
      })
      //.attr('class', quadrant_class)
      .attr('stroke', function(d,i) {
        return color_scale(i);
      });
    
    arc_function = d3.svg.arc()
      .outerRadius(function(d,i) {
        return d.outerRadius * horizonWidth;
      })
      .innerRadius(function(d,i) {
        return d.innerRadius * horizonWidth;
      })
      .startAngle(function(d,i) {
        return d.quadrant * quad_angle + Math.PI/2;
      })
      .endAngle(function(d,i) {
        return (d.quadrant + 1) * quad_angle + Math.PI/2;
      });
    
    var quads = []
    for (var i = 0, ilen = data.quadrants.length; i < ilen; i++) {
      for (var j = 0, jlen = data.horizons.length; j < jlen; j++) {
        quads.push({
          outerRadius: (j + 1) / jlen,
          innerRadius: j / jlen,
          quadrant: i, 
          horizon: j, 
          name: data.quadrants[i]
        });
      }
    }
    var text_angle = (360 / data.quadrants.length);

    quadrants.selectAll('text.quadrant')
      .data(quads.filter(function(d) { return d.horizon == 0; }))
      .enter()
      .append('text')
      .attr('class','quadrant')
      .attr('dx', horizonWidth / data.horizons.length)
      .attr('transform', function(d) { return 'rotate(' + (d.quadrant * text_angle + text_angle )+ ')' })
      .text(function(d) { return d.name; })

    quadrants.selectAll('path.quadrant') 
      .data(quads)
      .enter()
      .append('path')
      .attr('d', arc_function)
      .attr('fill', function(d,i) {
        var rgb = d3.rgb(color_scale(d.quadrant));
        return rgb.brighter(d.horizon/data.horizons.length * 3);
      })
      .attr('class', quadrant_class);
  }

  function draw_radar() {
    // add the horizons
    var base = svg.append('g')
      .attr('transform', "translate(" + cx + "," + cy + ")");
    
    add_horizons(base);
    add_quadrants(base);
    
    var blip_data = process_radar_data(data);
    blip_data.sort(
      function (a,b) {
        if (a.quadrant < b.quadrant)
          return -1;
        if (a.quadrant > b.quadrant)
          return 1;
        return 0;
      });

    var blips = base.selectAll('.blip')
      .data(blip_data)
      .enter().append('g')
      .attr('class', 'blip')
      .attr('id', function(d) { return 'blip-' + d.id; })
      .attr('transform', function(d) { return "translate(" + (d.x) + "," + (d.y) + ")"; })
      .on('mouseover', function(d){
        d3.select(this).select("text.name").style({opacity:'1.0'});
      })
      .on('mouseout', function(d){
        d3.select(this).select("text.name").style({opacity:'1.0'});
      })
    
    blips.append('line')
      .attr('class','direction')
      .attr('x1', 0).attr('y1', 0)
      .attr('x2', function(d) { return d.dx; })
      .attr('y2', function(d) { return d.dy; });
      
    blips.append('circle')
      .attr('r', '4px')
    ;
    
    blips.append("text")
        .attr("dy", "5px")
        .attr("dx", "5px")
        .style("text-anchor", "right")
        .attr('class', 'name')
        .text(function(d) { return d.name; });

    // add the lists
//  var ul = d3.select(id).append('ul');
//    ul.selectAll('li.quadrant')
//      .data(blip_data)
//      .enter()
//      .append('li')
//      .attr('class','quadrant')
//      .text(function(d) { return d.name; });
    
  }  
  draw_radar();
}