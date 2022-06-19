// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

// PROGRAM		"Quartus II 64-Bit"
// VERSION		"Version 13.1.0 Build 162 10/23/2013 SJ Web Edition"
// CREATED		"Sun Jun 05 10:05:39 2022"

module datapath(
	AdrSrc,
	PcWrite,
	MemWrite,
	IRWrite,
	RegSrc1,
	ExtenderShift,
	RegWrite,
	clk,
	rst,
	S,
	ALUControl,
	ALUSrcA,
	ALUSrcB,
	IMM_VAL_1,
	IMM_VAL_7,
	ImmSrc,
	RegSrc0,
	ResultSrc,
	ALUResult,
	FLAGS,
	Instr,
	PC,
	R0_VAL,
	R1_VAL,
	R2_VAL,
	R3_VAL,
	R4_VAL,
	R5_VAL,
	R6_VAL,
	ReadData,
	Result,
	SRC_A,
	SRC_B,
	WrittenData
);


input wire	AdrSrc;
input wire	PcWrite;
input wire	MemWrite;
input wire	IRWrite;
input wire	RegSrc1;
input wire	ExtenderShift;
input wire	RegWrite;
input wire	clk;
input wire	rst;
input wire	S;
input wire	[3:0] ALUControl;
input wire	[1:0] ALUSrcA;
input wire	[1:0] ALUSrcB;
input wire	[7:0] IMM_VAL_1;
input wire	[2:0] IMM_VAL_7;
input wire	[1:0] ImmSrc;
input wire	[1:0] RegSrc0;
input wire	[1:0] ResultSrc;
output wire	[7:0] ALUResult;
output wire	[3:0] FLAGS;
output wire	[15:0] Instr;
output wire	[7:0] PC;
output wire	[7:0] R0_VAL;
output wire	[7:0] R1_VAL;
output wire	[7:0] R2_VAL;
output wire	[7:0] R3_VAL;
output wire	[7:0] R4_VAL;
output wire	[7:0] R5_VAL;
output wire	[7:0] R6_VAL;
output wire	[7:0] ReadData;
output wire	[7:0] Result;
output wire	[7:0] SRC_A;
output wire	[7:0] SRC_B;
output wire	[7:0] WrittenData;

wire	[3:0] F;
wire	[3:3] FL;
wire	[15:0] Instr_ALTERA_SYNTHESIZED;
wire	[15:0] M;
wire	[7:0] SYNTHESIZED_WIRE_0;
wire	[7:0] SYNTHESIZED_WIRE_1;
wire	[7:0] SYNTHESIZED_WIRE_27;
wire	[7:0] SYNTHESIZED_WIRE_3;
wire	[7:0] SYNTHESIZED_WIRE_4;
wire	[7:0] SYNTHESIZED_WIRE_28;
wire	[7:0] SYNTHESIZED_WIRE_29;
wire	[2:0] SYNTHESIZED_WIRE_8;
wire	[2:0] SYNTHESIZED_WIRE_9;
wire	[7:0] SYNTHESIZED_WIRE_12;
wire	[7:0] SYNTHESIZED_WIRE_30;
wire	[7:0] SYNTHESIZED_WIRE_31;
wire	[7:0] SYNTHESIZED_WIRE_16;
wire	[7:0] SYNTHESIZED_WIRE_32;
wire	[7:0] SYNTHESIZED_WIRE_18;
wire	[7:0] SYNTHESIZED_WIRE_22;
wire	[0:7] SYNTHESIZED_WIRE_24;
wire	[0:7] SYNTHESIZED_WIRE_25;
wire	[0:2] SYNTHESIZED_WIRE_26;

assign	ALUResult = SYNTHESIZED_WIRE_28;
assign	PC = SYNTHESIZED_WIRE_29;
assign	Result = SYNTHESIZED_WIRE_27;
assign	SRC_A = SYNTHESIZED_WIRE_0;
assign	SRC_B = SYNTHESIZED_WIRE_1;
assign	WrittenData = SYNTHESIZED_WIRE_32;
assign	SYNTHESIZED_WIRE_24 = 0;
assign	SYNTHESIZED_WIRE_25 = 0;
assign	SYNTHESIZED_WIRE_26 = 0;




alu_with_shifter	b2v_inst(
	.A(SYNTHESIZED_WIRE_0),
	.B(SYNTHESIZED_WIRE_1),
	.control(ALUControl),
	
	.Z(F[2]),
	.CO(F[1]),
	.OVF(F[0]),
	.out(SYNTHESIZED_WIRE_28));
	defparam	b2v_inst.W = 8;


mux_2x1	b2v_inst10(
	.sel(RegSrc1),
	.in0(Instr_ALTERA_SYNTHESIZED[2:0]),
	.in1(Instr_ALTERA_SYNTHESIZED[10:8]),
	.out(SYNTHESIZED_WIRE_9));
	defparam	b2v_inst10.W = 3;



reg_w_rst_en	b2v_inst12(
	.clk(clk),
	.rst(rst),
	.en(PcWrite),
	.inp(SYNTHESIZED_WIRE_27),
	.out(SYNTHESIZED_WIRE_29));
	defparam	b2v_inst12.W = 8;


reg_w_rst_en	b2v_inst13(
	.clk(clk),
	.rst(rst),
	.en(S),
	.inp(F),
	.out(FLAGS));
	defparam	b2v_inst13.W = 4;


reg_w_res	b2v_inst14(
	.clk(clk),
	.rst(rst),
	.inp(SYNTHESIZED_WIRE_3),
	.out(SYNTHESIZED_WIRE_22));
	defparam	b2v_inst14.W = 8;


reg_w_res	b2v_inst15(
	.clk(clk),
	.rst(rst),
	.inp(SYNTHESIZED_WIRE_4),
	.out(SYNTHESIZED_WIRE_32));
	defparam	b2v_inst15.W = 8;


reg_w_res	b2v_inst16(
	.clk(clk),
	.rst(rst),
	.inp(SYNTHESIZED_WIRE_28),
	.out(SYNTHESIZED_WIRE_12));
	defparam	b2v_inst16.W = 8;


reg_w_res	b2v_inst18(
	.clk(clk),
	.rst(rst),
	.inp(M[7:0]),
	.out(SYNTHESIZED_WIRE_30));
	defparam	b2v_inst18.W = 8;


mux_2x1	b2v_inst19(
	.sel(AdrSrc),
	.in0(SYNTHESIZED_WIRE_29),
	.in1(SYNTHESIZED_WIRE_27),
	.out(SYNTHESIZED_WIRE_16));
	defparam	b2v_inst19.W = 8;


reg_file_8	b2v_inst2(
	.clk(clk),
	.WE3(RegWrite),
	.A1(SYNTHESIZED_WIRE_8),
	.A2(SYNTHESIZED_WIRE_9),
	.A3(Instr_ALTERA_SYNTHESIZED[10:8]),
	.R7_in(SYNTHESIZED_WIRE_27),
	.WD3(SYNTHESIZED_WIRE_27),
	.R0_VAL(R0_VAL),
	.R1_VAL(R1_VAL),
	.R2_VAL(R2_VAL),
	.R3_VAL(R3_VAL),
	.R4_VAL(R4_VAL),
	.R5_VAL(R5_VAL),
	.R6_VAL(R6_VAL),
	.RD1(SYNTHESIZED_WIRE_3),
	.RD2(SYNTHESIZED_WIRE_4));


reg_w_rst_en	b2v_inst20(
	.clk(clk),
	.rst(rst),
	.en(IRWrite),
	.inp(M),
	.out(Instr_ALTERA_SYNTHESIZED));
	defparam	b2v_inst20.W = 16;


mux_4x1	b2v_inst22(
	.in0(SYNTHESIZED_WIRE_12),
	.in1(SYNTHESIZED_WIRE_30),
	.in2(SYNTHESIZED_WIRE_28),
	.in3(SYNTHESIZED_WIRE_31),
	.sel(ResultSrc),
	.out(SYNTHESIZED_WIRE_27));
	defparam	b2v_inst22.W = 8;



data_instruction_memory	b2v_inst3(
	.clk(clk),
	.WE(MemWrite),
	.A(SYNTHESIZED_WIRE_16),
	.WD(SYNTHESIZED_WIRE_32),
	.RD(M));


extend	b2v_inst4(
	.ImmSrc(ImmSrc),
	.inp(Instr_ALTERA_SYNTHESIZED[11:0]),
	.out(SYNTHESIZED_WIRE_18));


left_shifter	b2v_inst5(
	.en(ExtenderShift),
	.inp(SYNTHESIZED_WIRE_18),
	.rot(Instr_ALTERA_SYNTHESIZED[7:5]),
	.out(SYNTHESIZED_WIRE_31));



mux_4x1	b2v_inst7(
	.in0(SYNTHESIZED_WIRE_32),
	.in1(SYNTHESIZED_WIRE_31),
	.in2(IMM_VAL_1),
	.in3(SYNTHESIZED_WIRE_30),
	.sel(ALUSrcB),
	.out(SYNTHESIZED_WIRE_1));
	defparam	b2v_inst7.W = 8;


mux_4x1	b2v_inst8(
	.in0(SYNTHESIZED_WIRE_22),
	.in1(SYNTHESIZED_WIRE_29),
	.in2(SYNTHESIZED_WIRE_24),
	.in3(SYNTHESIZED_WIRE_25),
	.sel(ALUSrcA),
	.out(SYNTHESIZED_WIRE_0));
	defparam	b2v_inst8.W = 8;


mux_4x1	b2v_inst9(
	.in0(Instr_ALTERA_SYNTHESIZED[7:5]),
	.in1(IMM_VAL_7),
	.in2(Instr_ALTERA_SYNTHESIZED[10:8]),
	.in3(SYNTHESIZED_WIRE_26),
	.sel(RegSrc0),
	.out(SYNTHESIZED_WIRE_8));
	defparam	b2v_inst9.W = 3;

assign	Instr = Instr_ALTERA_SYNTHESIZED;
assign	ReadData[7:0] = M[7:0];

endmodule
