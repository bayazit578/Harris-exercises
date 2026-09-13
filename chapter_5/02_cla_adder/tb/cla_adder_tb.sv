`timescale 1ns/1ps

module cla_adder_tb;

  localparam int WIDTH = 64;

  logic [WIDTH - 1:0] a    ;
  logic [WIDTH - 1:0] b    ;
  logic               c_in ;
  logic [WIDTH - 1:0] sum  ;
  logic               c_out;
 
  cla_adder #(
    .TERM_WIDTH (WIDTH)
  ) DUT(
    .a     (a    ),
    .b     (b    ),
    .c_in  (c_in ),
    .sum   (sum  ),
    .c_out (c_out)
  );

  task automatic module_check (
    input logic [WIDTH - 1:0] ta,
    input logic [WIDTH - 1:0] tb,
    input logic               tc_in
  );

    logic [WIDTH:0] expected;

    a    = ta   ;
    b    = tb   ;
    c_in = tc_in;

    expected = {1'b0, a} + {1'b0, b} + c_in;

    #1;

    if ({c_out, sum} !== expected) begin
      $error(
        "ERROR: a=%b b=%b c_in=%b | sum=%b c_out=%b | expected=%b",
        a, b, c_in, sum, c_out, expected
      );
    end else begin
      $display(
        "SUCCESS: a=%b b=%b c_in=%b | sum=%b c_out=%b",
        a, b, c_in, sum, c_out
      );
    end
  endtask

  initial begin
    repeat (1000) begin
      module_check(
        {$urandom(), $urandom()},
        {$urandom(), $urandom()},
        $urandom_range(0, 1)
      );
    end

    $finish;
  end

endmodule
