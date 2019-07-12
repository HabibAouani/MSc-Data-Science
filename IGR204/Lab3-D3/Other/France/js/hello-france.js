// margin in panels
var margin = {top: 30, right: 80, bottom: 30, left: 80};
var padding_map  = {x: 40, y : 40} // Padding of the axis to not cross the axis

// Panel size
const w_main = 700; // Width and heigth of freance map panel (including legend)
const h_main = 600;
const w_map = 600; // Width and height of france map only
const h_map =  600 ;
const r_max = 30; // map r circle for draw in map
const w_legend = 150; // width and height of legend for france map
const h_legend = 600;
const w_hist = 500; // width and height of histogram panel
const h_hist = 600;


// Data for legend size
let bubble_legend_values = [
	{
		value : 10000,
		label : "10k hab"
	},
	{
		value : 100000,
		label : "100k hab"
	},
	{
		value : 500000,
		label : "500k hab"
	},
	{
		value : 1000000,
		label : "1M hab"
	},
	{
		value : 2000000,
		label : "2M hab"
	}
];

// Main SVG Panel
var svg_map = d3.select("#france-map")
				.append("svg")
					.attr("width", w_map)
					.attr("height", h_map)
					.attr("class", "french-map")
                	.attr("id",'french-map');

// SVG Panel for the french-map legend
var svg_legend  = d3.select("#france-map")
					.append("svg")
					.attr("class", "map-legend")
					.attr("id","map-legend")
					.attr("width", w_legend)
					.attr("height", h_legend)
					.attr("transform", "translate(0,0)")

// SVG Panel for the population histogram
var svg_histo_pop = d3.select("#histogram-population")
				  .append("svg")
					.attr("width", w_hist )
					.attr("height", h_hist );

var svg_histo_den = d3.select("#histogram-density")
				  .append("svg")
					.attr("width", w_hist )
					.attr("height", h_hist );


// HTML Tag for tooltip
var div_tooltip = d3.select("body")
	.append("div")
						.attr("class","tooltip")
						.attr("color","grey")
						.attr("fill-opacity","0")



// define a SVG gradient element (CAREFUL if change , need to change the draw_legend_color accordingly)
var myColor = d3.scaleLinear().domain([0,0.2,0.5,1])
  .range(["#1a5276","#2980b9","#a569bd", "#d2b4de"])


// Data load
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

		if (rows.length > 0){ // Data loaded succesfully

                // filter the city with population == 0 and city with no latitude  (Lack of data ,compromised for visualization)
                let frows = rows.filter((row) => (row.population != 0 && !isNaN(row.longitude) && !isNaN(row.latitude) ));

                dataset = frows;

                frows.forEach(function(d){
                	if(d.longitude == 7143){console.log(d)}
                })

                console.log(d3.extent(dataset, (row)=> row.longitude))
				//////////// For france map
                draw_map_axis();
                draw_map();
                draw_legend_color();
                draw_legend_bubble();

                //////////// for Histogram population

				yScale_histPop = d3.scaleLog()
				  .domain(d3.extent(dataset , (row)=> row.population+1))
				  .range([0, (h_hist- margin.top - margin.bottom)]);

				var histogram_pop = d3.histogram()
						.value((row) => row.population)   // I need to give the vector of value
						.domain(d3.extent(dataset, (row)=> row.population+1))  // then the domain of the graphic
						.thresholds(yScale_histPop.ticks(50)); // then the numbers of bin

				bins_pop = histogram_pop(dataset);

				xScale_histPop = d3.scaleLinear()
						.domain(d3.extent(bins_pop, (bin)=> bin.length))
						.range([0,(w_hist - margin.left - margin.right) ]);

				draw_hist_pop_axis();
				draw_hist_pop();


				//////////////// for Histogram density

				yScale_histDen = d3.scaleLog()
				  .domain(d3.extent(dataset , (row)=> row.density+1))
				  .range([0, (h_hist- margin.top - margin.bottom)]);

				var histogram_den = d3.histogram()
						.value((row) => row.density)   // I need to give the vector of value
						.domain(d3.extent(dataset, (row)=> row.density+1))  // then the domain of the graphic
						.thresholds(yScale_histDen.ticks(50)); // then the numbers of bin

				bins_den = histogram_den(dataset);

				xScale_histDen = d3.scaleLinear()
						.domain(d3.extent(bins_den, (bin)=> bin.length))
						.range([(w_hist - margin.left - margin.right),0]);

				draw_hist_den_axis();
				draw_hist_den();

		}
	});



///////////////////// functions utilities FRANCE MAP ////////////////////////////////////////////

function draw_map_axis(){

	// XScale and YScale for french map
	
	xScale_map = d3.scaleLinear()
					.domain(d3.extent(dataset, (row)=> row.longitude))
					.range([0,w_map - margin.left - margin.right - padding_map.x]); // Scale for X axis in france map
	
	yScale_map = d3.scaleLinear()
					.domain(d3.extent(dataset, (row)=> row.latitude))
					.range([h_map - margin.top - margin.bottom - padding_map.y,0]); // Scale for Y Axis in france map

	svg_map.append('g')
				.attr("class","x-axis")
				.attr("transform", "translate("+ (margin.left + padding_map.x) +", "+margin.top+")")
				.call(d3.axisTop(xScale_map)) // xScale Map axis
			.append('text')
				.attr("class","axis-legend")
				.attr("transform","translate("+(w_map - margin.left - margin.right - padding_map.x)+",15)")
				.style("text-anchor","end")
				.text("Longitude (in °)"); // axis legend

	svg_map.append('g')
				.attr("class","y-axis")
				.attr("transform", "translate("+margin.left+", "+ (margin.top + padding_map.y) +")")
				.call(d3.axisLeft(yScale_map)) // yScale Map axis
			.append('text')
				.attr("class","axis-legend")
				.attr("transform","translate(15, 0) rotate(-90)")
				.style("text-anchor","end")
				.text("Latitude (in °)"); // axis legend
} // Define and draw the france map axis

function draw_map() {

	popScale =  d3.scalePow()
						.exponent(0.4)
						.domain(d3.extent(dataset, (row)=> row.population))
						.range([1,r_max]); // Scale circle size based on population and power law distribution

	denScale = d3.scaleLog()
					.domain(d3.extent(dataset, (row)=> 1+row.density)) // +1 therefore if density close to 0, Log value goes top 0 as well
					.range([0,1]); // Scale gradient color based on log density

	svg_map.selectAll("circle")
				.data(dataset)
				.enter()
				.append("circle")
				.on("mouseover", handleMouseOver)
				.on("mouseout", handleMouseOut)
					.attr("r",(d) => popScale(d.population))
					.attr("cx", (d) => xScale_map(d.longitude))
					.attr("cy", (d) => yScale_map(d.latitude))
					.attr("fill", (d)=> myColor(denScale(d.density)))
					.attr("fill-opacity", (d)=>denScale(d.density))
					.attr("transform","translate(" + (margin.left + padding_map.x) + ","+ (margin.top + padding_map.y) +")")
					.attr("stroke","none");

}

function draw_legend_color(){

	let w_rect = 25; // width of the rectangle for color gradient legend
	h_rect = 200; // width of the rectand for color gradient legend


	// Legend axis

	y_ColorlegScale = d3.scaleLog()
							.domain(d3.extent(dataset, (row)=> 1+row.density))
							.range([0,h_rect]);

	colorAxis = d3.axisRight(y_ColorlegScale)
							.ticks(5)
							.tickValues([1,10,100,1000,10000,20000])
							.tickFormat((d,i)=>{return d3.format(".0s")(d) + " Hab / km2" });

    svg_colormap = svg_legend.append("defs")
                             .append("linearGradient")
                                    .attr("id","legend-color")
                                    .attr("x1","0%")
                                    .attr("y1","0%")
                                    .attr("x2","0%")
                                    .attr("y2","100%");

    svg_legend.append("g")
				.attr("class","color-axis")
				.attr("transform", "translate("+w_rect+", "+(padding_map.y*2 + 50)+")")
				.call(colorAxis);

    svg_colormap.append("stop")
                    .attr("offset", "0%" )
                    .attr("stop-color", "#1a5276")
                    .attr("stop-opacity", 0);

    svg_colormap.append("stop")
                    .attr("offset", "20%" )
                    .attr("stop-color", "#2980b9")
                    .attr("stop-opacity", 0.2);

    svg_colormap.append("stop")
                    .attr("offset", "50%" )
                    .attr("stop-color", "#a569bd")
                    .attr("stop-opacity",0.5);

    svg_colormap.append("stop")
                    .attr("offset", "100%" )
                    .attr("stop-color", "#d2b4de")
                    .attr("stop-opacity",1);


    svg_legend.append("rect")
        .attr("fill", "url(#legend-color)")
		.attr("transform","translate(0,"+(padding_map.y*2 + 50)+")")
        .attr("x",0)
        .attr("y",0)
        .attr("height",h_rect)
        .attr("width",w_rect);


}

function draw_legend_bubble(){

	let y_padding = (padding_map.y*2 + 50)+ h_rect + 100

	// draw circles
	svg_legend.
		selectAll("legend")
		.data(bubble_legend_values)
		.enter()
		.append("circle")
			.attr("cx", padding_map.x)
			.attr("cy", (d) => y_padding-popScale(d.value))
			.attr("r", (d)=> popScale(d.value))
		.attr("fill","none")
		.attr("stroke","#a569bd");

	// draw dashed lines
	svg_legend
	  .selectAll("legend")
	  .data(bubble_legend_values)
	  .enter()
	  .append("line")
		.attr('x1', padding_map.x)
		.attr('x2', (d) => padding_map.x + 15 + popScale(d.value))
		.attr('y1', (d) => y_padding -popScale(d.value)*2 )
		.attr('y2', (d) => y_padding -popScale(d.value)*2 )
		.attr('stroke', 'white')
		.style('stroke-dasharray', ('2,2'));

	// draw legend text
	svg_legend
	  .selectAll("legend")
	  .data(bubble_legend_values)
	  .enter()
	  .append("text")
		.attr("x", (d) => padding_map.x + 15 +  popScale(d.value))
		.attr("y", (d)=> y_padding - popScale(d.value)*2 )
		.text((d)=> d.label)
		.attr("fill","white")
		.attr("font-size","10px")
		.attr("stroke","white");

}

function handleMouseOver(d, i) {

		div_tooltip.transition()
				.duration(800)
				.style("opacity", .9);

            div_tooltip.html("<b>Place : </b>" + d.place + "<br>"
                    + "<b>Postal code : </b>" + d.codePostal + "<br>"
                    + "<b>Population : </b>" + d.population + "<br>"
                    + "<b>Density : </b>" + d.density + "<br>")
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY) + "px");


}

function handleMouseOut(d, i) {

	div_tooltip.transition()
			   .duration(2000)
				.style("opacity","0");

}

///////////////////// functions utilities Population Histogram ////////////////////////////////////////////

function draw_hist_pop_axis(){


	let popAxis = d3.axisLeft(yScale_histPop)
				.tickFormat(function(d){
					if ((""+d)[0] == "1" ){ return d3.format(".1s")(d) + " hab"}
				} ); // Define custom ticks format which send label only for value starting with 1


	svg_histo_pop.append("g")
                .attr("transform", "translate("+ margin.left+","+margin.top+")")
                .call(popAxis)
				.append('text')
				.attr("class","axis-legend")
				.attr("transform","translate(15, "+(w_hist+margin.top)+") rotate(90)")
				.style("text-anchor","end")
				.text("Population"); // axis legend for  yScale

	svg_histo_pop.append("g")
				.attr("transform", "translate("+ margin.left+","+margin.top+")")
				.call(d3.axisTop(xScale_histPop).tickFormat(d3.format(".2s")))
			.append('text')
				.attr("class","axis-legend")
				.attr("transform","translate("+(w_hist - margin.left - margin.right )+",15)")
				.style("text-anchor","end")
				.text("Count(pop)"); // axis legend for Xscale
}

function draw_hist_pop(){
	svg_histo_pop.selectAll("rect")
		  .data(bins_pop)
		  .enter()
		  .append("rect")
			.attr("x", margin.left + 2)
			.attr("y", margin.top + 2)
			.attr("transform", function(bin) { return "translate(0,"+ yScale_histPop(bin.x0) +")"; })
			.attr("width", function(bin) { return xScale_histPop(bin.length) ; })
			.attr("height", function(bin) { return yScale_histPop(bin.x1) - yScale_histPop(bin.x0) -1 ; })
			.style("fill", "#9b59b6 ")
}

///////////////////// functions utilities density Histogram ////////////////////////////////////////////

function draw_hist_den_axis(){


	let denAxis = d3.axisRight(yScale_histDen)
				.tickFormat(function(d){
					if ((""+d)[0] == "1" ){ return d3.format(".1s")(d) + " hab/km2"}
				} ); // Define custom ticks format which send label only for value starting with 1
	console.log(xScale_histDen(500))
	console.log(xScale_histDen(6000))


	svg_histo_den.append("g")
                .attr("transform", "translate("+ (w_hist - margin.right)+","+margin.top+")")
                .call(denAxis)
				.append('text')
				.attr("class","axis-legend")
				.attr("transform","translate(-15, "+ w_hist +") rotate(-90)")
				.style("text-anchor","end")
				.text("Density"); // axis legend for  yScale

	svg_histo_den.append("g")
				.attr("transform", "translate("+ margin.left+","+margin.top+")")
				.call(d3.axisTop(xScale_histDen).tickFormat(d3.format(".2s")))
			.append('text')
				.attr("class","axis-legend")
				.attr("transform","translate(0,15)")
				.style("text-anchor","start")
				.text("Count(den)"); // axis legend for Xscale

	xScale_histDen.range([0,(w_hist - margin.left - margin.right)]); // reverse range order for plot of rectangle 

}

function draw_hist_den(){
	svg_histo_den.selectAll("rect")
		  .data(bins_den)
		  .enter()
		  .append("rect")
			.attr("x", w_hist - margin.right - 2 )
			.attr("y", margin.top +2 )
			.attr("transform", function(bin) { return "translate("+(-xScale_histDen(bin.length))+","+ yScale_histDen(bin.x0) +")"; })
			.attr("width", function(bin) { return xScale_histDen(bin.length) ; })
			.attr("height", function(bin) { return yScale_histDen(bin.x1) - yScale_histDen(bin.x0) -1 ; })
			.style("fill", "#9b59b6 ");
}