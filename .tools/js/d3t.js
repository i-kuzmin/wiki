var d3t = {
  horisontalBarChart: function( name, opt)
  {
    var width = ( opt.width == null ) ? 500 : opt.width;
    if ( opt.data != null) {
        var x = d3.scale.linear()
            .domain([0, d3.max(opt.data)])
            .range([0, width]);

        d3.select("div.chart#" + name)
          .selectAll("div")
            .data(opt.data)
          .enter().append("div")
            .style("width", function(d) { return x(d) + "px"; })
            .text(function(d) { return d; });

    } else if ( opt.dataFile != null) {
      d3.csv( opt.dataFile, type, function(error, data) {
        var x = d3.scale.linear()
                .domain([0, d3.max(data, function(d) { return d.value; })])
                .range([0, width]);
        d3.select("div.chart#" + name)
          .selectAll("div")
            .data(data)
          .enter().append("div")
            .style("width", function(d) { return x(d.value) + "px"; })
            .text(function(d) { return d.name + " (" + d.value + ")"; })
      });

      function type(d) {
        d.value = +d.value; // coerce to number
        return d;
      }
    } else throw "Input Data is not defined";
  },

  verticalBarChart: function(id, opt)
  {
    tWidth  = (opt.width  == null) ? 920 : opt.width;
    tHeight = (opt.height == null) ? 500 : opt.height;

    var margin = {top: 20, right: 30, bottom: 30, left: 40},
        width = tWidth - margin.left - margin.right,
        height = tHeight - margin.top - margin.bottom;

    var x = d3.scale.ordinal()
        .rangeRoundBands([0, width], .1);

    var y = d3.scale.linear()
        .range([height, 0]);

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left");

    var chart = d3.select("svg.chart#" + id)
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    if (opt.dataFile != null) {
          d3.csv(opt.dataFile, type, function(error, data) {
              x.domain(data.map(function(d) { return d.name; }));
              y.domain([0, d3.max(data, function(d) { return d.value; })]);

          chart.append("g")
              .attr("class", "x axis")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

          chart.append("g")
              .attr("class", "y axis")
              .call(yAxis);

          chart.selectAll(".bar")
              .data(data)
            .enter().append("rect")
              .attr("class", "bar")
              .attr("x", function(d) { return x(d.name); })
              .attr("y", function(d) { return y(d.value); })
              .attr("height", function(d) { return height - y(d.value); })
              .attr("width", x.rangeBand());
        });

        function type(d) {
          d.value = +d.value; // coerce to number
          return d;
        }
    }
  }
};
