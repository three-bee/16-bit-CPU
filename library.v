///////////////////
module const_val_gen #(parameter W=8)(in, out);

	input [W-1:0] in;
	output [W-1:0] out;
	
	assign out = in;
	
endmodule
///////////////////
module dec_2x4(inp, out);

	input [1:0] inp;
	output [3:0] out;
	
	assign out[3] = inp[1] & inp[0];
	assign out[2] = inp[1] & (~inp[0]);
	assign out[1] = (~inp[1]) & inp[0];
	assign out[0] = (~inp[1]) & (~inp[0]);
	
endmodule
///////////////////
module dec_3x8(inp, out);

	input [2:0] inp;
	output [7:0] out;
	
	assign out[7] = (inp[2]) & (inp[1]) & (inp[0]);
	assign out[6] = (inp[2]) & (inp[1]) & (~inp[0]);
	assign out[5] = (inp[2]) & (~inp[1]) & (inp[0]);
	assign out[4] = (inp[2]) & (~inp[1]) & (~inp[0]);
	assign out[3] = (~inp[2]) & (inp[1]) & (inp[0]);
	assign out[2] = (~inp[2]) & (inp[1]) & (~inp[0]);
	assign out[1] = (~inp[2]) & (~inp[1]) & (inp[0]);
	assign out[0] = (~inp[2]) & (~inp[1]) & (~inp[0]);
	
endmodule
///////////////////
module dec_4x16(inp, out);

	input [3:0] inp;
	output [15:0] out;
	
	assign out[15] = (inp[3]) & (inp[2]) & (inp[1]) & (inp[0]);
	assign out[14] = (inp[3]) & (inp[2]) & (inp[1]) & (~inp[0]);
	assign out[13] = (inp[3]) & (inp[2]) & (~inp[1]) & (inp[0]);
	assign out[12] = (inp[3]) & (inp[2]) & (~inp[1]) & (~inp[0]);
	assign out[11] = (inp[3]) & (~inp[2]) & (inp[1]) & (inp[0]);
	assign out[10] = (inp[3]) & (~inp[2]) & (inp[1]) & (~inp[0]);
	assign out[9] = (inp[3]) & (~inp[2]) & (~inp[1]) & (inp[0]);
	assign out[8] = (inp[3]) & (~inp[2]) & (~inp[1]) & (~inp[0]);
	assign out[7] = (~inp[3]) & (inp[2]) & (inp[1]) & (inp[0]);
	assign out[6] = (~inp[3]) & (inp[2]) & (inp[1]) & (~inp[0]);
	assign out[5] = (~inp[3]) & (inp[2]) & (~inp[1]) & (inp[0]);
	assign out[4] = (~inp[3]) & (inp[2]) & (~inp[1]) & (~inp[0]);
	assign out[3] = (~inp[3]) & (~inp[2]) & (inp[1]) & (inp[0]);
	assign out[2] = (~inp[3]) & (~inp[2]) & (inp[1]) & (~inp[0]);
	assign out[1] = (~inp[3]) & (~inp[2]) & (~inp[1]) & (inp[0]);
	assign out[0] = (~inp[3]) & (~inp[2]) & (~inp[1]) & (~inp[0]);

endmodule
///////////////////
module mux_2x1 #(parameter W=8)(in0, in1, sel, out);

	input [W-1:0] in0, in1;
	input sel;
	output reg [W-1:0] out;
	
	always @(in0, in1, sel)
		case(sel)
			1'b0: out = in0;
			1'b1: out = in1;
		endcase
	
endmodule
///////////////////
module mux_4x1 #(parameter W=8)(in0, in1, in2, in3, sel, out);

	input [W-1:0] in0, in1, in2, in3;
	input [1:0] sel;
	output reg [W-1:0] out;

	always @(in0, in1, in2, in3, sel)
		case(sel)
			2'b00: out = in0;
			2'b01: out = in1;
			2'b10: out = in2;
			2'b11: out = in3;
		endcase
endmodule
///////////////////
module mux_8x1 #(parameter W=8)(in0, in1, in2, in3, in4, in5, in6, in7, sel, out);

	input [W-1:0] in0, in1, in2, in3, in4, in5, in6, in7;
	input [2:0] sel;
	wire [W-1:0] middle_out0, middle_out1;
	output [W-1:0] out;

	mux_4x1 #(W) mux1 (in0, in1, in2, in3, sel[1:0], middle_out0);
	mux_4x1 #(W) mux2 (in4, in5, in6, in7, sel[1:0], middle_out1);
	
	mux_2x1 #(W) mux3 (middle_out0, middle_out1, sel[2], out);

endmodule
///////////////////
module mux_16x1 #(parameter W=8)(in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, sel, out);

	input [W-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15;
	input [3:0] sel;
	wire [W-1:0] middle_out0, middle_out1, middle_out2, middle_out3;
	output [W-1:0] out;
	
	mux_4x1 #(W) mux1 (in0, in1, in2, in3, sel[1:0], middle_out0);
	mux_4x1 #(W) mux2 (in4, in5, in6, in7, sel[1:0], middle_out1);
	mux_4x1 #(W) mux3 (in8, in9, in10, in11, sel[1:0], middle_out2);
	mux_4x1 #(W) mux4 (in12, in13, in14, in15, sel[1:0], middle_out3);
	
	mux_4x1 #(W) mux5 (middle_out0, middle_out1, middle_out2, middle_out3, sel[3:2], out);
	
endmodule
///////////////////
module alu #(parameter W=8)(A, B, out, control, N, Z, CO, OVF);
	
	input [W-1:0] A, B;
	input [2:0] control;
	output reg N,Z,CO,OVF;
	output reg [W-1:0] out;
	
	always @(A, B, control)
	begin
		case(control)
		3'b000:	begin
					{CO, out} = A + B;
					OVF = (A[W-1] ~^ B[W-1]) & (A[W-1] ^ out[W-1]);
					// OVF=1 if the addition of 2 same-signed numbers produces a result with the opposite sign
					end
		3'b001:	begin
					{CO, out} = A - B;
					OVF = (A[W-1] ^ out[W-1]) & (A[W-1] ^ B[W-1]);
					// OVF=1 if A and out have opposite signs and A and B have different signs upon subtraction
					end
		3'b010:	begin
					{CO, out} = B - A;
					OVF = (B[W-1] ^ out[W-1]) & (A[W-1] ^ B[W-1]);
					// OVF=1 if B and out have opposite signs and A and B have different signs upon subtraction
					end
		3'b011:	begin
					out = A & (~B);
					CO = 0;
					OVF = 0;
					end
		3'b100:	begin
					out = A & B;
					CO = 0;
					OVF = 0;
					end
		3'b101:	begin
					out = A | B;
					CO = 0;
					OVF = 0;
					end
		3'b110:	begin
					out = A ^ B;
					CO = 0;
					OVF = 0;
					end
		3'b111:	begin
					out = A ~^ B;
					CO = 0;
					OVF = 0;
					end
		endcase
		N = out[W-1];
		Z = (out == 0); //??
	end
	
endmodule
///////////////////
// REG WITH SYNC RESET
///////////////////
module reg_w_res #(parameter W=8) (clk, rst, inp, out);
	
	input clk, rst;
	input [W-1:0] inp;
	output reg [W-1:0] out;
	
	initial begin
		out <= 0;
	end
	
	always @(posedge clk)
	begin
		if (rst) begin
			out <= 0;
		end else begin
			out <= inp;
		end
	end
	
endmodule
// REG WITH SYNC RESET & ENABLE PIN
///////////////////
module reg_w_rst_en #(parameter W=8) (clk, rst, en, inp, out);
	
	input clk, rst, en;
	input [W-1:0] inp;
	output reg [W-1:0] out;
	
	initial begin
		out = 0;
	end
	
	always @(posedge clk)
	begin
		if (en) begin
			if (rst) begin
				out <= 0;
			end else begin
				out <= inp;
			end
		end
	end
	
endmodule
// 32 BIT REGISTER WITH SYNC RESET & ENABLE PIN, INITIAL VALUE IS THE PARAMETER
module bit_32_reg_w_rst_en #(parameter D=8) (clk, rst, en, inp, out);
	
	input clk, rst, en;
	input [31:0] inp;
	output reg [31:0] out;
	
	initial begin
		out = D;
	end
	
	always @(posedge clk)
	begin
		if (en) begin
			if (rst) begin
				out <= 0;
			end else begin
				out <= inp;
			end
		end
	end
	
endmodule
// 8 BIT REGISTER WITH SYNC RESET & ENABLE PIN, INITIAL VALUE IS THE PARAMETER
module bit_8_reg_w_rst_en #(parameter D=0) (clk, rst, en, inp, out);

	input clk, rst, en;
	input [7:0] inp;
	output reg [7:0] out;
	
	initial begin
		out = D;
	end
	
	always @(posedge clk)
	begin
		if (en) begin
			if (rst) begin
				out <= 0;
			end else begin
				out <= inp;
			end
		end
	end
	
endmodule
// SHIFT REG WITH SYNC RESET & SERIAL AND PARALLEL LOAD
///////////////////
module reg_w_shft #(parameter W=8) (clk, rst, parallel, shr, p_in, p_out, s_in_r, s_in_l, s_out_r, s_out_l);
	
	input clk, rst, parallel, s_in_l, s_in_r, shr;
	input [W-1:0] p_in;
	
	output s_out_l, s_out_r;
	output reg [W-1:0] p_out;
	
	assign s_out_l = p_out[W-1];
	assign s_out_r = p_out[0];
	
	always @(posedge clk)
	begin
		if (rst)
			p_out <= 0;
		else
			if (parallel)
				p_out <= p_in;
			else
				if (shr)
					p_out <= {s_in_l, p_out[W-1:1]};	
				else
					p_out <= {p_out[W-2:0], s_in_r};
	end
endmodule
///////////////////
module reg_file #(parameter W=8) (clk, rst, w_en, addr_in, s_out1, s_out2, data_in, data_out1, data_out2);

	input clk, rst, w_en;
	input [1:0] addr_in, s_out1, s_out2;
	input [W-1:0] data_in;
	output [W-1:0] data_out1, data_out2;
	
	wire [3:0] dec_out;
	wire [W-1:0] reg_out1, reg_out2, reg_out3, reg_out4;
	
	dec_2x4 DEC_ADDR(addr_in, dec_out);
	
	reg_w_rst_en #(W) R1(clk, rst, (dec_out[0] & w_en), data_in, reg_out1);
	reg_w_rst_en #(W) R2(clk, rst, (dec_out[1] & w_en), data_in, reg_out2);
	reg_w_rst_en #(W) R3(clk, rst, (dec_out[2] & w_en), data_in, reg_out3);
	reg_w_rst_en #(W) R4(clk, rst, (dec_out[3] & w_en), data_in, reg_out4);
	
	mux_4x1 #(W) MUX_OUT1(reg_out1, reg_out2, reg_out3, reg_out4, s_out1, data_out1);
	mux_4x1 #(W) MUX_OUT2(reg_out1, reg_out2, reg_out3, reg_out4, s_out2, data_out2);
	
endmodule
///////////////////