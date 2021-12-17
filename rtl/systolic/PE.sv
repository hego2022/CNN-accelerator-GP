module PE(clk_in,nrst_in,ctrl_in,PE_in,PE_out,feature_in,feature_out);
parameter w = 8;
input clk_in,nrst_in,ctrl_in;
input [w-1:0]PE_in,feature_in;
output [w-1:0] feature_out;
output reg [w-1:0] PE_out;
reg [w-1:0] weight_in,partial_sum_in;
wire [w*2-1:0] mul_out;
wire [w-1:0]tmp,partial_sum_out ;
assign mul_out = weight_in * feature_in;
assign tmp = mul_out[w-1:0];              	 //quantization
assign partial_sum_out = partial_sum_in +tmp;
assign feature_out = (~nrst_in)?0:feature_in;
always @(posedge clk_in or negedge nrst_in )begin
	if(!nrst_in) begin
		PE_out <= 0;
		partial_sum_in <=0;
		weight_in <= 0;
	end
	else if(ctrl_in) begin
		weight_in <= PE_in;
		PE_out <= PE_in;
	end
	else begin
		partial_sum_in <= PE_in;
		PE_out <= partial_sum_out;
	end
end
endmodule
