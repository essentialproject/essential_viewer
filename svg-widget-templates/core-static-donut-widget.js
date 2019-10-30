/* Copyright (c) 2017 Michael Hall
Thanks go to Michael Hall for providing this re-usable donut chart
see https://bl.ocks.org/mbhall88/b2504f8f3e384de4ff2b9dfa60f325e2 for details */

function renderStaticDonutChart(widgetData) {
    
    var donut = staticDonutChart()
        .width(widgetData.width)
        .height(widgetData.height)
        .xPos(widgetData.xPos)
        .yPos(widgetData.yPos)
        .scale(widgetData.scale)
        .cornerRadius(3) // sets how rounded the corners are on each slice
        .padAngle(0.015) // effectively dictates the gap between slices
        .sliceValue(widgetData.dataSet.valueProperty)
        .sliceProperty(widgetData.dataSet.categoryProperty)
        .svgClass(widgetData.svgClass)
        .svgTheme(widgetData.svgTheme);
        
    var myChart = d3.select('#' + widgetData.containerId)
            .datum(widgetData.dataSet.data) // bind data to the div
            .call(donut); // draw chart in div

}


function wrap(text, textString, aWidth, aHeight, aScale) {
    var diameter = (Math.min(aWidth, aHeight) / 2) * 0.8,
          words = textString.split(/\s+/).reverse(),
          word,
          line = [],
          lineNumber = 0,
          lineHeight = 1.1, // ems
          y = text.attr("y"),
          dy = parseFloat(text.attr("dy")),
          tspan = text.html(null).append("tspan").attr("x", 0).attr("y", y * aScale).attr("dy", -15);
          
          //console.log('Wrapping with width: ', aWidth + ', height: ' + aHeight + ' for width: ' + tspan.node().getComputedTextLength());
      while (word = words.pop()) {
        line.push(word);
        tspan.html(line.join(" "));
        //console.log('Wrapping with width: ', aWidth + ', height: ' + aHeight + ' for width: ' + tspan.node().getComputedTextLength() + ', word count: ' + words.length);
        if (tspan.node().getComputedTextLength() > diameter) {
          line.pop();
          tspan.text(line.join(" "));
          line = [word];
          tspan = text.append("tspan").attr("x", 0).attr("y", y).attr("dy", lineHeight + "em").text(word);
        }
      }
  }


function staticDonutChart() {
    var width,
        height,
        xPos,
        yPos,
        scale,
        margin = {top: 10, right: 10, bottom: 10, left: 10},
        //colour = d3.scaleOrdinal(d3.schemeCategory20c), // colour scheme
        sliceValue, // value in data that will dictate proportions on chart
        sliceProperty, // compare data by
        svgClass, // the css class to be assigned to the main svg
        svgTheme,  //the theme that is used to style the svg
        padAngle, // effectively dictates the gap between slices
        floatFormat = d3.format('.4r'),
        cornerRadius, // sets how rounded the corners are on each slice
        percentFormat = d3.format(',.2%');
        
    

    function chart(selection){
        selection.each(function(data) {
            // generate chart

            // ===========================================================================================
            // Set up constructors for making donut. See https://github.com/d3/d3-shape/blob/master/README.md
            var radius = Math.min(width, height) / 2;

            // creates a new pie generator
            var pie = d3.pie()
                .value(function(d) { return floatFormat(d[sliceValue]); })
                .sort(null);

            // contructs and arc generator. This will be used for the donut. The difference between outer and inner
            // radius will dictate the thickness of the donut
            var arc = d3.arc()
                .outerRadius(radius * 0.8)
                .innerRadius(radius * 0.6)
                .cornerRadius(cornerRadius)
                .padAngle(padAngle);

            // this arc is used for aligning the text labels
            var outerArc = d3.arc()
                .outerRadius(radius * 0.9)
                .innerRadius(radius * 0.9);
            // ===========================================================================================

            // ===========================================================================================
            // append the svg object to the selection
            var svgContainer = selection.append('svg')
                .attr('class', svgClass)
                .attr('width', width + margin.left + margin.right)
                .attr('height', height + margin.top + margin.bottom)
                .attr('x', xPos)
                .attr('y', yPos)
                .styles(svgTheme.styles.widgetSVG);
             
             var svg = svgContainer
                .append('defs')
                .append('g')
                .attr('id', svgClass + '-id')
                .attr('transform', 'translate(' + width / 2 + ',' + height / 2 + ')' + ' scale(' + scale + ')');
                
             
            // ===========================================================================================

            // ===========================================================================================
            // g elements to keep elements within svg modular
            svg.append('g').attr('class', 'slices');
            svg.append('g').attr('class', 'labelName');
            svg.append('g').attr('class', 'lines');
            // ===========================================================================================

            // ===========================================================================================
            // add and colour the donut slices
            var path = svg.select('.slices')
                .datum(data).selectAll('path')
                .data(pie)
              .enter().append('path')
                .attr('class', svgClass + 'widgetCategories')
                .attr('fill', function(d, i) { 
                    var categoryColourScheme = svgTheme.widgetCategories;
                     if(i < categoryColourScheme.length) {
                        return categoryColourScheme[i]; 
                    } else {
                        return 'black';
                    }
                 })
                .attr('d', arc);
            // ===========================================================================================

            // ===========================================================================================
            // add text labels
            var label = svg.select('.labelName').selectAll('text')
                .data(pie)
              .enter().append('text')
                .attr('class', 'widgetCalloutTitle')
                .attr('dy', '.35em')
                .styles(svgTheme.styles.widgetCalloutTitle)
                .html(function(d) {
                    // add "key: value" for given sliceProperty. Number inside tspan is bolded in stylesheet.
                    return d.data[sliceProperty] + ': <tspan class="widgetCalloutText">' + percentFormat(d.data[sliceValue]) + '</tspan>';
                })
                .attr('transform', function(d) {

                    // effectively computes the centre of the slice.
                    // see https://github.com/d3/d3-shape/blob/master/README.md#arc_centroid
                    var pos = outerArc.centroid(d);

                    // changes the point to be on left or right depending on where label is.
                    pos[0] = radius * 0.95 * (midAngle(d) < Math.PI ? 1 : -1);
                    return 'translate(' + pos + ')';
                })
                .style('text-anchor', function(d) {
                    // if slice centre is on the left, anchor text to start, otherwise anchor to end
                    return (midAngle(d)) < Math.PI ? 'start' : 'end';
                });
            // ===========================================================================================

            // ===========================================================================================
            // add lines connecting labels to slice. A polyline creates straight lines connecting several points
            var polyline = svg.select('.lines')
                .selectAll('polyline')
                .data(pie)
              .enter().append('polyline')
                .attr('class', 'widgetCalloutLine')
                .attr('points', function(d) {

                    // see label transform function for explanations of these three lines.
                    var pos = outerArc.centroid(d);
                    pos[0] = radius * 0.95 * (midAngle(d) < Math.PI ? 1 : -1);
                    return [arc.centroid(d), outerArc.centroid(d), pos]
                })
                .styles(svgTheme.styles.widgetCalloutLine);
                
            //add the circle containing the pie chart tag line
            svg.append('text')
                .attr('id', svgClass + 'Tagline')
                .attr('class', svgClass + 'Tagline')
              //  .attr('y', -15) // hard-coded. can adjust this to adjust text vertical alignment in tooltip
                .attr('dy', -15) // hard-coded. can adjust this to adjust text vertical alignment in tooltip
                .html('Tagline') // add text to the circle.
                .styles(svgTheme.styles.widgetTagline);

            svg.append('circle')
                .attr('class', 'widgetTaglineContainer')
                .attr('r', radius * 0.55) // radius of circle
                .styles(svgTheme.styles.widgetTaglineContainer);
                
            
            svgContainer
                .append('use').attr("xlink:href","#" + svgClass + '-id');
            
            // ===========================================================================================

            // ===========================================================================================
            // add tooltip to mouse events on slices and labels
            //d3.selectAll('.labelName text, .slices path').call(toolTip);
            // ===========================================================================================

            // ===========================================================================================
            // Functions

            // calculates the angle for the middle of a slice
            function midAngle(d) { return d.startAngle + (d.endAngle - d.startAngle) / 2; }

            // ===========================================================================================

        });
    }

    // getter and setter functions. See Mike Bostocks post "Towards Reusable Charts" for a tutorial on how this works.
    chart.width = function(value) {
        if (!arguments.length) return width;
        width = value;
        return chart;
    };

    chart.height = function(value) {
        if (!arguments.length) return height;
        height = value;
        return chart;
    };
    
    chart.xPos = function(value) {
        if (!arguments.length) return xPos;
        xPos = value;
        return chart;
    };

    chart.yPos = function(value) {
        if (!arguments.length) return yPos;
        yPos = value;
        return chart;
    };
    
    chart.scale = function(value) {
        if (!arguments.length) {
            if(scale != null) {
                return scale;
            } else {
                return 1;
            }
        }
        scale = value;
        return chart;
    };

    chart.margin = function(value) {
        if (!arguments.length) return margin;
        margin = value;
        return chart;
    };

    chart.radius = function(value) {
        if (!arguments.length) return radius;
        radius = value;
        return chart;
    };

    chart.padAngle = function(value) {
        if (!arguments.length) return padAngle;
        padAngle = value;
        return chart;
    };

    chart.cornerRadius = function(value) {
        if (!arguments.length) return cornerRadius;
        cornerRadius = value;
        return chart;
    };

    chart.colour = function(value) {
        if (!arguments.length) return colour;
        colour = value;
        return chart;
    };

    chart.sliceValue = function(value) {
        if (!arguments.length) return sliceValue;
        sliceValue = value;
        return chart;
    };

    chart.sliceProperty = function(value) {
        if (!arguments.length) return sliceProperty;
        sliceProperty = value;
        return chart;
    };
    
    chart.svgClass = function(value) {
        if (!arguments.length) return svgClass;
        svgClass = value;
        return chart;
    };
    
    chart.svgTheme = function(value) {
        if (!arguments.length) return svgTheme;
        svgTheme = value;
        return chart;
    };

    return chart;
}