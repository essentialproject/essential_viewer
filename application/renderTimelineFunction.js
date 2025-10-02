$('document').ready(function () {
 
function renderLifecycleTimeline(containerId, lifecycleData) {
      const $container = $('#' + containerId);

      if ($container.length === 0) {
        console.error('Container not found: ' + containerId);
        return;
      }

      $container.html(`
        <div class="controls">
          <div class="control-group">
            <div class="date-display">Start Date: <span id="startDateDisplay"></span></div>
            <div class="button-group">
              <button id="startDateBack">◀◀</button>
              <button id="startDateBackSmall">◀</button>
              <button id="startDateForwardSmall">▶</button>
              <button id="startDateForward">▶▶</button>
            </div>
          </div>
          <div class="control-group">
            <div class="date-display">End Date: <span id="endDateDisplay"></span></div>
            <div class="button-group">
              <button id="endDateBack">◀◀</button>
              <button id="endDateBackSmall">◀</button>
              <button id="endDateForwardSmall">▶</button>
              <button id="endDateForward">▶▶</button>
            </div>
          </div>
          <div class="zoom-controls">
            <button id="zoomIn">Zoom In</button>
            <button id="zoomOut">Zoom Out</button>
            <button id="resetView" class="reset-button">Reset View</button>
          </div>
        </div>
        <div id="timeline"></div>
        <div class="legend" id="legend"></div>
        <div class="tooltip" id="tooltip"></div>
      `);
 
      lifecycleData.sort((a, b) => new Date(a.dateOf) - new Date(b.dateOf));

      // Constants for SVG dimensions and styling
      const width = 1100;
      const height = 400;
      const margin = { top: 50, right: 50, bottom: 120, left: 50 };
      const innerWidth = width - margin.left - margin.right;
      const innerHeight = height - margin.top - margin.bottom;
      const nodeRadius = 15;
      const lineHeight = 6;

      // Process dates
      const dates = lifecycleData.map(d => new Date(d.dateOf));
      const actualMinDate = new Date(Math.min(...dates));
      const actualMaxDate = new Date(Math.max(...dates));
      
      // Add default buffers
      let currentMinDate = new Date(actualMinDate);
      let currentMaxDate = new Date(actualMaxDate);
      currentMinDate.setMonth(currentMinDate.getMonth() - 3);
      currentMaxDate.setMonth(currentMaxDate.getMonth() + 3);

      // Initialize timeline variables
      let svg, tooltipEl;

      // Format date for display
      function formatDateForDisplay(date) {
          return date.toLocaleDateString('en-US', {
              year: 'numeric',
              month: 'short',
              day: 'numeric'
          });
      }

      // Update date displays
      function updateDateDisplays() {
          document.getElementById('startDateDisplay').textContent = formatDateForDisplay(currentMinDate);
          document.getElementById('endDateDisplay').textContent = formatDateForDisplay(currentMaxDate);
      }

      // Create and draw the timeline
      function drawTimeline() {
          // Clear previous timeline
          const timelineContainer = document.getElementById('timeline');
          timelineContainer.innerHTML = '';
          
          // Create SVG element
          svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
          svg.setAttribute("width", width);
          svg.setAttribute("height", height);
          svg.setAttribute("viewBox", `0 0 ${width} ${height}`);
          svg.setAttribute("style", "max-width: 100%; height: auto;");

          // Create a background for the timeline
          const background = document.createElementNS("http://www.w3.org/2000/svg", "rect");
          background.setAttribute("x", margin.left);
          background.setAttribute("y", margin.top);
          background.setAttribute("width", innerWidth);
          background.setAttribute("height", innerHeight);
          background.setAttribute("fill", "#f9f9f9");
          background.setAttribute("rx", "8");
          svg.appendChild(background);

          // Function to map date to x position
          const getX = (date) => {
              const totalDays = (currentMaxDate - currentMinDate) / (1000 * 60 * 60 * 24);
              const currentDays = (new Date(date) - currentMinDate) / (1000 * 60 * 60 * 24);
              return margin.left + (currentDays / totalDays) * innerWidth;
          }

          // Create timeline line
          const timeline = document.createElementNS("http://www.w3.org/2000/svg", "line");
          timeline.setAttribute("x1", margin.left);
          timeline.setAttribute("y1", margin.top + innerHeight / 2);
          timeline.setAttribute("x2", margin.left + innerWidth);
          timeline.setAttribute("y2", margin.top + innerHeight / 2);
          timeline.setAttribute("stroke", "#ccc");
          timeline.setAttribute("stroke-width", lineHeight);
          timeline.setAttribute("stroke-linecap", "round");
          svg.appendChild(timeline);

          // Get visible items
          const visibleItems = lifecycleData.filter(item => {
              const itemDate = new Date(item.dateOf);
              return itemDate >= currentMinDate && itemDate <= currentMaxDate;
          });

          // Create markers for each visible status
          tooltipEl = document.getElementById('tooltip');
          let lastLabelY = 0;
          let labelYDirection = 1;

          visibleItems.forEach((item, index) => {
              const x = getX(item.dateOf);
              const y = margin.top + innerHeight / 2;
              
              // Create a circle for the milestone
              const circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
              circle.setAttribute("cx", x);
              circle.setAttribute("cy", y);
              circle.setAttribute("r", nodeRadius);
              circle.setAttribute("fill", item.backgroundColour);
              circle.setAttribute("stroke", "#fff");
              circle.setAttribute("stroke-width", "2");
              circle.setAttribute("class", "milestone");
              circle.setAttribute("data-id", item.id);
              svg.appendChild(circle);

              // Create a number inside the circle
              const text = document.createElementNS("http://www.w3.org/2000/svg", "text");
              text.setAttribute("x", x);
              text.setAttribute("y", y + 5);
              text.setAttribute("text-anchor", "middle");
              text.setAttribute("fill", item.colour);
              text.setAttribute("font-size", "14px");
              text.setAttribute("font-weight", "bold");
              text.textContent = item.seq;
              svg.appendChild(text);

              // Create a line connecting the circle to the label
              // Alternate above and below the timeline
              const labelY = y + (labelYDirection * (nodeRadius + 40));
              labelYDirection *= -1;
              lastLabelY = labelY;

              const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
              line.setAttribute("x1", x);
              line.setAttribute("y1", y + (labelY > y ? nodeRadius : -nodeRadius));
              line.setAttribute("x2", x);
              line.setAttribute("y2", labelY - (labelY > y ? 20 : -20));
              line.setAttribute("stroke", item.backgroundColour);
              line.setAttribute("stroke-width", "2");
              line.setAttribute("stroke-dasharray", "3,3");
              svg.appendChild(line);

              // Create a text label for the milestone
              const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
              label.setAttribute("x", x);
              label.setAttribute("y", labelY);
              label.setAttribute("text-anchor", "middle");
              label.setAttribute("fill", "#333");
              label.setAttribute("font-size", "12px");
              label.textContent = item.enumname;
              svg.appendChild(label);

              // Create a smaller date label
              const dateLabel = document.createElementNS("http://www.w3.org/2000/svg", "text");
              dateLabel.setAttribute("x", x);
              dateLabel.setAttribute("y", labelY + (labelY > y ? 20 : -20));
              dateLabel.setAttribute("text-anchor", "middle");
              dateLabel.setAttribute("fill", "#777");
              dateLabel.setAttribute("font-size", "11px");
              dateLabel.textContent = formatDateForDisplay(new Date(item.dateOf));
              svg.appendChild(dateLabel);

              // Add event listeners for tooltip
              circle.addEventListener('mouseover', (e) => {
                  tooltipEl.innerHTML = 
                      `<div style="font-weight: bold; margin-bottom: 5px;">${item.enumname}</div>
                      <div>Date: ${new Date(item.dateOf).toLocaleDateString('en-US', {
                          year: 'numeric',
                          month: 'long',
                          day: 'numeric'
                      })}</div>
                      <div>Sequence: ${item.seq}</div>`
                  ;
                  tooltipEl.style.opacity = '1';
                  tooltipEl.style.left = (e.pageX + 10) + 'px';
                  tooltipEl.style.top = (e.pageY + 10) + 'px';
              });

              circle.addEventListener('mouseout', () => {
                  tooltipEl.style.opacity = '0';
              });

              circle.addEventListener('mousemove', (e) => {
                  tooltipEl.style.left = (e.pageX + 10) + 'px';
                  tooltipEl.style.top = (e.pageY + 10) + 'px';
              });
          });

          // Add subtle grid lines
          const numGridLines = 6;
          for (let i = 0; i <= numGridLines; i++) {
              const x = margin.left + (i * innerWidth / numGridLines);
              const gridLine = document.createElementNS("http://www.w3.org/2000/svg", "line");
              gridLine.setAttribute("x1", x);
              gridLine.setAttribute("y1", margin.top);
              gridLine.setAttribute("x2", x);
              gridLine.setAttribute("y2", margin.top + innerHeight);
              gridLine.setAttribute("stroke", "#ddd");
              gridLine.setAttribute("stroke-width", "1");
              gridLine.setAttribute("stroke-dasharray", "3,3");
              svg.appendChild(gridLine);

              // Add date labels on the grid lines
              const dateOffset = i / numGridLines;
              const date = new Date(currentMinDate.getTime() + dateOffset * (currentMaxDate.getTime() - currentMinDate.getTime()));
              const dateText = document.createElementNS("http://www.w3.org/2000/svg", "text");
              dateText.setAttribute("x", x);
              dateText.setAttribute("y", margin.top + innerHeight + 20);
              dateText.setAttribute("text-anchor", "middle");
              dateText.setAttribute("fill", "#555");
              dateText.setAttribute("font-size", "11px");
              dateText.textContent = date.toLocaleDateString('en-US', {
                  year: 'numeric',
                  month: 'short'
              });
              svg.appendChild(dateText);
          }

          // Add title
          const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
          title.setAttribute("x", width / 2);
          title.setAttribute("y", 25);
          title.setAttribute("text-anchor", "middle");
          title.setAttribute("fill", "#333");
          title.setAttribute("font-size", "18px");
          title.setAttribute("font-weight", "bold");
          title.textContent = "Lifecycle Status Timeline";
          svg.appendChild(title);

          // Add period indicator text
          const periodText = document.createElementNS("http://www.w3.org/2000/svg", "text");
          periodText.setAttribute("x", width / 2);
          periodText.setAttribute("y", height - 20);
          periodText.setAttribute("text-anchor", "middle");
          periodText.setAttribute("fill", "#555");
          periodText.setAttribute("font-size", "12px");
          periodText.textContent = `Viewing period: ${formatDateForDisplay(currentMinDate)} - ${formatDateForDisplay(currentMaxDate)}`;
          svg.appendChild(periodText);

          // Append the SVG to the container
          timelineContainer.appendChild(svg);
      }

      // Create the legend for all items (not just visible ones)
      function createLegend() {
          const legendContainer = document.getElementById('legend');
          legendContainer.innerHTML = '';
          
          lifecycleData.forEach(item => {
              const legendItem = document.createElement('div');
              legendItem.className = 'legend-item';
              
              const colorBox = document.createElement('div');
              colorBox.className = 'legend-color';
              colorBox.style.backgroundColor = item.backgroundColour;
              
              const label = document.createElement('span');
              label.textContent = `${item.seq}. ${item.enumname}`;
              
              legendItem.appendChild(colorBox);
              legendItem.appendChild(label);
              legendContainer.appendChild(legendItem);
          });
      }

      // Date manipulation functions
      function moveStartDate(months) {
          const newDate = new Date(currentMinDate);
          newDate.setMonth(newDate.getMonth() + months);
          
          // Don't allow start date to go beyond end date minus 1 month
          const minEndDate = new Date(currentMaxDate);
          minEndDate.setMonth(minEndDate.getMonth() - 1);
          
          if (newDate < minEndDate) {
              currentMinDate = newDate;
              updateDateDisplays();
              drawTimeline();
          }
      }

      function moveEndDate(months) {
          const newDate = new Date(currentMaxDate);
          newDate.setMonth(newDate.getMonth() + months);
          
          // Don't allow end date to go before start date plus 1 month
          const maxStartDate = new Date(currentMinDate);
          maxStartDate.setMonth(maxStartDate.getMonth() + 1);
          
          if (newDate > maxStartDate) {
              currentMaxDate = newDate;
              updateDateDisplays();
              drawTimeline();
          }
      }

      // Reset to original view with buffer
      function resetView() {
          currentMinDate = new Date(actualMinDate);
          currentMaxDate = new Date(actualMaxDate);
          currentMinDate.setMonth(currentMinDate.getMonth() - 3);
          currentMaxDate.setMonth(currentMaxDate.getMonth() + 3);
          updateDateDisplays();
          drawTimeline();
      }

      // Zoom functions
      function zoomIn() {
          // Zoom in by reducing the range by 25% from both sides
          const currentRange = currentMaxDate - currentMinDate;
          const adjustment = currentRange * 0.125; // 12.5% from each side
          
          const newMinDate = new Date(currentMinDate.getTime() + adjustment);
          const newMaxDate = new Date(currentMaxDate.getTime() - adjustment);
          
          // Ensure there's still a reasonable range
          if (newMaxDate - newMinDate >= 30 * 24 * 60 * 60 * 1000) { // At least 30 days
              currentMinDate = newMinDate;
              currentMaxDate = newMaxDate;
              updateDateDisplays();
              drawTimeline();
          }
      }

      function zoomOut() {
          // Zoom out by increasing the range by 50% from both sides
          const currentRange = currentMaxDate - currentMinDate;
          const adjustment = currentRange * 0.25; // 25% to each side
          
          currentMinDate = new Date(currentMinDate.getTime() - adjustment);
          currentMaxDate = new Date(currentMaxDate.getTime() + adjustment);
          updateDateDisplays();
          drawTimeline();
      }

      // Initialize the visualization
      function initialize() {
          updateDateDisplays();
          drawTimeline();
          createLegend();
          
          // Set up event listeners for controls
          document.getElementById('startDateBack').addEventListener('click', () => moveStartDate(-3));
          document.getElementById('startDateBackSmall').addEventListener('click', () => moveStartDate(-1));
          document.getElementById('startDateForwardSmall').addEventListener('click', () => moveStartDate(1));
          document.getElementById('startDateForward').addEventListener('click', () => moveStartDate(3));
          
          document.getElementById('endDateBack').addEventListener('click', () => moveEndDate(-3));
          document.getElementById('endDateBackSmall').addEventListener('click', () => moveEndDate(-1));
          document.getElementById('endDateForwardSmall').addEventListener('click', () => moveEndDate(1));
          document.getElementById('endDateForward').addEventListener('click', () => moveEndDate(3));
          
          document.getElementById('zoomIn').addEventListener('click', zoomIn);
          document.getElementById('zoomOut').addEventListener('click', zoomOut);
          document.getElementById('resetView').addEventListener('click', resetView);
      }

      // Start the visualization
      initialize();

      // The rest of your original JS can follow here —
      // just replace `document.getElementById(...)` with `$('#...')` where appropriate
      // and set up event handlers using jQuery: e.g., `$('#zoomIn').on('click', ...)`

      // Example:
      // $('#zoomIn').on('click', function () { zoomIn(); });
      // or use jQuery equivalents for manipulating SVG if needed

      // After setup:
      initialize(); // if you wrap the internal logic as an `initialize()` function inside
    }

})