\m4_TLV_version 1d -p verilog --bestsv --noline: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/master/tlv_lib/risc-v_shell_lib.tlv'])
   //m4_include_lib(['https://raw.githubusercontent.com/BalaDhinesh/RISC-V_MYTH_Workshop/master/tlv_lib/risc-v_shell_lib.tlv'])
                   

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV

   // /====================\
   // | Sum 1 to 9 Program |
   // \====================/
   //
   // Program for MYTH Workshop to test RV32I
   // Add 1,2,3,...,9 (in that order).
   //
   // Regs:
   //  r10 (a0): In: 0, Out: final sum
   //  r12 (a2): 10
   //  r13 (a3): 1..10
   //  r14 (a4): Sum
   // 
   // External to function:
   m4_asm(ADD,  r10,  r0,  r0)             // Initialize r10 (a0) to 0.
   // Function:
   m4_asm(ADD,  r14, r10,  r0)            // Initialize sum register a4 with 0x0
   m4_asm(ADDI, r12, r10, 1010)         // Store count of 10 in register a2.
   m4_asm(ADD,  r13, r10,  r0)            // Initialize intermediate sum register a3 with 0
   // Loop:
   m4_asm(ADD,  r14, r13, r14)           // Incremental addition
   m4_asm(ADDI, r13, r13, 1)            // Increment intermediate register by 1
   m4_asm(BLT,  r13, r12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   m4_asm(ADD,  r10, r14, r0)            // Store final result to register a0 so that it can be read by main program
   
   m4_asm(SW, r0, r10, 10000)
   m4_asm(LW, r15, r0, 10000)
   
   // Optional:
   // m4_asm(JAL, r7, 00000000000000000000) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   m4_define_hier(['M4_IMEM'], M4_NUM_INSTRS)

   |cpu
      @0
         $reset = *reset;
         
         // PC logic
         // Use the previous $br_tgt_pc if the branch was taken in the previous instruction
         $pc[31:0] = >>1$reset ? 32'b0 :
                     >>3$valid_taken_br ? >>3$br_tgt_pc :
                     (>>3$valid_jump && >>3$is_jal) ? >>3$br_tgt_pc :
                     (>>3$valid_jump && >>3$is_jalr) ? >>3$jalr_tgt_pc :
                     >>3$valid_load ? >>3$inc_pc :
                     >>1$inc_pc;
         
         // IMEM Enable, ReadAddress port connections:
         // Assuming IMEM is DWORD-addressable, align the PC with the IMEM Read address port
         // Essentially, PC[1:0] = 2'b0. Hence, we can make the connection as follows:
         $imem_rd_en = !$reset;
         $imem_rd_addr[M4_IMEM_INDEX_CNT-1:0] = $pc[M4_IMEM_INDEX_CNT+1:2];
         
         // Start signal pulses for 1 cycle immediately after reset deassertion
         $start = >>1$reset && !$reset;
         
         // Valid signal is a 3-Cycle valid corresponding to the 3-stage pipeline we are 
         // implementing. Following reset deassertion, toggles as follows: 100100100...
         //$valid = $reset ? 1'b0 :
         //                  $start ? 1'b1 : >>3$valid;
      @1
         // Increment PC by 1 instruction length (fixed 4 bytes) every cycle
         $inc_pc[31:0] = $pc + 32'd4;
         
         // INSTRUCTION FETCH
         $instr[31:0] = $imem_rd_data[31:0];
         
         // INSTRUCTION-TYPE DECODE:
         // $instr[1:0] = 2'b11 for RV32I Base
         // Register
         $is_r_instr = ($instr[6:2] == 5'b01011) ||
                       ($instr[6:2] ==? 5'b011x0) ||
                       ($instr[6:2] == 5'b10100);
         
         // Immediate
         $is_i_instr = ($instr[6:2] ==? 5'b0000x) ||
                       ($instr[6:2] ==? 5'b001x0) ||
                       ($instr[6:2] == 5'b11001);
         
         // Store
         $is_s_instr = ($instr[6:2] ==? 5'b0100x);
         
         // Branch
         $is_b_instr = ($instr[6:2] == 5'b11000);
         
         // Upper Immediate
         $is_u_instr = ($instr[6:2] ==? 5'b0x101);
         
         // Jump
         $is_j_instr = ($instr[6:2] == 5'b11011);
         
         // IMMEDIATE VALUE DECODE
         $imm[31:0] = $is_i_instr ? {{21{$instr[31]}}, $instr[30:20]} :
                      $is_s_instr ? {{21{$instr[31]}}, $instr[30:25], $instr[11:7]} :
                      $is_b_instr ? {{20{$instr[31]}}, $instr[7], $instr[30:25], $instr[11:8], 1'b0} :
                      $is_u_instr ? {$instr[31:12], 12'b0} :
                      $is_j_instr ? {{12{$instr[31]}}, $instr[19:12], $instr[20], $instr[30:21], 1'b0} :
                      32'b0;
         
         // INSTRUCTION DECODING
         $opcode[6:0] = $instr[6:0];
         
         $rd_valid     = $is_r_instr | $is_i_instr | $is_u_instr | $is_j_instr;
         $funct3_valid = $is_r_instr | $is_i_instr | $is_s_instr | $is_b_instr;
         $rs1_valid    = $is_r_instr | $is_i_instr | $is_s_instr | $is_b_instr;
         $rs2_valid    = $is_r_instr | $is_s_instr | $is_b_instr;
         $funct7_valid = $is_r_instr;
         
         ?$rd_valid
            $rd[4:0]     = $instr[11:7];
         ?$funct3_valid
            $funct3[2:0] = $instr[14:12];
         ?$rs1_valid
            $rs1[4:0]    = $instr[19:15];
         ?$rs2_valid
            $rs2[4:0]    = $instr[24:20];
         ?$funct7_valid
            $funct7[6:0] = $instr[31:25];
         
         // Decode the individual instructions
         $dec_bits[10:0] = {$funct7[5], $funct3[2:0], $opcode[6:0]};
         
         $is_lui   = ($dec_bits ==? 11'bx_xxx_0110111);
         $is_auipc = ($dec_bits ==? 11'bx_xxx_0010111);
         $is_jal   = ($dec_bits ==? 11'bx_xxx_1101111);
         $is_jalr  = ($dec_bits ==? 11'bx_000_1100111);
         
         $is_beq  = ($dec_bits ==? 11'bx_000_1100011);
         $is_bne  = ($dec_bits ==? 11'bx_001_1100011);
         $is_blt  = ($dec_bits ==? 11'bx_100_1100011);
         $is_bge  = ($dec_bits ==? 11'bx_101_1100011);
         $is_bltu = ($dec_bits ==? 11'bx_110_1100011);
         $is_bgeu = ($dec_bits ==? 11'bx_111_1100011);
         
         $is_load = ($opcode == 7'b0000011);    // All load instructions are treated the same
         
         $is_sb = ($dec_bits ==? 11'bx_000_0100011);
         $is_sh = ($dec_bits ==? 11'bx_001_0100011);
         $is_sw = ($dec_bits ==? 11'bx_010_0100011);
         
         $is_addi  = ($dec_bits ==? 11'bx_000_0010011);
         $is_slti  = ($dec_bits ==? 11'bx_010_0010011);
         $is_sltiu = ($dec_bits ==? 11'bx_011_0010011);
         $is_xori  = ($dec_bits ==? 11'bx_100_0010011);
         $is_ori   = ($dec_bits ==? 11'bx_110_0010011);
         $is_andi  = ($dec_bits ==? 11'bx_111_0010011);
         $is_slli  = ($dec_bits ==? 11'b0_001_0010011);
         $is_srli  = ($dec_bits ==? 11'b0_101_0010011);
         $is_srai  = ($dec_bits ==? 11'b1_101_0010011);
         $is_add   = ($dec_bits ==? 11'b0_000_0110011);
         $is_sub   = ($dec_bits ==? 11'b1_000_0110011);
         $is_sll   = ($dec_bits ==? 11'b0_001_0110011);
         $is_slt   = ($dec_bits ==? 11'b0_010_0110011);
         $is_sltu  = ($dec_bits ==? 11'b0_011_0110011);
         $is_xor   = ($dec_bits ==? 11'b0_100_0110011);
         $is_srl   = ($dec_bits ==? 11'b0_101_0110011);
         $is_sra   = ($dec_bits ==? 11'b1_101_0110011);
         $is_or    = ($dec_bits ==? 11'b0_110_0110011);
         $is_and   = ($dec_bits ==? 11'b0_111_0110011);
         
         $is_jump = ($is_jal || $is_jalr);
         
         `BOGUS_USE($is_beq $is_bne $is_blt $is_bge $is_bltu $is_bgeu $is_load $is_sb $is_sh $is_sw $is_addi
                    $is_slti $is_sltiu $is_xori $is_ori $is_andi $is_slli $is_srli $is_srai $is_add $is_sub
                    $is_sll $is_slt $is_sltu $is_xor $is_srl $is_sra $is_or $is_and);
         
      @2
         // Target PC for a branch instruction
         $br_tgt_pc[31:0] = $pc + $imm;
         
         // REGISTER FILE READ
         //$rf_reset = $reset;
         $rf_rd_en1 = $rs1_valid;
         $rf_rd_index1[4:0] = $rs1;
         $rf_rd_en2 = $rs2_valid;
         $rf_rd_index2[4:0] = $rs2;
         
         // Handling Read-After-Write Hazard
         $rs1_rd_after_wr_hazard = >>1$rf_wr_en && (>>1$rf_wr_index == $rf_rd_index1);
         $rs2_rd_after_wr_hazard = >>1$rf_wr_en && (>>1$rf_wr_index == $rf_rd_index2);
         
         $src1_value[31:0] = $rs1_rd_after_wr_hazard ? >>1$result :
                                                     $rf_rd_data1[31:0];
         $src2_value[31:0] = $rs2_rd_after_wr_hazard ? >>1$result :
                                                     $rf_rd_data2[31:0];
         
      @3
         // ALU
         // Intermediate result signals for SLT, SLTI instructions
         $sltu_rslt[31:0]   = ($src1_value < $src2_value);
         $sltiu_rslt[31:0]  = ($src1_value < $imm);
         
         $result[31:0] = $is_lui   ? $imm[31:0] :
                         $is_auipc ? ($pc + $imm) :
                         $is_jal   ? ($pc + 32'd4) :
                         $is_jalr  ? ($pc + 32'd4) :
                         ($is_load || $is_s_instr) ? ($src1_value + $imm) :
                         $is_sll   ? ($src1_value << $src2_value[4:0]) :
                         $is_slli  ? ($src1_value << $imm[5:0]) :
                         $is_srl   ? ($src1_value >> $src2_value[4:0]) :
                         $is_srli  ? ($src1_value >> $imm[5:0]) :
                         $is_sra   ? ({{32{$src1_value[31]}}, $src1_value} >> $src2_value[4:0]) :
                         $is_srai  ? ({{32{$src1_value[31]}}, $src1_value} >> $imm[4:0]) :
                         $is_add   ? ($src1_value + $src2_value) :
                         $is_addi  ? ($src1_value + $imm) :
                         $is_sub   ? ($src1_value - $src2_value) :
                         $is_xor   ? ($src1_value ^ $src2_value) :
                         $is_xori  ? ($src1_value ^ $imm) :
                         $is_and   ? ($src1_value & $src2_value) :
                         $is_andi  ? ($src1_value & $imm) :
                         $is_or    ? ($src1_value | $src2_value) :
                         $is_ori   ? ($src1_value | $imm) :
                         $is_slt   ? ($src1_value[31] == $src2_value[31]) ? $sltu_rslt : {31'b0, $src1_value[31]} :
                         $is_slti  ? ($src1_value[31] == $imm[31]) ? $sltiu_rslt : {31'b0, $src1_value[31]} :
                         $is_sltu  ? ($src1_value < $src2_value) :
                         $is_sltiu ? ($src1_value < $imm) :
                         32'bx;
         
         // BRANCH INSTRNS.
         $taken_br = $is_beq  ? ($src1_value == $src2_value) :
                     $is_bne  ? ($src1_value != $src2_value) :
                     $is_bltu ? ($src1_value <  $src2_value) :
                     $is_bgeu ? ($src1_value >= $src2_value) :
                     $is_blt  ? ($src1_value < $src2_value) ^ ($src1_value[31] != $src2_value[31]) :
                     $is_bge  ? ($src1_value >= $src2_value) ^ ($src1_value[31] != $src2_value[31]) :
                     1'b0;
         
         // Valid signals to handle flow hazards due to branches and loads
         $valid_taken_br = ($taken_br && $valid);
         $valid_load = ($is_load && $valid);
         $valid_jump = ($is_jump && $valid);
         
         // JALR Target PC
         $jalr_tgt_pc[31:0] = $src1_value + $imm ;
         
         // Assert valid only if, in the previous two instructions:
         //   - a branch was not taken
         //   - were not load instructions
         //   - were not jump instructions
         $valid = !(>>1$valid_taken_br || >>2$valid_taken_br ||
                    >>1$valid_load || >>2$valid_load ||
                    >>1$valid_jump || >>2$valid_jump);
         
         // REGISTER FILE WRITE
         $rf_wr_en = ($rd_valid && ($rd != 5'b0) && $valid) || >>2$valid_load;
         $rf_wr_index[4:0] = >>2$valid_load ? >>2$rd : $rd;
         $rf_wr_data[31:0] = >>2$valid_load ? >>2$ld_data : $result;
         
      @4
         // DMEM: Mini 1-R/W Memory
         //       16 entries, 32-bit wide
         $dmem_wr_en = ($is_s_instr && $valid);
         $dmem_rd_en = $is_load;
         $dmem_addr[3:0] = $result[5:2];
         $dmem_wr_data[31:0] = $src2_value;
         
      @5
         // Load data from DMEM to RF 2 cycles after valid_load is asserted
         $ld_data[31:0] = $dmem_rd_data;
         
         
      
   
   // Assert these to end simulation (before Makerchip cycle limit).
   //*passed = *cyc_cnt > 40;
   *passed = |cpu/xreg[15]>>5$value == (1+2+3+4+5+6+7+8+9);
   *failed = 1'b0;
   
   // Macro instantiations for:
   //  o instruction memory
   //  o register file
   //  o data memory
   //  o CPU visualization
   |cpu
      m4+imem(@1)    // Args: (read stage)
      m4+rf(@2, @3)  // Args: (read stage, write stage) - if equal, no register bypass is required
      m4+dmem(@4)    // Args: (read/write stage)

      // Note: Because of the magic we are using for visualisation, if visualisation is enabled below,
      //       be sure to avoid having unassigned signals (which you might be using for random inputs)
      //       other than those specifically expected in the labs. You'll get strange errors for these.
   m4+cpu_viz(@4)    // For visualisation, argument should be at least equal to the last stage of CPU logic. @4 would work for all labs.
\SV
   endmodule
