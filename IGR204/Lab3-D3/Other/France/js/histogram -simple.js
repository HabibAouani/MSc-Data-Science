// set the dimensions and margins of the graph
margin = {top: 10, right: 30, bottom: 10, left: 50};
const width = 900,
    	height = 400;

const width_hist = width - margin.left - margin.right,
		height_hist = height - margin.top - margin.bottom;


// append the svg object to the body of the page
let svg = d3.select("#histogram-density")
		  .append("svg")
			.attr("width", width )
			.attr("height", height )

// get the data
//
d3.tsv("data/france.tsv")
	.row((d,i)=> {
		return {
			codePostal: +d["Postal Code"],
			inseeCode : +d.inseecode,
			place: d.place,
			longitude: +d.x,
			latitude: +d.y,
			population: +d.population,
			lpopulation: +Math.log(+d.population+1),
			density: +d.density
		};
	})
	.get((error,rows) => {
		console.log("Loaded "+ rows.length + " rows");
        if (rows.length > 0){

        	// axis on x
            var x = d3.scaleLog()
                  .domain(d3.extent(rows , (row)=> row.population + 1 ))
                  .range([0, width_hist]);


			// Histogram
            var histogram = d3.histogram()
                  .value((row) => row.population)
                  .domain(d3.extent(rows, (row)=> row.population))
                  .thresholds(x.ticks(50)); // Numbers of bins

            var bins = histogram(rows);


            // create y axis based on the bins created
            var y = d3.scaleLinear()
                .domain(d3.extent(bins, (bin)=> bin.length))
                .range([height_hist,0]);

            svg.append("g")
                .attr("transform", "translate("+margin.left+","+height_hist+")") // positionner axes X en bas avec marge
                .call(d3.axisBottom(x));

            svg.append("g")
				.attr("transform", "translate("+margin.left+",0)") // Position axes Y avec margin sur le cote
				.call(d3.axisLeft(y));



            svg.selectAll("rect")
              .data(bins)
              .enter()
              .append("rect")
                .attr("x", margin.left + 1)
                .attr("transform", function(d) { return "translate(" + x(d.x0) + "," + y(d.length)+")"; })
                .attr("width", function(d) { return x(d.x1) - x(d.x0) -1 ; })
                .attr("height", function(d) { return height_hist - y(d.length); })
                .style("fill", "#9b59b6 ")
        }

	});
;


