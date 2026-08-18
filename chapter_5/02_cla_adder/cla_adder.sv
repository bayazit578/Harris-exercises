module cla_adder #(
  parameter TERM_WIDTH = 64
)(
  input  logic [TERM_WIDTH-1:0] a,
  input  logic [TERM_WIDTH-1:0] b,
  input  logic                  c_in,

  output logic [TERM_WIDTH-1:0] sum,
  output logic                  c_out
);

  initial assert (TERM_WIDTH / 4 == 0);

  localparam BLOCK_CNT  = TERM_WIDTH / 4;

  logic [BLOCK_CNT:0] carry_chain;

  assign carry_chain [0] = c_in;

  generate
    for (genvar i = 0; i < BLOCK_CNT; i += 1) begin: g_adder_blocks
      cla_adder_4 u_cla_adder_4(
        .a     (a           [i*4+:4]),
        .b     (b           [i*4+:4]),
        .c_in  (carry_chain [i     ]),
        .sum   (sum         [i*4+:4]),
        .c_out (carry_chain [i+1   ])
      );
    end
  endgenerate

  assign c_out = carry_chain [BLOCK_CNT];

endmodule : cla_adder
