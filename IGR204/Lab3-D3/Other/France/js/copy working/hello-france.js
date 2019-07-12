var margin = {top: 10, right: 30, bottom: 30, left: 30};
var padding = {x:30 , y:30};
const w_panel = 900;
const h_panel = 650;
const w = 600;
const h =  600 ;
const r = 30;
const w_legend = 50;
const h_legend = 200;

let dataset = [];

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
var svg_main = d3.select("#france-map")
			.append("svg")
				.attr("width", w_panel)
				.attr("height", h_panel);

// SVG Panel for the frenc map
var svg = svg_main.append("g")
                .attr("class", "french-map")
                .attr("id",'french-map')

// SVG Panel for the french-map legend
var svg_legend  = svg_main.append("g")
                            .attr("class", "map-legend")
                            .attr("id","map-legend")
                            .attr("width", 120)
                            .attr("height", 500)
                            .attr("transform", "translate("+(w+50)+",100)")

// SVG Panel for the population

// focus panel for tooltip
let div_tooltip = d3.select("body")
					.append("div")
						.attr("class","tooltip")
						.attr("color","grey")
						.attr("fill-opacity","0")



svg_legend.append("text")
	.attr("text-align", "center")
	.attr("fill","white")
	.text("Legend")
// define a SVG gradient element
var myColor = d3.scaleLinear().domain([0,0.2,0.5,1])
  .range(["#1a5276","#2980b9","#a569bd", "#d2b4de"])




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

                // filter the city with population == 0 (Lack of data)
                let frows = rows.filter((row) => (row.population != 0 ))

                var x = d3.scaleLinear()
                    .domain(d3.extent(frows, (row)=> row.longitude))
                    .range([0,h]);

                var y = d3.scaleLinear()
                    .domain(d3.extent(frows, (row)=> row.latitude))
                    .range([h,0]);
                var pop =  d3.scalePow()
                    .exponent(0.4)
                    .domain(d3.extent(frows, (row)=> row.population))
                    .range([1,r]);
                var den = d3.scaleLog()
                    .domain(d3.extent(frows, (row)=> 1+row.density))
                    .range([0,1]);

                dataset = frows;

                // Draw axis x and y

                svg.append("g")
                        .attr("class","x-axis")
                            .attr("transform", "translate("+padding.x+", 0)")
                            .call(d3.axisBottom(x));

                svg.append("g")
                        .attr("class","y-axis")
                            .attr("transform", "translate(0, "+padding.y+")")
                            .call(d3.axisRight(y));

                // Legend axis

                y_legend = d3.scaleLog()
                               .domain(d3.extent(frows, (row)=> 1+row.density))
                                .range([0,h_legend]);

                colorAxis = d3.axisRight(y_legend)
                                .ticks(5)
                                .tickValues([1,10,100,1000,10000])
                                .tickFormat((d,i)=>{return d + " Hab / km2" });

                draw();
                draw_legend_color();
                draw_legend_bubble();
		}
	});



///////////////////// functions utilities ////////////////////////////////////////////

function draw() {
	svg.selectAll("circle")
		.data(dataset)
		.enter()
		.append("circle")
		.on("mouseover", handleMouseOver)
		.on("mouseout", handleMouseOut)
			.attr("r",(d) => pop(d.population))
			.attr("cx", (d) => x(d.longitude))
			.attr("cy", (d) => y(d.latitude))
			.attr("fill", (d)=> myColor(den(d.density)))
			.attr("fill-opacity", (d)=>den(d.density))
			.attr("transform","translate("+margin.left+","+margin.top+")")
			.attr("stroke","none");

}

function draw_legend_color(){

	w_rect = 25;
	padding_rect = 20;

    svg_colormap = svg_legend.append("defs")
                             .append("linearGradient")
                                    .attr("id","legend-color")
                                    .attr("x1","0%")
                                    .attr("y1","0%")
                                    .attr("x2","0%")
                                    .attr("y2","100%");

    svg_legend.append("g")
                    .attr("class","color-axis")
                    .attr("transform", "translate("+w_rect+", "+padding_rect+")")
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
		.attr("transform","translate(0,"+padding_rect+	")")
        .attr("x",0)
        .attr("y",0)
        .attr("height",h_legend)
        .attr("width",w_rect);


}

function draw_legend_bubble(){

	// draw circles
	svg_legend.
		selectAll("legend")
		.data(bubble_legend_values)
		.enter()
		.append("circle")
			.attr("cx", 20)
			.attr("cy", (d) => 350-pop(d.value))
			.attr("r", (d)=> pop(d.value))
		.attr("fill","none")
		.attr("stroke","#a569bd");

	// draw dashed lines
	svg_legend
	  .selectAll("legend")
	  .data(bubble_legend_values)
	  .enter()
	  .append("line")
		.attr('x1', 20)
		.attr('x2', (d) => 50 + pop(d.value))
		.attr('y1', (d) => 350 -pop(d.value)*2 )
		.attr('y2', (d) => 350 -pop(d.value)*2 )
		.attr('stroke', 'white')
		.style('stroke-dasharray', ('2,2'));

	// draw legend text
	svg_legend
	  .selectAll("legend")
	  .data(bubble_legend_values)
	  .enter()
	  .append("text")
		.attr("x", (d) => 50 + pop(d.value))
		.attr("y", (d)=> 350 -pop(d.value)*2 )
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