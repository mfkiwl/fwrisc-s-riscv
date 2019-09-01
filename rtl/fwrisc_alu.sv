/****************************************************************************
 * fwrisc_alu.sv
 * 
 * Copyright 2018 Matthew Ballance
 * 
 * Licensed under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in
 * compliance with the License.  You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in
 * writing, software distributed under the License is
 * distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 * CONDITIONS OF ANY KIND, either express or implied.  See
 * the License for the specific language governing
 * permissions and limitations under the License.
 * 
 ****************************************************************************/
 
`include "fwrisc_defines.vh"

/**
 * Module: fwrisc_alu
 * 
 * TODO: Add module documentation
 */
module fwrisc_alu (
		input					clock,
		input					reset,
		input[31:0]				op_a,
		input[31:0]				op_b,
		input[2:0]				op,
		output reg[31:0]		out,
		output 					carry,
		output					eqz);
	
	assign carry = ($signed(op_b) > $signed(op_a));
	assign eqz = (op_b == op_a);
	
	parameter [2:0] 
		OP_ADD = 3'd0,
		OP_SUB = (OP_ADD+3'd1),
		OP_AND = (OP_SUB+3'd1),
		OP_OR  = (OP_AND+3'd1),
		OP_CLR = (OP_OR+3'd1),
		OP_XOR = (OP_CLR+3'd1);
	
	always @* begin
		case (op) 
			OP_ADD:  out = op_a + op_b;
			OP_SUB:  out = op_a - op_b;
			OP_AND:  out = op_a & op_b;
			OP_OR:   out = op_a | op_b;
			OP_CLR:  out = op_a ^ (op_a & op_b); // Used for CSRC
			default /*OP_XOR */: out = op_a ^ op_b;
		endcase
	end

endmodule


