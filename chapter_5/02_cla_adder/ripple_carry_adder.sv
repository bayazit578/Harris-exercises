module ripple_carry_adder #(
  parameter TERM_WIDTH = 4
)(
  input  logic [TERM_WIDTH-1:0] a,
  input  logic [TERM_WIDTH-1:0] b,
  input  logic                  c_in,

  output logic [TERM_WIDTH-1:0] sum,
  output logic                  c_out
);

  logic [TERM_WIDTH:0] carry_chain;

  assign carry_chain [0] = c_in;

  generate
    for (genvar i = 0; i < TERM_WIDTH; i += 1) begin: g_full_adder
      full_adder u_full_adder(
        .a     (a           [i  ]),
        .b     (b           [i  ]),
        .c_in  (carry_chain [i  ]),
        .sum   (sum         [i  ]),
        .c_out (carry_chain [i+1])
      );
    end
  endgenerate

  assign c_out = carry_chain [TERM_WIDTH];

endmodule : ripple_carry_adder
