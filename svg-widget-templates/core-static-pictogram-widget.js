function renderStaticPictogramChart(widgetData) {
    
    var pictogram = staticPictogramChart()
        //widget framework properties
        .width(widgetData.width)
        .height(widgetData.height)
        .xPos(widgetData.xPos)
        .yPos(widgetData.yPos)
        .scale(widgetData.scale)
        .svgClass(widgetData.svgClass)
        .svgTheme(widgetData.svgTheme)
        //widget template specific properties
        .iconType(widgetData.dataSet.iconType)
        .pictoValue(widgetData.dataSet.value)
        .subject(widgetData.dataSet.subject);
        
    var myChart = d3.select('#' + widgetData.containerId)
            .call(pictogram); // draw chart in the given container

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


function staticPictogramChart() {
    var margin = {top: 10, right: 10, bottom: 10, left: 10},
        width,
        height,
        xPos,
        yPos,
        scale,
        svgClass, // the css class to be assigned to the main svg
        svgTheme,  //the theme that is used to style the svg
        iconType, // type of icon to be used in the pictogram
        pictoValue,
        subject;
    
    
    
    //the list of supported icon types
    var iconTypes = {
        'person': 'M3.5,2H2.7C3,1.8,3.3,1.5,3.3,1.1c0-0.6-0.4-1-1-1c-0.6,0-1,0.4-1,1c0,0.4,0.2,0.7,0.6,0.9H1.1C0.7,2,0.4,2.3,0.4,2.6v1.9c0,0.3,0.3,0.6,0.6,0.6h0.2c0,0,0,0.1,0,0.1v1.9c0,0.3,0.2,0.6,0.3,0.6h1.3c0.2,0,0.3-0.3,0.3-0.6V5.3c0,0,0-0.1,0-0.1h0.2c0.3,0,0.6-0.3,0.6-0.6V2.6C4.1,2.3,3.8,2,3.5,2z',
        'application': 'M 6.4745674,3.6859206 V 0.57918077 q 0,-0.048538 -0.034636,-0.084018 -0.034636,-0.035473 -0.082031,-0.035473 H 0.52456852 q -0.047396,0 -0.0820313,0.035473 -0.034636,0.035476 -0.034636,0.084018 V 3.6859206 q 0,0.048545 0.034636,0.084014 0.034636,0.035476 0.0820313,0.035476 H 6.3579015 q 0.047395,0 0.082031,-0.035476 0.034636,-0.035476 0.034636,-0.084014 z M 6.9412343,0.57918077 V 4.6418406 q 0,0.2464455 -0.1713542,0.4219494 Q 6.5985257,5.239294 6.3579012,5.239294 H 4.3745678 q 0,0.1381562 0.058333,0.289387 0.058334,0.151228 0.1166676,0.265118 0.058334,0.1138858 0.058334,0.1624315 0,0.097087 -0.06927,0.168035 -0.06927,0.070945 -0.1640622,0.070945 H 2.5079011 q -0.094791,0 -0.1640621,-0.070945 -0.069272,-0.070948 -0.069272,-0.168035 0,-0.052276 0.058334,-0.164297 Q 2.391235,5.6799097 2.4495672,5.53055 2.5079012,5.381184 2.5079012,5.239294 H 0.52456782 Q 0.28394279,5.239294 0.1125884,5.06379 -0.05876565,4.8882861 -0.05876565,4.6418406 V 0.57918077 q 0,-0.2464493 0.17135405,-0.4219498 0.17135439,-0.175504 0.41197942,-0.175504 H 6.3579008 q 0.2406246,0 0.411979,0.175504 0.1713542,0.1755005 0.1713545,0.4219498 z',
        'server': 'M 5.5174889,1.4750278 H 0.26748908 c -0.20710553,0 -0.37500008,-0.167895 -0.37500008,-0.375 V 0.35002782 c 0,-0.207105 0.16789455,-0.375 0.37500008,-0.375 H 5.5174889 c 0.2071059,0 0.3750001,0.167895 0.3750001,0.375 V 1.1000278 c 0,0.207105 -0.1678942,0.375 -0.3750001,0.375 z M 4.9549892,0.44377782 c -0.1553321,0 -0.28125,0.1259175 -0.28125,0.28125 0,0.1553325 0.1259179,0.28124998 0.28125,0.28124998 0.1553322,0 0.2812497,-0.12591748 0.2812497,-0.28124998 0,-0.1553325 -0.1259175,-0.28125 -0.2812497,-0.28125 z m -0.7500001,0 c -0.155332,0 -0.28125,0.1259175 -0.28125,0.28125 0,0.1553325 0.125918,0.28124998 0.28125,0.28124998 0.1553321,0 0.28125,-0.12591748 0.28125,-0.28124998 0,-0.1553325 -0.1259179,-0.28125 -0.28125,-0.28125 z M 5.5174889,3.3500279 H 0.26748908 c -0.20710553,0 -0.37500008,-0.167895 -0.37500008,-0.375 v -0.75 c 0,-0.207105 0.16789455,-0.3750001 0.37500008,-0.3750001 H 5.5174889 c 0.2071059,0 0.3750001,0.1678951 0.3750001,0.3750001 v 0.75 c 0,0.207105 -0.1678942,0.375 -0.3750001,0.375 z m -0.5624997,-1.03125 c -0.1553321,0 -0.28125,0.1259175 -0.28125,0.28125 0,0.1553325 0.1259179,0.28125 0.28125,0.28125 0.1553322,0 0.2812497,-0.1259175 0.2812497,-0.28125 0,-0.1553325 -0.1259175,-0.28125 -0.2812497,-0.28125 z m -0.7500001,0 c -0.155332,0 -0.28125,0.1259175 -0.28125,0.28125 0,0.1553325 0.125918,0.28125 0.28125,0.28125 0.1553321,0 0.28125,-0.1259175 0.28125,-0.28125 0,-0.1553325 -0.1259179,-0.28125 -0.28125,-0.28125 z m 1.3124998,2.90625 H 0.26748908 c -0.20710553,0 -0.37500008,-0.167895 -0.37500008,-0.375 v -0.75 c 0,-0.207105 0.16789455,-0.375 0.37500008,-0.375 H 5.5174889 c 0.2071059,0 0.3750001,0.167895 0.3750001,0.375 v 0.75 c 0,0.207105 -0.1678942,0.375 -0.3750001,0.375 z m -0.5624997,-1.03125 c -0.1553321,0 -0.28125,0.1259175 -0.28125,0.28125 0,0.1553325 0.1259179,0.28125 0.28125,0.28125 0.1553322,0 0.2812497,-0.1259175 0.2812497,-0.28125 0,-0.1553325 -0.1259175,-0.28125 -0.2812497,-0.28125 z m -0.7500001,0 c -0.155332,0 -0.28125,0.1259175 -0.28125,0.28125 0,0.1553325 0.125918,0.28125 0.28125,0.28125 0.1553321,0 0.28125,-0.1259175 0.28125,-0.28125 0,-0.1553325 -0.1259179,-0.28125 -0.28125,-0.28125 z'
    }
        
    

    function chart(selection){
        // generate chart

        // ===========================================================================================
        // append the svg container object to the selection
        var viewBoxDef = '0 0 ' + (width) + ' ' + (height);
        var svgContainer = selection.append('svg')
            .attr('class', svgClass)
            .attr('width', width)
            .attr('height', height)
            .attr('viewBox', '0 0 100 100')
            //.attr("viewBox","0 0 " + (width + margin.left + margin.right) + " " + (height + margin.top + margin.bottom))
            .attr('x', xPos)
            .attr('y', yPos)
            .styles(svgTheme.styles.widgetSVG);
         
         //create the re-usable definitions section for the widget
         var svgDefs = svgContainer
            .append('defs')      
            
         //create the re-usable icon shape for the pictogram
         svgDefs.append('g')
            .attr('id', svgClass + '-icon-id')
            .append("path")
                .attr("d", iconTypes[iconType]);
         
         //cretae the re-usable group for the overall widget
         var svg = svgDefs.append('g')
            .attr('id', svgClass + '-id')
            .attr('transform', 'translate(' + scale + ')');
            
         //background rectangle
        //svgContainer.append("rect").attr("width",width).attr("height",height).attr("fill", "#555555");
        svg.append("rect").attr("width",100).attr("height",110).attr('rx', 5).attr('ry', 5);
        
        //specify the number of columns and rows for pictogram layout
        var numCols = 10;
        var numRows = 10;
        
        //padding for the grid
        var xPadding = 10;
        var yPadding = 15;
        
        //horizontal and vertical spacing between the icons
        var hBuffer = 9;
        var wBuffer = 8;
        
        //generate a d3 range for the total number of required elements
        var myIndex=d3.range(numCols*numRows);
        
        //text element to display number of icons highlighted
        svg.append("text")
            .attr("id", svgClass + "-txtValue")
            .attr("x",xPadding)
            .attr("y",yPadding)
            .attr("dy",-6)
            .attr("fill", "orange")
            .styles({'font-size': '0.4em', 'font-weight': 700 })
            //.styles(svgTheme.styles.widgetCalloutTitle)
            .text(subject + ': ' + pictoValue + "%");


        //create group element and create an svg <use> element for each icon
        svg.append("g")
            .attr("id",svgClass + "-pictoLayer")
            .selectAll("use")
            .data(myIndex)
            .enter()
            .append("use")
                .attr("xlink:href","#" + svgClass + "-icon-id")
                .attr("id",function(d)    {
                    return svgClass + "-icon"+d;
                })
                .attr("x",function(d) {
                    var remainder=d % numCols;//calculates the x position (column number) using modulus
                    return xPadding+(remainder*wBuffer);//apply the buffer and return value
                })
                .attr("y",function(d) {
                    var whole=Math.floor(d/numCols)//calculates the y position (row number)
                    return yPadding+(whole*hBuffer);//apply the buffer and return the value
                })
                .attr("fill",function(d,i){
                   if (d < pictoValue)  {
                       return "orange";
                   }    else    {
                       return "white";
                   }
                });
                
                
         svgContainer
            .append('use').attr("xlink:href","#" + svgClass + '-id');
            //.attr("width", width)
            //.attr("height", height);
            
         
        // ===========================================================================================
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

    chart.colour = function(value) {
        if (!arguments.length) return colour;
        colour = value;
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
    
     chart.iconType = function(value) {
        if (!arguments.length) return iconType;
        iconType = value;
        return chart;
    };

    chart.pictoValue = function(value) {
        if (!arguments.length) return pictoValue;
        pictoValue = Math.round(value);
        return chart;
    };
    
    chart.subject = function(value) {
        if (!arguments.length) return subject;
        subject = value;
        return chart;
    };

    return chart;
}