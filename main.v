module main(clk, rst, S, R0_VAL, R1_VAL, R2_VAL, R3_VAL, R4_VAL, R5_VAL, R6_VAL, Instr, current_state, next_state, ALUResult, ReadData, Result, WrittenData, SRC_A, SRC_B, PC, PCWrite, IRWrite, FLAGS);

	input clk, rst;
	
	output reg PCWrite, IRWrite, S;
	reg AdrSrc, MemWrite, RegSrc1, ExtenderShift, RegWrite;
	reg [1:0] RegSrc0, ALUSrcA, ALUSrcB, ResultSrc;
	reg [3:0] ALUControl;
	
	wire [1:0] OP, CMD_00, ImmSrc, B_type, B_flag;
	wire [2:0] CMD_01, Rd, Rn, Rm, rot, IMM_VAL_7;
	wire [4:0] imm5;
	wire [7:0] IMM_VAL_1;
		
	//Outputs
	output reg [4:0] current_state, next_state;
	
	output wire [3:0] FLAGS;
	output wire [7:0] R0_VAL, R1_VAL, R2_VAL, R3_VAL, R4_VAL, R5_VAL, R6_VAL;
	output wire [15:0] Instr;
	output wire [7:0] ALUResult, ReadData, Result, WrittenData, SRC_A, SRC_B, PC;
	
	assign OP = Instr[15:14];
	assign CMD_00 = Instr[13:12]; // OP = 00
	assign CMD_01 = Instr[13:11]; // OP = 01
	assign Rd = Instr[10:8];
	assign Rn = Instr[7:5];
	assign Rm = Instr[2:0];
	assign rot = Instr[7:5];
	assign imm5 = Instr[4:0];
	assign B_type = Instr[13:12];
	assign B_flag = Instr[11:10];
	assign ImmSrc = Instr[15:14];
	
	assign IMM_VAL_7 = 7;
	assign IMM_VAL_1 = 1;
	
	datapath DUT(
		AdrSrc,
		PCWrite,
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
		
	// Available states
	parameter Fetch = 0;
	parameter Decode = 1;
	parameter MemAdr = 2;
	parameter MemRead = 3;
	parameter MemWB = 4;
	parameter MemW = 5;
	parameter ExecuteR = 6;
	parameter ExecuteI = 7;
	parameter ALUWB = 8;
	parameter Branch = 9;
	parameter BL = 10;
	parameter BI_MemAdr = 11;
	parameter BI_MemRead = 12;
	parameter BI_WritePC = 13;
	parameter BranchWithCondition = 14;
	
	initial
	begin
		current_state = Fetch;
		next_state = Fetch;
		S = 0;
	end
	
	///////STATE MEMORY
	always @(posedge clk)
	begin: STATE_MEMORY
		current_state <= next_state;
	end
	
	///////WRITE SIGNALS
	always @(current_state)
	begin: WRITE_CONTROLLER
		case (current_state)
			Fetch: begin
				IRWrite = 1;
				PCWrite = 1;
				MemWrite = 0;
				RegWrite = 0;
				S = 0;
			end
			
			Decode: begin
				IRWrite = 0;
				PCWrite = 1;
				MemWrite = 0;
				if (OP == 2'b11 && B_type == 2'b01) //BL, R6(LR)<-PC+2
					RegWrite = 1;
				else
					RegWrite = 0;
				S = 0;
			end
			
			ExecuteR: begin
				IRWrite = 0;
				PCWrite = 0;
				MemWrite = 0;
				RegWrite = 0;
				S = 1;
			end
			
			ExecuteI: begin
				IRWrite = 0;
				PCWrite = 0;
				MemWrite = 0;
				RegWrite = 0;
				S = 1;
			end
			
			ALUWB: begin
				IRWrite = 0;
				PCWrite = 0;
				MemWrite = 0;
				RegWrite = 1;
				S = 0;
			end
			
			MemAdr: begin
				IRWrite = 0;
				PCWrite = 0;
				MemWrite = 0;
				RegWrite = 0;
				S = 0;
			end
			
			MemW: begin
				IRWrite = 0;
				PCWrite = 0;
				MemWrite = 1;
				RegWrite = 0;
				S = 0;
			end
			
			MemWB: begin
				IRWrite = 0;
				PCWrite = 0;
				MemWrite = 0;
				RegWrite = 1;
				S = 0;
			end
			
			Branch: begin
				IRWrite = 0;
				PCWrite = 1;
				MemWrite = 0;
				RegWrite = 0;
				S = 0;
			end
			
			BL: begin
				IRWrite = 0;
				PCWrite = 1;
				MemWrite = 0;
				RegWrite = 0;
				S = 0;
			end
			
			BI_WritePC: begin
				IRWrite = 0;
				PCWrite = 1;
				MemWrite = 0;
				RegWrite = 0;
				S = 0;
			end
			
			BranchWithCondition: begin
				IRWrite = 0;
				
				if (B_flag == 2'b00) begin //BEQ, branch if Z
					if (FLAGS[2] == 1)
						PCWrite = 1;
					else
						PCWrite = 0;
				end
				
				if (B_flag == 2'b01) begin //BNE, branch if !Z
					if (FLAGS[2] == 0)
						PCWrite = 1;
					else
						PCWrite = 0;
				end
				
				if (B_flag == 2'b10) begin //BHS, branch if C
					if (FLAGS[1] == 1)
						PCWrite = 1;
					else
						PCWrite = 0;
				end		
				
				if (B_flag == 2'b11) begin //BLO, branch if !C
					if (FLAGS[1] == 0)
						PCWrite = 1;
					else
						PCWrite = 0;					
				end
				
				MemWrite = 0;
				RegWrite = 0;
				S = 0;
			end	
			default: begin
				IRWrite = 0;
				PCWrite = 0;
				MemWrite = 0;
				RegWrite = 0;
				S = 0;
			end
			
		endcase
	end
	
	///////SOURCE SIGNALS
	always @(current_state)
	begin: OUTPUT_LOGIC
		case (current_state)
			Fetch: begin
				AdrSrc = 0;
				ALUSrcA = 2'b01; 
				ALUSrcB = 2'b10; // pc + 1
				ALUControl = 4'b0000; // add 
				ResultSrc = 2'b10;
			end
			
			Decode: begin
				ALUSrcA = 2'b01; 
				ALUSrcB = 2'b10; // pc + 2
				ALUControl = 4'b0000; // add 
				ResultSrc = 2'b10;
				// Set register file inputs
				case (OP)
					2'b00: begin // ARITMETHIC
						if (Instr[11] == 0) begin
							RegSrc0 = 0; //Rn
							RegSrc1 = 0; //Rm
							ExtenderShift = 0;
						end
						if (Instr[11] == 1) begin
							RegSrc0 = 2; //Rd
							//RegSrc1 = x
							ExtenderShift = 1;
						end
					end
					2'b01: begin // LOGIC AND SHIFTING
						// LOGIC
						if (CMD_01 == 3'b000 | CMD_01 == 3'b001 | CMD_01 == 3'b010) begin
							RegSrc0 = 0; //Rn
							RegSrc1 = 0; //Rm
							ExtenderShift = 0;
						end
						// SHIFT
						else begin
							RegSrc0 = 2; //Rd
							//RegSrc1 = x
							ExtenderShift = 1;
						end
					end
					2'b10: begin // MEMORY
						ExtenderShift = 0;
						RegSrc0 = 0; //Rn
						RegSrc1 = 1; //Rd
					end
					2'b11: begin // BRANCH
						ExtenderShift = 0;
						if (B_type == 2'b01) begin
							RegSrc1 = 1; //Rd
						end
					end
				endcase
			end
			
			ExecuteR: begin 
				// Rn CMD Rm
				ALUSrcA = 0; // [Rn]
				ALUSrcB = 2'b00; // [Rm]
				
				if (OP == 2'b00) begin // ARITMETHIC
					if (CMD_00 == 2'b00)
						ALUControl = 4'b0000; // add 
					if (CMD_00 == 2'b01)
						ALUControl = 4'b0001; // sub
					if (CMD_00 == 2'b10)
						ALUControl = 4'b0001; // sub for cmp
				end
				
				if (OP == 2'b01) begin // LOGIC
					if (CMD_01 == 3'b000) // and
						ALUControl = 4'b0100;
					if (CMD_01 == 3'b001) // or
						ALUControl = 4'b0101;
					if (CMD_01 == 3'b010) // xor
						ALUControl = 4'b0110;
				end
			end
			
			ExecuteI: begin
				ALUSrcB = 2'b01; //extimm
				
				if (OP == 2'b00) begin 
					if (CMD_00 == 2'b11) begin // MOV (imm5 ROL rot + 0)
						ALUSrcA = 2'b10; //IMM_0
						ALUControl = 4'b0000; // add 
					end
					else begin // ADD, SUB, CMP with extimm
						ALUSrcA = 0;
						if (CMD_00 == 2'b00)
							ALUControl = 4'b0000; // add 
						if (CMD_00 == 2'b01)
							ALUControl = 4'b0001; // sub
						if (CMD_00 == 2'b10)
							ALUControl = 4'b0001; // sub for cmp
					end
				end
				
				if (OP == 2'b01) begin // SHIFTING
					ALUSrcA = 0; // [Rd]
					if (CMD_01 == 3'b011) // rol
						ALUControl = 4'b1000;
					if (CMD_01 == 3'b100) // ror
						ALUControl = 4'b1001;
					if (CMD_01 == 3'b101) // lsl
						ALUControl = 4'b1010;
					if (CMD_01 == 3'b110) // lsr
						ALUControl = 4'b1011;
					if (CMD_01 == 3'b111) // asr
						ALUControl = 4'b1100;
				end
			end	
			
			ALUWB: begin
				ResultSrc = 2'b00;
			end
			
			MemAdr: begin
				if (Instr[12] == 0) // I=0
					ALUSrcA = 2'b00;	// RD1
				if (Instr[12] == 1) // I=1
					ALUSrcA = 2'b10;	// IMM_0
				ALUSrcB = 2'b01;
				ALUControl = 4'b0000;
			end
			
			MemRead: begin
				ResultSrc = 2'b00;
				AdrSrc = 1;
			end
			
			MemW: begin
				ResultSrc = 2'b00;
				AdrSrc = 1;
			end
			
			MemWB: begin
				ResultSrc = 2'b01;
			end
			
			Branch: begin
				ALUSrcA = 2'b10; // IMM_0
				ALUSrcB = 2'b01; // imm6
				ALUControl = 4'b0000; // add
				ResultSrc = 2'b10;
			end
			
			BL: begin
				ALUSrcA = 2'b10; // IMM_0
				ALUSrcB = 2'b01; // imm6
				ALUControl = 4'b0000; // add
				ResultSrc = 2'b10;
			end
			
			BI_MemAdr: begin
				ALUSrcA = 2'b10;	// IMM_0
				ALUSrcB = 2'b01;
				ALUControl = 4'b0000;
			end
			
			BI_MemRead: begin
				ResultSrc = 2'b00;
				AdrSrc = 1;
			end
			
			BI_WritePC: begin
				ResultSrc = 2'b01;
			end
			
			BranchWithCondition: begin
				ALUSrcA = 2'b10; // IMM_0
				ALUSrcB = 2'b01; // imm6
				ALUControl = 4'b0000; // add
				ResultSrc = 2'b10;
			end
		endcase
	end
	
	///////NEXT STATE LOGIC
	always @(current_state)
	begin: NEXT_STATE_LOGIC
		case (current_state)
			Fetch: begin
				next_state = Decode;
			end
			
			Decode: begin
				case (OP)
					2'b00: begin // ARITMETHIC
						if (Instr[11] == 0)
							next_state = ExecuteR;
						if (Instr[11] == 1)
							next_state = ExecuteI;
					end
					2'b01: begin // LOGIC AND SHIFTING
						// LOGIC
						if (CMD_01 == 3'b000 | CMD_01 == 3'b001 | CMD_01 == 3'b010)
							next_state = ExecuteR;
						// SHIFT
						else
							next_state = ExecuteI;
					end
					2'b10: begin // MEMORY
						next_state = MemAdr;
					end
					2'b11: begin // BRANCH
						if (B_type == 2'b00) // Branch
							next_state = Branch;
						if (B_type == 2'b01) // Branch with link
							next_state = BL;
						if (B_type == 2'b10) // Branch indirect
							next_state = BI_MemAdr;
						if (B_type == 2'b11) // B with Conditions
							next_state = BranchWithCondition;
					end
				endcase
			end
			
			ExecuteR: begin
				if (OP == 2'b00 && CMD_00 == 2'b10) //CMP, do not write back
					next_state = Fetch;
				else
					next_state = ALUWB;
			end
			
			ExecuteI: begin
				if (OP == 2'b00 && CMD_00 == 2'b10) //CMP, do not write back
					next_state = Fetch;
				else
					next_state = ALUWB;
			end
			
			ALUWB: begin
				next_state = Fetch;
			end
			
			MemAdr: begin
				if (Instr[13] == 1)
					next_state = MemRead;
				if (Instr[13] == 0)
					next_state = MemW;
			end
			
			MemRead: begin
				next_state = MemWB;
			end
			
			MemW: begin
				next_state = Fetch;
			end
			
			MemWB: begin
				next_state = Fetch;
			end
			
			Branch: begin
				next_state = Fetch;
			end
			
			BL: begin
				next_state = Fetch;
			end
			
			BI_MemAdr: begin
				next_state = BI_MemRead;
			end
			
			BI_MemRead: begin
				next_state = BI_WritePC;
			end
			
			BI_WritePC: begin
				next_state = Fetch;
			end
			BranchWithCondition: begin
				next_state = Fetch;
			end
		endcase
	end

endmodule
