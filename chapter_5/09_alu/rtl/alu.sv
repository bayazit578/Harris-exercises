module alu #(
  parameter ALU_WIDTH = 16
)(
  input  logic [ALU_WIDTH - 1:0] a,
  input  logic [ALU_WIDTH - 1:0] b,
  input  logic [            2:0] func,

  output logic [ALU_WIDTH - 1:0] y
);

  initial assert (func !== 3'b011);
  
  logic [ALU_WIDTH - 1:0] slt_op, sum_op, and_op, or_op;

  logic [ALU_WIDTH - 1:0] b_muxed;

  assign b_muxed = func [2] ? ~b : b;
  assign and_op  = a & b_muxed;
  assign or_op   = a | b_muxed;

  logic c_out;

  prefix_adder u_adder(
    .a    (a       ),
    .b    (b_muxed ),
    .c_in (func [2]),
    .sum  (sum_op  ),
    .c_out(c_out   )
  );

  assign slt_op = {{(ALU_WIDTH - 1){1'b0}}, sum_op [ALU_WIDTH - 1]};

  mux_4 #(
    .WIDTH  (ALU_WIDTH)
  ) u_mux_4 (
    .d0     (and_op    ),
    .d1     (or_op     ),
    .d2     (sum_op    ),
    .d3     (slt_op    ),
    .select (func [1:0]),
    .y      (y         )
  );

endmodule
