module cla_adder_4(
  input  logic [3:0] a,
  input  logic [3:0] b,
  input  logic       c_in,

  output logic [3:0] sum,
  output logic       c_out
);

  ripple_carry_adder #(
    .TERM_WIDTH (4)
  ) u_ripple_carry_adder(
    .a    (a   ),
    .b    (b   ),
    .c_in (c_in),
    .sum  (sum )
  );

  logic [3:0] prg, gen;

  assign prg = a | b;
  assign gen = a * b;

  cla_cell #(
    .TERM_WIDTH (4)
  ) u_cla_cell(
    .i_prg (prg  ),
    .i_gen (gen  ),
    .c_in  (c_in ),
    .c_out (c_out)
  );

endmodule
