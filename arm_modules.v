///////////////////
//DONE
module reg_file_8(clk, A1, A2, A3, WD3, R7_in, RD1, RD2, WE3, R0_VAL, R1_VAL, R2_VAL, R3_VAL, R4_VAL, R5_VAL, R6_VAL);
	input clk, WE3;
	input[2:0] A1, A2, A3;
	input[7:0] WD3, R7_in;
	
	output [7:0] RD1, RD2;
	
	wire [7:0] R_OUT[7:0];
	wire [7:0] DEC_WR_OUT, WRITE_SELECT;
	
	output wire [7:0] R0_VAL, R1_VAL, R2_VAL, R3_VAL, R4_VAL, R5_VAL, R6_VAL;
	
	dec_3x8 dec_write_en(.inp(A3), .out(DEC_WR_OUT));
	
	assign WRITE_SELECT[0] = DEC_WR_OUT[0] & WE3;
	assign WRITE_SELECT[1] = DEC_WR_OUT[1] & WE3;
	assign WRITE_SELECT[2] = DEC_WR_OUT[2] & WE3;
	assign WRITE_SELECT[3] = DEC_WR_OUT[3] & WE3;
	assign WRITE_SELECT[4] = DEC_WR_OUT[4] & WE3;
	assign WRITE_SELECT[5] = DEC_WR_OUT[5] & WE3;
	assign WRITE_SELECT[6] = DEC_WR_OUT[6] & WE3;
	assign WRITE_SELECT[7] = DEC_WR_OUT[7] & WE3;

	bit_8_reg_w_rst_en #(0) R0(.clk(clk), .rst(0), .en(WRITE_SELECT[0]), .inp(WD3), .out(R_OUT[0]));
	bit_8_reg_w_rst_en #(1) R1(.clk(clk), .rst(0), .en(WRITE_SELECT[1]), .inp(WD3), .out(R_OUT[1]));
	bit_8_reg_w_rst_en #(2) R2(.clk(clk), .rst(0), .en(WRITE_SELECT[2]), .inp(WD3), .out(R_OUT[2]));
	bit_8_reg_w_rst_en #(3) R3(.clk(clk), .rst(0), .en(WRITE_SELECT[3]), .inp(WD3), .out(R_OUT[3]));
	
	bit_8_reg_w_rst_en #(4) R4(.clk(clk), .rst(0), .en(WRITE_SELECT[4]), .inp(WD3), .out(R_OUT[4]));
	bit_8_reg_w_rst_en #(5) R5(.clk(clk), .rst(0), .en(WRITE_SELECT[5]), .inp(WD3), .out(R_OUT[5]));
	bit_8_reg_w_rst_en #(6) R6(.clk(clk), .rst(0), .en(WRITE_SELECT[6]), .inp(WD3), .out(R_OUT[6]));
	bit_8_reg_w_rst_en #(0) R7(.clk(clk), .rst(0), .en(WRITE_SELECT[7]), .inp(R7_in), .out(R_OUT[7]));
	
	mux_8x1 #(8) mux_A1(R_OUT[0], R_OUT[1], R_OUT[2], R_OUT[3],
								 R_OUT[4], R_OUT[5], R_OUT[6], R_OUT[7],
								 A1, RD1);
								 
	mux_8x1 #(8) mux_A2(R_OUT[0], R_OUT[1], R_OUT[2], R_OUT[3],
								 R_OUT[4], R_OUT[5], R_OUT[6], R_OUT[7],
								 A2, RD2);
	
	assign R0_VAL = R_OUT[0];
	assign R1_VAL = R_OUT[1];
	assign R2_VAL = R_OUT[2];
	assign R3_VAL = R_OUT[3];
	assign R4_VAL = R_OUT[4];
	assign R5_VAL = R_OUT[5];
	assign R6_VAL = R_OUT[6];
	
endmodule
///////////////////
// DONE
module extend(inp, out, ImmSrc);
	input [11:0] inp;
	input [1:0] ImmSrc;
	output reg [7:0] out;
	
	always @(inp, ImmSrc)
	begin
		if (ImmSrc == 2'b00 || ImmSrc == 2'b01) begin // imm5 for OP=00,01
			out = {3'b0, inp[4:0]};
		end
		if (ImmSrc == 2'b10) begin // addr5/offset5 for OP=10
			//inp[11] = H
			out = {2'b0, inp[11], inp[4:0]};
		end
		if (ImmSrc == 2'b11) begin // addr6 for OP=11
			out = {2'b0, inp[5:0]};
		end
	end
	
endmodule
//DONE
///////////////////
module data_instruction_memory(clk, A, WD, WE, RD);
	input clk, WE;
	input [7:0] A, WD;
	output reg [15:0] RD;
	
	// each address points to a byte
	// total of 64 addressable bytes in the memory
	reg[7:0] memory[0:63];
	integer i;
	
	initial begin
		for (i=0; i<64; i=i+1) begin
			memory[i] = 0;
		end
		/*
		{memory[1], memory[0]} = 16'b1001111000010010; // STR R6,[50]
		{memory[3], memory[2]} = 16'b1011100000010010; // LDR R0,[50]
		{memory[5], memory[4]} = 16'b1000001000011100; // STR R2,R0,[28]
		{memory[7], memory[6]} = 16'b1010000110011110; // LDR R1,R4,[30]
		{memory[9], memory[8]} = 16'b0101001000100011; // XOR R2,R1,R3
		{memory[11], memory[10]} = 16'b0001000111000000; // SUB R1,R6,R0
		{memory[13], memory[12]} = 16'b0111000000000001; // LSR R0,1
		{memory[15], memory[14]} = 16'b0011100101010100; // MOV R1,80
		{memory[17], memory[16]} = 16'b1110000000110010; // BI M[50]
		*/
		$readmemb("memory.b",memory);
	end
	
	always @(posedge clk)
	begin
		if (WE)
			{memory[A]} <= WD;
	end
	
	always @(A)
	begin
		RD = {memory[A+1], memory[A]};
	end
		
endmodule
///////////////////
// DONE
module left_shifter(inp, rot, en, out);
	input [7:0] inp;
	input [2:0] rot;
	input en;
	output reg [7:0] out;
	
	always @(*)
	begin
	if (en)
	begin
		out = inp << rot;
	end
	else
		out = inp;
	end
	
endmodule
///////////////////
// DONE
module alu_with_shifter #(parameter W=8)(A, B, out, control, N, Z, CO, OVF);
	
	input [W-1:0] A, B;
	input [3:0] control;
	output reg N,Z,CO,OVF;
	output reg [W-1:0] out;
	
	reg [2*W-1:0] A_A;
	reg [W-1:0] B_plus_32;
	
	always @(A, B, control)
	begin
		case(control)
		4'b0000:	begin // ADD
					{CO, out} = A + B;
					OVF = (A[W-1] ~^ B[W-1]) & (A[W-1] ^ out[W-1]);
					// OVF=1 if the addition of 2 same-signed numbers produces a result with the opposite sign
					end
		4'b0001:	begin //SUB1
					{CO, out} = A - B;
					OVF = (A[W-1] ^ out[W-1]) & (A[W-1] ^ B[W-1]);
					// OVF=1 if A and out have opposite signs and A and B have different signs upon subtraction
					end
		4'b0010:	begin //SUB2
					{CO, out} = B - A;
					OVF = (B[W-1] ^ out[W-1]) & (A[W-1] ^ B[W-1]);
					// OVF=1 if B and out have opposite signs and A and B have different signs upon subtraction
					end
		4'b0011:	begin
					out = A & (~B);
					CO = 0;
					OVF = 0;
					end
		4'b0100:	begin // AND
					out = A & B;
					CO = 0;
					OVF = 0;
					end
		4'b0101:	begin // OR
					out = A | B;
					CO = 0;
					OVF = 0;
					end
		4'b0110:	begin // XOR
					out = A ^ B;
					CO = 0;
					OVF = 0;
					end
		4'b0111:	begin
					out = A ~^ B;
					CO = 0;
					OVF = 0;
					end
		4'b1000: begin // ROL
					A_A = {A,A};
					A_A = A_A << B;
					out = A_A[2*W-1:W];
					end
		4'b1001: begin // ROR
					A_A = {A,A};
					A_A = A_A >> B;
					out = A_A[W-1:0];
					end
		4'b1010: begin // LSL
					out = A << B;
					end
		4'b1011: begin // LSR
					out = A >> B;
					end
		4'b1100: begin // ASR
					out = A >>> B;
					end
		endcase
		N = out[W-1];
		Z = (out == 0);
	end
	
endmodule