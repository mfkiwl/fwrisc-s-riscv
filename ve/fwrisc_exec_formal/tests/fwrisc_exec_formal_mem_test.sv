
`include "fwrisc_exec_formal_defines.svh"


module fwrisc_exec_formal_mem_test(
		input					clock,
		input					reset,
		output 					decode_valid,
		input	 				instr_complete,
		
		input[31:0]				pc,

		// Indicates whether the instruction is compressed
		output reg				instr_c,

		output reg[4:0]			op_type,
		
		output reg[31:0]		op_a,
		output reg[31:0]		op_b,
		output reg[5:0]			op,
		output reg[31:0]		op_c,
		output reg[5:0]			rd,

		input					dvalid,
		output reg[31:0]		drdata,
		output reg				dready
		);
	`include "fwrisc_op_type.svh"
	`include "fwrisc_mem_op.svh"
	
	reg[1:0]		dstate;
	wire[31:0]		drdata_w = `anyconst;
	
	always @(posedge clock) begin
		if (reset) begin
			dstate <= 0;
			dready <= 0;
		end else begin
			case (dstate)
				0: begin
					// Wait for a memory request
					if (dvalid) begin
						drdata <= drdata_w;
						dready <= 1;
						dstate <= 1;
					end
				end
				1: begin
					dstate <= 0;
					dready <= 0;
				end
			endcase
		end
	end

	reg[1:0]		state;
	reg				decode_valid_r;
	wire[31:0]		st_data = `anyconst;
	wire[31:0]		mem_base = `anyconst;
	wire[7:0]		mem_off = `anyconst;
	
	wire[5:0]		rd_w;
	assign rd_w[5] = 0;
	assign rd_w[4:0] = `anyconst;
	wire[3:0]		mem_op = `anyconst;
	
	assign decode_valid = (decode_valid_r && !instr_complete);
	
	always @(posedge clock) begin
		if (reset) begin
			state <= 0;
			instr_c <= 0;
			op_type <= OP_TYPE_LDST;
			op_a <= 0; 
			op_b <= 0; 
			op <= 0; 
			op_c <= 0; 
			rd <= 0;
			decode_valid_r <= 0;
		end else begin
			case (state)
				0: begin
					// Send out a new instruction
					decode_valid_r <= 1;
					state <= 1;

`ifdef FORMAL
					op <= (mem_op % OP_NUM_MEM);
					op_b <= st_data;
`else
					op <= 0;
					op_b <= 0;
`endif
					
					// Specify where the load is going
					rd <= rd_w;
					
					// Select base address and offset
					case (mem_op % OP_NUM_MEM)
						OP_LB, OP_LBU, OP_SB: begin
							op_a <= mem_base;
							op_c <= $signed(mem_off);
						end
						OP_LH, OP_SH: begin
							// Keep aligned
							op_a <= {mem_base[31:1], 1'b0};
							op_c <= $signed({mem_off, 1'b0});
						end
						OP_LW, OP_SW: begin
							// Keep aligned
							op_a <= {mem_base[31:2], 2'b0};
							op_c <= $signed({mem_off, 2'b0});
						end
					endcase
				end
				1: begin
					if (instr_complete) begin
						/*
						`cover(op == OP_LB);
						`cover(op == OP_LH);
						`cover(op == OP_LW);
						`cover(op == OP_LBU);
						`cover(op == OP_LHU);
						`cover(op == OP_SB);
						`cover(op == OP_SH);
						`cover(op == OP_SW);
						 */
						decode_valid_r <= 0;
						state <= 0;
					end
				end
			endcase
			
`ifdef FORMAL
			assert(s_eventually instr_complete);
`endif
		end
	end
	
	

endmodule