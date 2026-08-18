module prefix_adder(
  input  logic [15:0] a,
  input  logic [15:0] b,
  input  logic        c_in,

  output logic [15:0] sum,
  output logic        c_out
);

  localparam TERM_WIDTH = 16;

  logic [TERM_WIDTH-1:0] prg, gen;

  always_comb begin
    prg [0] = 0   ;
    gen [0] = c_in;

    prg [TERM_WIDTH-1:1] = a [TERM_WIDTH-2:0] | b [TERM_WIDTH-2:0];
    gen [TERM_WIDTH-1:1] = a [TERM_WIDTH-2:0] & b [TERM_WIDTH-2:0];
  end

  logic [TERM_WIDTH-1:0] prg_layer_0, gen_layer_0;

  generate
    for (genvar i = 0; i < TERM_WIDTH; i += 2) begin: g_pg_layer_0
      pg_cell u_pg_cell (
        .i_prg_high (prg [i+1]),
        .i_gen_high (gen [i+1]),
        .i_prg_low  (prg [i  ]),
        .i_gen_low  (gen [i  ]),
        .o_gen      (prg_layer_0 [i+1]),
        .o_prg      (gen_layer_0 [i+1])
      );

      assign prg_layer_0 [i] = prg [i];
      assign gen_layer_0 [i] = gen [i];
    end
  endgenerate

  logic [TERM_WIDTH-1:0] prg_layer_1, gen_layer_1;

  generate
    for (genvar i = 1; i < TERM_WIDTH; i += 4) begin: g_pg_layer_1
      for (genvar j = 1; j <= 2; j += 1) begin: g_pg_combine_1
        pg_cell u_pg_cell(
          .i_prg_high (prg_layer_0 [i+j]),
          .i_gen_high (gen_layer_0 [i+j]),
          .i_prg_low  (prg_layer_0 [i  ]),
          .i_gen_low  (gen_layer_0 [i+j]),
          .o_prg      (prg_layer_1 [i+j]),
          .o_gen      (gen_layer_1 [i+j])
        );

        assign prg_layer_1 [i+j-2] = prg_layer_0 [i+j-2];
        assign prg_layer_1 [i+j-2] = prg_layer_0 [i+j-2];
      end
    end
  endgenerate

  logic [TERM_WIDTH-1:0] prg_layer_2, gen_layer_2;

  generate
    for (genvar i = 3; i < TERM_WIDTH; i += 8) begin: g_pg_layer_2
      for (genvar j = 1; j <= 4; j += 1) begin: g_pg_combine_2
        pg_cell u_pg_cell(
          .i_prg_high (prg_layer_1 [i+j]),
          .i_gen_high (gen_layer_1 [i+j]),
          .i_prg_low  (prg_layer_1 [i  ]),
          .i_gen_low  (gen_layer_1 [i  ]),
          .o_prg      (prg_layer_2 [i+j]),
          .o_gen      (gen_layer_2 [i+j])
        );

        assign prg_layer_2 [i+j-4] = prg_layer_1 [i+j-4];
        assign gen_layer_2 [i+j-4] = gen_layer_1 [i+j-4];
      end
    end
  endgenerate

  logic [TERM_WIDTH-1:0] prg_layer_3, gen_layer_3;

  generate
    for (genvar i = 7; i < TERM_WIDTH; i += 16) begin: g_pg_layer_3
      for (genvar j = 1; j <= 8; j += 1) begin: g_pg_combine_3
        pg_cell u_pg_cell(
          .i_prg_high (prg_layer_2 [i+j]),
          .i_gen_high (gen_layer_2 [i+j]),
          .i_prg_low  (prg_layer_2 [i  ]),
          .i_gen_low  (gen_layer_2 [i  ]),
          .o_prg      (prg_layer_3 [i+j]),
          .o_gen      (gen_layer_3 [i+j])
        );

        assign prg_layer_3 [i+j-8] = prg_layer_2 [i+j-8];
        assign gen_layer_3 [i+j-8] = gen_layer_2 [i+j-8];
      end
    end
  endgenerate

  generate
    for (genvar i = 0; i < TERM_WIDTH; i += 1) begin: g_sum
      sum_cell u_sum_cell(
        .a   (a           [i]),
        .b   (b           [i]),
        .g   (gen_layer_3 [i]),
        .sum (sum         [i])
      );
    end
  endgenerate

  assign c_out =  (a [TERM_WIDTH-1] & b [TERM_WIDTH-1])
               | ((a [TERM_WIDTH-1] | b [TERM_WIDTH-1])
               & gen_layer_3 [TERM_WIDTH-1]);

endmodule : prefix_adder
