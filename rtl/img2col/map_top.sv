module map_top #(
  parameter row         = 28,
            data_width  = 16,
            weight_size = 25,
            address_num = 5,
            reg_num     = 20
) (
  input logic  clk,nrst,
  input logic  [row-1:0] start,
  input logic  [data_width-1:0]  new1, new2,                            //data comes from AXI
  input logic  [address_num-1:0] adrs_in1, adrs_in2,
  output logic [data_width-1:0]  out [weight_size-1:0]
  output done;
);
logic [5:0] round,PU1_add,PU_No,row_No;

  pus_vector pus_vector(
      .clk(clk),
      .nrst(nrst),
      .start(start),
      .PU_No(PU_No),
      .new1(new1),
      .new2(new2),                            //data comes from AXI
      .adrs_in1(adrs_in1),
      .adrs_in2(adrs_in2),
      .out(out)
  );

  Map_Control map_ctrl(
    .clk(clk),
    .nrst(nrst),
    .start(start),
    .round(round),
    .PU1_add(PU1_add),
    .PU_No(PU_No),
    .row_No(row_No)
    .done(done)
  );
endmodule
