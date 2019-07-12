// append the svg object to the body of the page
var svg_histo = d3.select("#histogram-population")
				  .append("svg")
					.attr("width", w_hist )
					.attr("height", h_hist );

yScale_hist = d3.scaleLog()
				  .domain(d3.extent(dataset , (row)=> row.population))     // can use this instead of 1000 to have the max of data: d3.max(data, function(d) { return +d.price })
				  .range([0, (h_hist- margin.top - margin.bottom)]);


var histogram = d3.histogram()
	  .value((row) => row.population)   // I need to give the vector of value
	  .domain(d3.extent(dataset, (row)=> row.population))  // then the domain of the graphic
	  .thresholds(yScale_hist.ticks(50)); // then the numbers of bin

var bins = histogram(dataset);

console.log(dataset)

draw_hist_pop_axis();


//////////////////////////// function utilities //////////////////////////////:

function draw_hist_pop_axis(){

	let popAxis = d3.axisLeft(yScale_hist)
				.tickFormat(function(d){
					if ((""+d)[0] == "1" ){ return d3.format(".1s")(d) + " hab"}
				} ); // Define custom ticks format which send label only for value starting with 1

	svg_histo.append("g")
                .attr("transform", "translate("+ margin.left+","+margin.top+")")
                .call(popAxis);
}


//
// d3.tsv("data/france.tsv")
// 	.row((d,i)=> {
// 		return {
// 			codePostal: +d["Postal Code"],
// 			inseeCode : +d.inseecode,
// 			place: d.place,
// 			longitude: +d.x,
// 			latitude: +d.y,
// 			population: +d.population,
// 			lpopulation: +Math.log(+d.population+1),
// 			density: +d.density
// 		};
// 	})
// 	.get((error,rows) => {
// 		console.log("Loaded "+ rows.length + " rows");
//         if (rows.length > 0){
//
//             let frows = rows.filter((row) => (row.population != 0 ));
// //            console.log( frows)
//             let x = d3.scaleLog()
//                   .domain(d3.extent(frows , (row)=> row.population))     // can use this instead of 1000 to have the max of data: d3.max(data, function(d) { return +d.price })
//                   .range([0, (width_histogram)]);
//
//
//
//
//
//             var y = d3.scaleLinear()
//                 .domain(d3.extent(bins, (bin)=> bin.length))
//                 .range([0,(height_histogram) ]);
//
//
// 			popAxis = d3.axisTop(x)
// 				.tickFormat(function(d){
// 					if ((""+d)[0] == "1" ){ return d3.format(".1s")(d) + " hab"}
// 				} );
//
//
//             svg_histo.append("g")
//                 .attr("transform", "translate("+margin.left+",0)")
//                 .call(popAxis);
//
//             svg_histo.append("g")
// 				.attr("transform", "translate("+margin.left+",0)")
// 				.call(d3.axisLeft(y));
//
//
//
//             svg_histo.selectAll("rect")
//               .data(bins)
//               .enter()
//               .append("rect")
//                 .attr("x", margin.left)
//                 .attr("transform", function(d) { return "translate(" + x(d.x0) + ",1)"; })
//                 .attr("width", function(d) { return x(d.x1) - x(d.x0) -1 ; })
//                 .attr("height", function(d) { return y(d.length); })
//                 .style("fill", "#9b59b6 ")
//         }
//
// 	});
// ;
//
//
