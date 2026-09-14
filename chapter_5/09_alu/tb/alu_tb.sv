`timescale 1ns/1ps

module alu_tb;

  localparam WIDTH = 16;

  logic [WIDTH - 1:0] a, b;
  logic [        2:0] func;
  logic [WIDTH - 1:0] y, sum_op;
  logic               c_out;

  typedef enum logic [2:0] {
    AND_OP_B  = 3'b000,
    AND_OP_NB = 3'b100,
    OR_OP_B   = 3'b001,
    OR_OP_NB  = 3'b101,
    SUM_OP_B  = 3'b010,
    SUM_OP_NB = 3'b110,
    SLT_OP    = 3'b111
  } op_type;

  alu #(
    .ALU_WIDTH (WIDTH)
  ) DUT(
    .a            (a   ),
    .b            (b   ),
    .func         (func),
    .y            (y   ),
    .debug_sum_op (sum_op),
    .c_out        (c_out)
  );
  
  task automatic alu_check(
    input logic [WIDTH - 1:0] ta   ,
    input logic [WIDTH - 1:0] tb   ,
    op_type                   tfunc
  );

    logic [WIDTH - 1:0] expected;

    a    = ta   ;
    b    = tb   ;
    func = tfunc;

    case (tfunc)
      AND_OP_B  : expected = a &  b;
      AND_OP_NB : expected = a & ~b;
      OR_OP_B   : expected = a |  b;
      OR_OP_NB  : expected = a | ~b;
      SUM_OP_B  : expected = a +  b + func [2];
      SUM_OP_NB : expected = a + ~b + func [2];
      SLT_OP    : expected = {{(WIDTH - 1){1'b0}}, (a < b)};
    endcase

    #1;

    if (y !== expected) begin
      $error(
        "ERROR: a=%b b=%b func=%b | y=%b | expected=%b",
        a, b, func, y, expected
      );
    end else begin
      $display(
        "SUCCESS: a=%b b=%b func=%b | y=%b",
        a, b, func, y
      );
    end

  endtask

  initial begin
    repeat (125) begin
      alu_check(
        $urandom(), $urandom(), AND_OP_B
      );
    end

    repeat (125) begin
      alu_check(
        $urandom(), $urandom(), AND_OP_NB
      );
    end

    repeat (125) begin
      alu_check(
        $urandom(), $urandom(), OR_OP_B
      );
    end

    repeat (125) begin
      alu_check(
        $urandom(), $urandom(), OR_OP_NB
      );
    end

    repeat (125) begin
      alu_check(
        $urandom(), $urandom(), SUM_OP_B
      );
    end

    repeat (125) begin
      alu_check(
        $urandom(), $urandom(), SUM_OP_NB
      );
    end

    repeat (125) begin
      alu_check(
        $urandom(), $urandom(), SLT_OP
      );
    end
  end

  initial begin
    $dumpfile("alu.vcd");
    $dumpvars(0, alu_tb);
    #10000;
    $finish;
  end

endmodule
