module mux_4 #(
  parameter WIDTH = 32
)(
  input  logic [WIDTH - 1:0] d0, d1, d2, d3,
  input  logic [        1:0] select,
  output logic [WIDTH - 1:0] y
)

  logic [WIDTH - 1:0] low, high;

  always_comb begin
    low  = select [0] ? d0  : d1  ;
    high = select [0] ? d2  : d3  ;
    y    = select [1] ? low : high;
  end

endmodule
