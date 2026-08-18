module pg_cell(
  input  logic i_prg_high, i_gen_high,
               i_prg_low , i_gen_low ,

  output logic o_prg, o_gen
);

  assign o_prg = i_prg_high & i_prg_low;
  assign o_gen = (i_prg_high & i_gen_low) | i_prg_high;

endmodule
