module sum_cell(
  input  logic a,
  input  logic b,
  input  logic g,
  output logic sum
);

  assign sum = a ^ b ^ g;

endmodule
