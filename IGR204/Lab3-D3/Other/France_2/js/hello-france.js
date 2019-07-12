// Global const
var margin = {top: 30, right: 30, bottom: 30, left: 30}
const w = 600 - margin.left - margin.right;
const h = 600 - margin.top - margin.bottom;

let dataset = [];

// Create SVG element for map and histogram
let svg_map = d3.select("#map")
                .append("svg")
                  .attr("width", w + margin.left + margin.right)
                  .attr("height", h + margin.top + margin.bottom);

let svg_hist_pop = d3.select("#hist_population")
                .append("svg")
                  .attr("width", w + margin.left + margin.right)
                  .attr("height", h/2 + margin.top + margin.bottom)
                .append("g")
                  .attr("transform","translate(" + 1.3 * margin.left + "," + margin.top + ")")


let svg_hist_dens = d3.select("#hist_density")
                .append("svg")
                  .attr("width", w + margin.left + margin.right)
                  .attr("height", h/2 + margin.top + margin.bottom)
                .append("g")
                  .attr("transform","translate(" + 1.3 * margin.left + "," + margin.top + ")")

// Color scale for density
var myColor = d3.scaleSequential().domain([0,5000]).interpolator(d3.interpolateBrBG)

// Add tool tip for map
var tip = d3.tip()
  .attr('class', 'd3-tip')
  .offset([-15, 0])
  .html(function(d) {
    return "City: <span style='color:red'>" + d.place
    + "</span><br> Postal Code: <span style='color:red'>" + d.postalCode
    + "</span><br> Population: <span style='color:green'>" + d3.format(",d")(d.population)
    + "</span><br> Density: <span style='color:green'>" + d3.format(",d")(d.density) + "</span>";
  })
svg_map.call(tip);


// Draw function for map
function draw_map() {

  // Create map
  svg_map.selectAll("circle")
    .data(dataset)
    .enter()
    .append("circle")
      .attr("cx", (d) => x(d.longitude))
      .attr("cy", (d) => y(d.latitude))
      .attr("r", (d) => Math.min(Math.sqrt(+d.population * 0.001), 30))
      .style("fill", (d) => myColor(+d.density))
      .style("opacity", 0.7)
      .on('mouseover', tip.show)
      .on('mouseout', tip.hide)

  // X axis
   svg_map.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0, "+ w + ")")
        .call(d3.axisTop(x))
          .selectAll("text")
            .attr("transform", "translate(-25,30)")
            .style("text-anchor", "end")

  // X axis legend
  svg_map.append("text")
    .attr("text-anchor", "middle")
    .attr("transform", "translate(600," + (h / 2) + ")rotate(-90)")
    .attr("font-size", "20px")
    .text("latitude");

  // Y axis
  svg_map.append("g")
       .attr("class", "y axis")
       .attr("transform", "translate(" + h +", 0)")
       .call(d3.axisRight(y))
         .selectAll("text")
           .attr("transform", "translate(+30,-30)")
           .style("text-anchor", "end")

  // Y axis legend
  svg_map.append("text")
      .attr("text-anchor", "middle")
      .attr("transform", "translate(" + (w / 2) + ",580)")
      .attr("font-size", "20px")
      .text("longitude");
};


// Draw function for density histogram
function draw_hist_density() {

  // X axis
  var x_hist = d3.scaleLinear()
      .domain([0, d3.max(dataset, function(d) { return d.density; })])
      .range([0, w]);

  // X axis legend
  svg_hist_dens.append("g")
      .attr("transform", "translate(0," + h/2 + ")")
      .call(d3.axisBottom(x_hist));

  // Create histogram
  var histogram = d3.histogram()
       .value((d) => d.density)
       .domain(x_hist.domain())
       .thresholds(x_hist.ticks(100))

  // Create bins
  var bins = histogram(dataset)

  // Y axis
  var y_hist = d3.scaleLinear()
                  .range([h/2, 0])
                  .domain([0, d3.max(bins, (d) => d.length)])

  // Y axis legend
  svg_hist_dens.append("g")
     .attr("class", "y axis")
     .call(d3.axisLeft(y_hist));

  // Plot histogram
  svg_hist_dens.selectAll("rect")
    .data(bins)
    .enter()
    .append("rect")
      .attr("x", 1)
      .attr("transform", function(d) { return "translate(" + x_hist(d.x0) + "," + y_hist(d.length) + ")"; })
      .attr("width", function(d) { return x_hist(d.x1) - x_hist(d.x0); })
      .attr("height", function(d) { return h/2 - y_hist(d.length); })
      .style("fill", "#69b3a2")
};

// Draw function for population histogram
function draw_hist_population() {

  // X Axis
  var x_hist = d3.scaleLinear()
      .domain([0, d3.max(dataset, function(d) { return d.population; })])
      .range([0, w]);

  // X axis legend
  svg_hist_pop.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + h/2 + ")")
      .call(d3.axisBottom(x_hist));

  // Create histogram
  var histogram = d3.histogram()
       .value((d) => d.population)
       .domain(x_hist.domain())
       .thresholds(x_hist.ticks(100))

 // Create bins
  var bins = histogram(dataset)

  // Y axis
  var y_hist = d3.scaleLinear()
                  .range([h/2, 0])
                  .domain([0, d3.max(bins, (d) => d.length)])

  // Y axis legend
  svg_hist_pop.append("g")
     .attr("class", "y axis")
     .call(d3.axisLeft(y_hist));

   // Plot histogram
   svg_hist_pop.selectAll("rect")
    .data(bins)
    .enter()
    .append("rect")
      .attr("x", 1)
      .attr("transform", function(d) { return "translate(" + x_hist(d.x0) + "," + y_hist(d.length) + ")"; })
      .attr("width", function(d) { return x_hist(d.x1) - x_hist(d.x0); })
      .attr("height", function(d) { return h/2 - y_hist(d.length); })
      .style("fill", "#69b3a2")
};


// Load and cast data
d3.tsv("data/france.tsv")
  .row( (d, i) => {
    return {
      postalCode: +d["Postal Code"],
      inseeCode: +d.inseecode,
      place: d.place,
      longitude: +d.x,
      latitude: +d.y,
      population: +d.population,
      density: +d.density
    };
  }
)
  .get( (error, rows) => {
    console.log("Loaded " + rows.length + " rows");
    if (rows.length > 0){
       console.log("First row: ", rows[0])
       console.log("Last row " , rows[rows.length - 1])
    }
    dataset = rows;
    x = d3.scaleLinear()
      .domain(d3.extent( rows, (row) => row.longitude))
      .range([0, w]);

    y = d3.scaleLinear()
      .domain(d3.extent( rows, (row) => row.latitude))
      .range([h, 0]);
    draw_map();
    draw_hist_density();
    draw_hist_population();
  }
);
