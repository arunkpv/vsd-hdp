\m4_TLV_version 1d: tl-x.org
\SV

m4+definitions(['
  // Instruction field values for each instruction are defined as localparams and as M4 defines. Assembly uses one or the other
  // depending on m4_use_localparams.
  // Define localparam and M4_ define.
  // m4_define_localparam(<name>, <localparam-bit-range>, <value>)
  m4_define(['m4_define_localparam'],
            ['m4_define(['M4_$1'], $3)m4_ifelse(m4_use_localparams, 1, ['['localparam $2 $1 = $3;']'])'])
  // Use defined localparam or M4_ definition, depending on m4_use_localparams.
  m4_define(['m4_localparam_value'],
            ['m4_ifelse(m4_use_localparams, 1, [''], ['M4_'])$1'])

  // --------------------------------------
  // Associate each op5 value with an instruction type.
  // --------------------------------------

  // TODO:
  // We construct M4_OP5_XXXXX_TYPE, and verify each instruction against that.
  // Instruction fields are constructed and valid based on op5.
  //...
  // TO UPDATE:
  // We construct localparam INSTR_TYPE_X_MASK as a mask, one bit per op5 indicating whether the op5 is of the type.
  // Instantiated recursively for each instruction type.
  // Initializes m4_instr_type_X_mask_expr which will build up a mask, one bit per op5.
  m4_define(['m4_instr_types'],
            ['m4_ifelse(['$1'], [''], [''],
                        ['m4_define(['m4_instr_type_$1_mask_expr'], ['0'])m4_instr_types(m4_shift($@))'])'])
  // Instantiated recursively for each instruction type in \SV_plus context after characterizing each type.
  // Declares localparam INSTR_TYPE_X_MASK as m4_instr_type_X_mask_expr.
  m4_define(['m4_instr_types_sv'],
            ['m4_ifelse(['$1'], [''], [''],
                        ['m4_define_localparam(['INSTR_TYPE_$1_MASK'], ['[31:0]'], m4_instr_type_$1_mask_expr)m4_instr_types_sv(m4_shift($@))'])'])
  // Instantiated recursively for each instruction type in \SV_plus context to decode instruction type.
  // Creates "assign $$is_x_type = INSTR_TYPE_X_MASK[$raw_op5];" for each type.
  // TODO: Not sure how to extract a bit ($raw_op) from a constant expression. Hoping synthesis optimizes well.
  m4_define(['m4_types_decode'],
            ['m4_ifelse(['$1'], [''], [''],
                        ['['assign $$is_']m4_translit(['$1'], ['A-Z'], ['a-z'])['_type = (((']m4_localparam_value(['INSTR_TYPE_$1_MASK'])[') >> $raw_op5) & 32'b1) != 32'b0; ']m4_types_decode(m4_shift($@))'])'])
  // Instantiated for each op5 in \SV_plus context.
  m4_define(['m4_op5'],
            ['m4_define(['M4_OP5_$1_TYPE'], $2)m4_define_localparam(['OP5_$3'], ['[4:0]'], ['5'b$1'])m4_define(['m4_instr_type_$2_mask_expr'], m4_quote(m4_instr_type_$2_mask_expr)[' | (1 << 5'b$1)'])'])


  // --------------------------------
  // Characterize each instruction mnemonic
  // --------------------------------

  // Each instruction is defined by instantiating m4_instr(...), e.g.: 
  //    m4_instr(B, 32, I, 11000, 000, BEQ)
  // which instantiates an instruction-type-specific macro, e.g.:
  //    m4_instrB(32, I, 11000, 000, BEQ)
  // which produces (or defines macros for):
  //   o instruction decode logic ($is_<mnemonic>_instr = ...;)
  //   o for debug, an expression to produce the MNEMONIC.
  //   o result MUX expression to select result of the appropriate execution expression
  //   o $illegal_instruction expression
  //   o localparam definitions for fields
  //   o m4_asm(<MNEMONIC>, ...) to assemble instructions to their binary representations

  // Return 1 if the given instruction is supported, [''] otherwise.
  // m4_instr_supported(<args-of-m4_instr(...)>)
  m4_define(['m4_instr_supported'],
            ['m4_ifelse(M4_EXT_$3, 1,
                        ['m4_ifelse(M4_WORD_CNT, ['$2'], 1, [''])'],
                        [''])'])

  // Instantiated (in \SV_plus context) for each instruction.
  // m4_instr(<instr-type-char(s)>, <type-specific-args>)
  // This instantiates m4_instr<type>(type-specific-args>)
  m4_define_hide(['m4_instr'],
                 ['// check instr type

                   m4_ifelse(M4_OP5_$4_TYPE, m4_ifdef(['m4_instr_type_of_$1'], ['m4_instr_type_of_$1'], ['$1']), [''],
                             ['m4_errprint(['Instruction ']m4_argn($#, $@)[''s type ($1) is inconsistant with its op5 code ($4) of type ']M4_OP5_$4_TYPE[' on line ']m4___line__[' of file ']m4_FILE.m4_new_line)'])
                   // if instrs extension is supported and instr is for the right machine width, "
                   m4_ifelse(m4_instr_supported($@), 1,
                             ['m4_show(m4_define_localparam(m4_argn($#, $@)['_INSTR_OPCODE'], ['[6:0]'], ['7'b$4']['11'])['m4_instr$1(m4_shift($@))'])'],
                             [''])'])


  // Decode logic for instructions with various opcode/func bits that dictate the mnemonic.
  // (This would be easier if we could use 'x', but Yosys doesn't support ==?/!=? operators.)
  // Helpers to deal with "rm" cases:
  m4_define(['m4_op5_and_funct3'],
            ['$raw_op5 == 5'b$3 m4_ifelse($4, ['rm'], [''], ['&& $raw_funct3 == 3'b$4'])'])
  m4_define(['m4_funct3_localparam'],
            ['m4_ifelse(['$2'], ['rm'], ['YYYY'], ['m4_define_localparam(['$1_INSTR_FUNCT3'], ['[2:0]'], ['3'b$2'])'])'])
  // m4_asm_<MNEMONIC> output for funct3 or rm, returned in unquoted context so arg references can be produced. 'rm' is always the last m4_asm_<MNEMONIC> arg (m4_arg(#)).
  //   Args: $1: MNEMONIC, $2: funct3 field of instruction definition (or 'rm')
  m4_define(['m4_asm_funct3'], ['['m4_ifelse($2, ['rm'], ['3'b']m4_argn(']m4_arg(#)[', m4_echo(']m4_arg(@)[')), m4_localparam_value(['$1_INSTR_FUNCT3']))']'])
  // Opcode + funct3 + funct7 (R-type, R2-type). $@ as for m4_instrX(..), $7: MNEMONIC, $8: number of bits of leading bits of funct7 to interpret. If 5, for example, use the term funct5, $9: (opt) for R2, the r2 value.
  m4_define(['m4_instr_funct7'],
            ['m4_instr_decode_expr($7, m4_op5_and_funct3($@)[' && $raw_funct7'][6:m4_eval(7-$8)][' == $8'b$5']m4_ifelse($9, [''], [''], [' && $raw_rs2 == 5'b$9']))m4_funct3_localparam(['$7'], ['$4'])m4_define_localparam(['$7_INSTR_FUNCT$8'], ['[$8-1:0]'], ['$8'b$5'])'])
  // For cases w/ extra shamt bit that cuts into funct7.
  m4_define(['m4_instr_funct6'],
            ['m4_instr_decode_expr($7, m4_op5_and_funct3($@)[' && $raw_funct7[6:1] == 6'b$5'])m4_funct3_localparam(['$7'], ['$4'])m4_define_localparam(['$7_INSTR_FUNCT6'], ['[6:0]'], ['6'b$5'])'])
  // Opcode + funct3 + func7[1:0] (R4-type)
  m4_define(['m4_instr_funct2'],
            ['m4_instr_decode_expr($6, m4_op5_and_funct3($@)[' && $raw_funct7[1:0] == 2'b$5'])m4_funct3_localparam(['$6'], ['$4'])m4_define_localparam(['$6_INSTR_FUNCT2'], ['[1:0]'], ['2'b$5'])'])
  // Opcode + funct3 + funct7[6:2] (R-type where funct7 has two lower bits that do not distinguish mnemonic.)
  m4_define(['m4_instr_funct5'],
            ['m4_instr_decode_expr($6, m4_op5_and_funct3($@)[' && $raw_funct7[6:2] == 5'b$5'])m4_funct3_localparam(['$6'], ['$4'])m4_define_localparam(['$6_INSTR_FUNCT5'], ['[4:0]'], ['5'b$5'])'])
  // Opcode + funct3
  m4_define(['m4_instr_funct3'],
            ['m4_instr_decode_expr($5, m4_op5_and_funct3($@), $6)m4_funct3_localparam(['$5'], ['$4'])'])
  // Opcode
  m4_define(['m4_instr_no_func'],
            ['m4_instr_decode_expr($4, ['$raw_op5 == 5'b$3'])'])

  // m4_instr_decode_expr macro
  // Args: (MNEMONIC, decode_expr, (opt)['no_dest']/other)
  // Extends the following definitions to reflect the given instruction <mnemonic>:
  m4_define(['m4_decode_expr'], [''])          // instructiton decode: $is_<mnemonic>_instr = ...; ...
  m4_define(['m4_rslt_mux_expr'], [''])        // result combining expr.: ({32{$is_<mnemonic>_instr}} & $<mnemonic>_rslt) | ...
  m4_define(['m4_illegal_instr_expr'], [''])   // $illegal instruction exception expr: && ! $is_<mnemonic>_instr ...
  m4_define(['m4_mnemonic_expr'], [''])        // $is_<mnemonic>_instr ? "<MNEMONIC>" : ...
  m4_define_hide(
     ['m4_instr_decode_expr'],
     ['m4_define(
          ['m4_decode_expr'],
          m4_dquote(m4_decode_expr['$is_']m4_translit($1, ['A-Z'], ['a-z'])['_instr = $2;m4_plus_new_line   ']))
       m4_ifelse(['$3'], ['no_dest'],
          [''],
          ['m4_define(
             ['m4_rslt_mux_expr'],
             m4_dquote(m4_rslt_mux_expr[' |']['m4_plus_new_line       ({']M4_WORD_CNT['{$is_']m4_translit($1, ['A-Z'], ['a-z'])['_instr}} & $']m4_translit($1, ['A-Z'], ['a-z'])['_rslt)']))'])
       m4_define(
          ['m4_illegal_instr_expr'],
          m4_dquote(m4_illegal_instr_expr[' && ! $is_']m4_translit($1, ['A-Z'], ['a-z'])['_instr']))
       m4_define(
          ['m4_mnemonic_expr'],
          m4_dquote(m4_mnemonic_expr['$is_']m4_translit($1, ['A-Z'], ['a-z'])['_instr ? "$1']m4_substr(['          '], m4_len(['$1']))['" : ']))'])

  // The first arg of m4_instr(..) is a type, and a type-specific macro is invoked. Types are those defined by RISC-V, plus:
  //   R2: R-type with a hard-coded rs2 value. (assuming illegal instruction exception should be thrown for wrong value--not clear in RISC-V spec)
  //   If: I-type with leading bits of imm[11:...] used as function bits.

  m4_define(['m4_instr_type_of_R2'], ['R'])
  m4_define(['m4_instr_type_of_If'], ['I'])
  // Unique to each instruction type, eg:
  //   m4_instr(U, 32, I, 01101,      LUI)
  //   m4_instr(J, 32, I, 11011,      JAL)
  //   m4_instr(B, 32, I, 11000, 000, BEQ)
  //   m4_instr(S, 32, I, 01000, 000, SB)
  //   m4_instr(I, 32, I, 00100, 000, ADDI)
  //   m4_instr(If, 64, I, 00100, 101, 000000, SRLI)  // (imm[11:6] are used like funct7[6:1] and must be 000000)
  //   m4_instr(R, 32, I, 01100, 000, 0000000, ADD)
  //   m4_instr(R4, 32, F, 10000, rm, 10, FMADD.D)
  //   m4_instr(R2, 32, F, 10100, rm, 0101100, 00000, FSQRT.S)
  //   m4_instr(R2, 32, A, 01011, 010, 00010, 00000, LR.W)  // (5 bits for funct7 for all "A"-ext instrs)
  //   m4_instr(R, 32, A, 01011, 010, 00011, SC.W)          //   "
  // This defines assembler macros as follows. Fields are ordered rd, rs1, rs2, imm:
  //   I: m4_asm_ADDI(r4, r1, 0),
  //   R: m4_asm_ADD(r4, r1, r2),
  //   R2: m4_asm_FSQRT.S(r4, r1, 000),  // rm == 000
  //   R4: m4_asm_FMADD.S(r4, r1, r2, r3, 000),  // rm == 000
  //   S: m4_asm_SW(r1, r2, 100),  // Store r13 into [r10] + 4
  //   B: m4_asm_BLT(r1, r2, 1000), // Branch if r1 < r2 to PC + 13'b1000 (where lsb = 0)
  //   For "A"-extension instructions, an additional final arg is REQUIRED to provide 2 binary bits for aq and rl.
  // Macro definitions include 2 parts:
  //   o Hardware definitions: m4_instr_<mnemonic>($@)
  //   o Assembler definition of m4_asm_<MNEMONIC>: m4_define(['m4_asm_<MNEMONIC>'], ['m4_asm_instr_str(...)'])
  m4_define(['m4_instrI'], ['m4_instr_funct3($@)m4_define(['m4_asm_$5'],
       ['m4_asm_instr_str(I, ['$5'], $']['@){12'b']m4_arg(3)[', m4_asm_reg(']m4_arg(2)['), m4_localparam_value(['$5_INSTR_FUNCT3']), m4_asm_reg(']m4_arg(1)['), ']m4_localparam_value($5_INSTR_OPCODE)['}'])'])
  m4_define(['m4_instrIf'], ['m4_instr_funct7($@, ['$6'], m4_len($5))m4_define(['m4_asm_$6'],
       ['m4_asm_instr_str(I, ['$6'], $']['@){m4_localparam_value(['$6_INSTR_FUNCT']m4_len($5))[', ']m4_eval(12-m4_len($5))'b']m4_arg(3)[', m4_asm_reg(']m4_arg(2)['), m4_localparam_value(['$6_INSTR_FUNCT3']), m4_asm_reg(']m4_arg(1)['), ']m4_localparam_value($6_INSTR_OPCODE)['}'])'])
  m4_define(['m4_instrR'], ['m4_instr_funct7($@, ['$6'], m4_ifelse($2, ['A'], 5, 7))m4_define(['m4_asm_$6'],
       ['m4_asm_instr_str(R, ['$6'], $']['@){m4_ifelse($2, ['A'], ['m4_localparam_value(['$6_INSTR_FUNCT5']), ']']m4_arg(2)['[''], m4_localparam_value(['$6_INSTR_FUNCT7'])), m4_asm_reg(']m4_arg(3)['), m4_asm_reg(']m4_arg(2)['), ']m4_asm_funct3(['$6'], ['$4'])[', m4_asm_reg(']m4_arg(1)['), ']m4_localparam_value($6_INSTR_OPCODE)['}'])'])
  m4_define(['m4_instrR2'], ['m4_instr_funct7($@, 7, ['$6'])m4_define(['m4_asm_$7'],
       ['m4_asm_instr_str(R, ['$7'], $']['@){m4_ifelse($2, ['A'], ['m4_localparam_value(['$7_INSTR_FUNCT5']), ']']m4_arg(2)['[''], m4_localparam_value(['$7_INSTR_FUNCT7'])), 5'b$6, m4_asm_reg(']m4_arg(2)['), ']m4_asm_funct3(['$7'], ['$4'])[', m4_asm_reg(']m4_arg(1)['), ']m4_localparam_value($7_INSTR_OPCODE)['}'])'])
  m4_define(['m4_instrR4'], ['m4_instr_funct2($@)m4_define(['m4_asm_$6'],
       ['m4_asm_instr_str(R, ['$6'], $']['@){m4_asm_reg(']m4_arg(4)['), m4_localparam_value(['$6_INSTR_FUNCT2']), m4_asm_reg(']m4_arg(3)['), m4_asm_reg(']m4_arg(2)['), ']m4_asm_funct3(['$6'], ['$4'])[', m4_asm_reg(']m4_arg(1)['), ']m4_localparam_value($6_INSTR_OPCODE)['}'])'])
  m4_define(['m4_instrS'], ['m4_instr_funct3($@, ['no_dest'])m4_define(['m4_asm_$5'],
       ['m4_asm_instr_str(S, ['$5'], $']['@){m4_asm_imm_field(']m4_arg(3)[', 12, 11, 5), m4_asm_reg(']m4_arg(2)['), m4_asm_reg(']m4_arg(1)['), ']m4_asm_funct3(['$5'], ['$4'])[', m4_asm_imm_field(']m4_arg(3)[', 12, 4, 0), ']m4_localparam_value($5_INSTR_OPCODE)['}'])'])
  m4_define(['m4_instrB'], ['m4_instr_funct3($@, ['no_dest'])m4_define(['m4_asm_$5'],
       ['m4_asm_instr_str(B, ['$5'], $']['@){m4_asm_imm_field(']m4_arg(3)[', 13, 12, 12), m4_asm_imm_field(']m4_arg(3)[', 13, 10, 5), m4_asm_reg(']m4_arg(2)['), m4_asm_reg(']m4_arg(1)['), ']m4_asm_funct3(['$5'], ['$4'])[', m4_asm_imm_field(']m4_arg(3)[', 13, 4, 1), m4_asm_imm_field(']m4_arg(3)[', 13, 11, 11), ']m4_localparam_value($5_INSTR_OPCODE)['}'])'])
  m4_define(['m4_instrU'], ['m4_instr_no_func($@)m4_define(['m4_asm_$4'],
       ['m4_asm_instr_str(U, ['$4'], $']['@){m4_asm_imm_field(']m4_arg(2)[', 20, 19, 0), m4_asm_reg(']m4_arg(1)['), ']m4_localparam_value($4_INSTR_OPCODE)['}'])'])
  m4_define(['m4_instrJ'], ['m4_instr_no_func($@)m4_define(['m4_asm_$4'],
       ['m4_asm_instr_str(J, ['$4'], $']['@){m4_asm_imm_field(']m4_arg(2)[', 20, 19, 19), m4_asm_imm_field(']m4_arg(2)[', 20, 9, 0), m4_asm_imm_field(']m4_arg(2)[', 20, 10, 10), m4_asm_imm_field(']m4_arg(2)[', 20, 18, 11), m4_asm_reg(']m4_arg(1)['), ']m4_localparam_value($4_INSTR_OPCODE)['}'])'])
  m4_define(['m4_instr_'], ['m4_instr_no_func($@)'])

  // For each instruction type.
  // Declare localparam[31:0] INSTR_TYPE_X_MASK, initialized to 0 that will be given a 1 bit for each op5 value of its type.
  m4_define(['m4_instr_types_args'], ['I, R, R2, R4, S, B, J, U, _'])
  m4_instr_types(m4_instr_types_args)


  // Instruction fields (User ISA Manual 2.2, Fig. 2.2)
  m4_define_fields(['M4_INSTR'], 32, FUNCT7, 25, RS2, 20, RS1, 15, FUNCT3, 12, RD, 7, OP5, 2, OP2, 0)


  //=========
  // Specifically for assembler.

  // An 20-bit immediate binary zero string.
  m4_define(['m4_asm_imm_zero'], ['00000000000000000000'])
  // Zero-extend to n bits. E.g. m4_asm_zero_ext(1001, 7) => 0001001
  m4_define(['m4_asm_zero_ext'], ['m4_substr(m4_asm_imm_zero, 0, m4_eval($2 - m4_len($1)))$1'])
  // Extract bits from a binary immediate value.
  // m4_asm_imm_field(binary-imm, imm-length, max-bit, min-bit)
  // E.g. m4_asm_imm_field(101011, 17, 7, 3) => 5'b00101
  m4_define(['m4_asm_imm_field'], ['m4_eval($3 - $4 + 1)'b['']m4_substr(m4_asm_zero_ext($1, $2), m4_eval($2 - $3 - 1), m4_eval($3 - $4 + 1))'])
  // Register operand.
  m4_define(['m4_asm_reg'], ['m4_ifelse(m4_substr(['$1'], 0, 1), ['r'], [''], ['m4_errprint(['$1 passed to register field.'])'])5'd['']m4_substr(['$1'], 1)'])

  // For debug, a string for an asm instruction.
  m4_define(['m4_asm_mem_expr'], [''])
  // m4_asm_instr_str(<type>, <mnemonic>, <m4_asm-args>)
  m4_define(['m4_asm_instr_str'], ['m4_pushdef(['m4_str'], ['($1) $2 m4_shift(m4_shift($@))'])m4_define(['m4_asm_mem_expr'],
                                                   m4_dquote(m4_asm_mem_expr[' "']m4_str['']m4_substr(['                                        '], m4_len(m4_quote(m4_str)))['", ']))m4_popdef(['m4_str'])'])
  // Assemble an instruction.
  // m4_asm(FOO, ...) defines m4_inst# as m4_asm_FOO(...), counts instructions in M4_NUM_INSTRS ,and outputs a comment.
  m4_define(['m4_asm'], ['m4_define(['m4_instr']M4_NUM_INSTRS, ['m4_asm_$1(m4_shift($@))'])['/']['/ Inst #']M4_NUM_INSTRS: $@m4_define(['M4_NUM_INSTRS'], m4_eval(M4_NUM_INSTRS + 1))'])

  //=========
'])
// M4-generated code.
\TLV riscv_gen()

   
   // v---------------------
   // Instruction characterization

   // M4 ugliness for instruction characterization.
   
   // For each opcode[6:2]
   // (User ISA Manual 2.2, Table 19.1)
   // Associate opcode[6:2] ([1:0] are 2'b11) with mnemonic and instruction type.
   // Instruction type is not in the table, but there seems to be a single instruction type for each of these,
   // so that is mapped here as well.
   // op5(bits, type, mnemonic)
   \SV_plus
      m4_op5(00000, I, LOAD)
      m4_op5(00001, I, LOAD_FP)
      m4_op5(00010, _, CUSTOM_0)
      m4_op5(00011, _, MISC_MEM)
      m4_op5(00100, I, OP_IMM)
      m4_op5(00101, U, AUIPC)
      m4_op5(00110, I, OP_IMM_32)
      m4_op5(00111, _, 48B1)
      m4_op5(01000, S, STORE)
      m4_op5(01001, S, STORE_FP)
      m4_op5(01010, _, CUSTOM_1)
      m4_op5(01011, R, AMO)  // (R-type, but rs2 = const for some, based on funct7 which doesn't exist for I-type?? R-type w/ ignored R2?)
      m4_op5(01100, R, OP)
      m4_op5(01101, U, LUI)
      m4_op5(01110, R, OP_32)
      m4_op5(01111, _, 64B)
      m4_op5(10000, R4, MADD)
      m4_op5(10001, R4, MSUB)
      m4_op5(10010, R4, NMSUB)
      m4_op5(10011, R4, NMADD)
      m4_op5(10100, R, OP_FP)  // (R-type, but rs2 = const for some, based on funct7 which doesn't exist for I-type?? R-type w/ ignored R2?)
      m4_op5(10101, _, RESERVED_1)
      m4_op5(10110, _, CUSTOM_2_RV128)
      m4_op5(10111, _, 48B2)
      m4_op5(11000, B, BRANCH)
      m4_op5(11001, I, JALR)
      m4_op5(11010, _, RESERVED_2)
      m4_op5(11011, J, JAL)
      m4_op5(11100, I, SYSTEM)
      m4_op5(11101, _, RESERVED_3)
      m4_op5(11110, _, CUSTOM_3_RV128)
      m4_op5(11111, _, 80B)
      
   \SV_plus
      m4_instr_types_sv(m4_instr_types_args)
      
   \SV_plus
      // Instruction characterization.
      // (User ISA Manual 2.2, Table 19.2)
      // instr(type,  // (this is simply verified vs. op5)
      //       |  bit-width,
      //       |  |   extension, 
      //       |  |   |  opcode[6:2],  // (aka op5)
      //       |  |   |  |      func3,   // (if applicable)
      //       |  |   |  |      |    mnemonic)
      m4_instr(U, 32, I, 01101,      LUI)
      m4_instr(U, 32, I, 00101,      AUIPC)
      m4_instr(J, 32, I, 11011,      JAL)
      m4_instr(I, 32, I, 11001, 000, JALR)
      m4_instr(B, 32, I, 11000, 000, BEQ)
      m4_instr(B, 32, I, 11000, 001, BNE)
      m4_instr(B, 32, I, 11000, 100, BLT)
      m4_instr(B, 32, I, 11000, 101, BGE)
      m4_instr(B, 32, I, 11000, 110, BLTU)
      m4_instr(B, 32, I, 11000, 111, BGEU)
      m4_instr(I, 32, I, 00000, 000, LB)
      m4_instr(I, 32, I, 00000, 001, LH)
      m4_instr(I, 32, I, 00000, 010, LW)
      m4_instr(I, 32, I, 00000, 100, LBU)
      m4_instr(I, 32, I, 00000, 101, LHU)
      m4_instr(S, 32, I, 01000, 000, SB)
      m4_instr(S, 32, I, 01000, 001, SH)
      m4_instr(S, 32, I, 01000, 010, SW)
      m4_instr(I, 32, I, 00100, 000, ADDI)
      m4_instr(I, 32, I, 00100, 010, SLTI)
      m4_instr(I, 32, I, 00100, 011, SLTIU)
      m4_instr(I, 32, I, 00100, 100, XORI)
      m4_instr(I, 32, I, 00100, 110, ORI)
      m4_instr(I, 32, I, 00100, 111, ANDI)
      m4_instr(If, 32, I, 00100, 001, 000000, SLLI)
      m4_instr(If, 32, I, 00100, 101, 000000, SRLI)
      m4_instr(If, 32, I, 00100, 101, 010000, SRAI)
      m4_instr(R, 32, I, 01100, 000, 0000000, ADD)
      m4_instr(R, 32, I, 01100, 000, 0100000, SUB)
      m4_instr(R, 32, I, 01100, 001, 0000000, SLL)
      m4_instr(R, 32, I, 01100, 010, 0000000, SLT)
      m4_instr(R, 32, I, 01100, 011, 0000000, SLTU)
      m4_instr(R, 32, I, 01100, 100, 0000000, XOR)
      m4_instr(R, 32, I, 01100, 101, 0000000, SRL)
      m4_instr(R, 32, I, 01100, 101, 0100000, SRA)
      m4_instr(R, 32, I, 01100, 110, 0000000, OR)
      m4_instr(R, 32, I, 01100, 111, 0000000, AND)
      //m4_instr(_, 32, I, 00011, 000, FENCE)
      //m4_instr(_, 32, I, 00011, 001, FENCE_I)
      //m4_instr(_, 32, I, 11100, 000, ECALL_EBREAK)  // Two instructions distinguished by an immediate bit, treated as a single instruction.
      m4_instr(I, 32, I, 11100, 001, CSRRW)
      m4_instr(I, 32, I, 11100, 010, CSRRS)
      m4_instr(I, 32, I, 11100, 011, CSRRC)
      m4_instr(I, 32, I, 11100, 101, CSRRWI)
      m4_instr(I, 32, I, 11100, 110, CSRRSI)
      m4_instr(I, 32, I, 11100, 111, CSRRCI)
      m4_instr(I, 64, I, 00000, 110, LWU)
      m4_instr(I, 64, I, 00000, 011, LD)
      m4_instr(S, 64, I, 01000, 011, SD)
      m4_instr(If, 64, I, 00100, 001, 000000, SLLI)
      m4_instr(If, 64, I, 00100, 101, 000000, SRLI)
      m4_instr(If, 64, I, 00100, 101, 010000, SRAI)
      m4_instr(I, 64, I, 00110, 000, ADDIW)
      m4_instr(If, 64, I, 00110, 001, 000000, SLLIW)
      m4_instr(If, 64, I, 00110, 101, 000000, SRLIW)
      m4_instr(If, 64, I, 00110, 101, 010000, SRAIW)
      m4_instr(R, 64, I, 01110, 000, 0000000, ADDW)
      m4_instr(R, 64, I, 01110, 000, 0100000, SUBW)
      m4_instr(R, 64, I, 01110, 001, 0000000, SLLW)
      m4_instr(R, 64, I, 01110, 101, 0000000, SRLW)
      m4_instr(R, 64, I, 01110, 101, 0100000, SRAW)
      m4_instr(R, 32, M, 01100, 000, 0000001, MUL)
      m4_instr(R, 32, M, 01100, 001, 0000001, MULH)
      m4_instr(R, 32, M, 01100, 010, 0000001, MULHSU)
      m4_instr(R, 32, M, 01100, 011, 0000001, MULHU)
      m4_instr(R, 32, M, 01100, 100, 0000001, DIV)
      m4_instr(R, 32, M, 01100, 101, 0000001, DIVU)
      m4_instr(R, 32, M, 01100, 110, 0000001, REM)
      m4_instr(R, 32, M, 01100, 111, 0000001, REMU)
      m4_instr(R, 64, M, 01110, 000, 0000001, MULW)
      m4_instr(R, 64, M, 01110, 100, 0000001, DIVW)
      m4_instr(R, 64, M, 01110, 101, 0000001, DIVUW)
      m4_instr(R, 64, M, 01110, 110, 0000001, REMW)
      m4_instr(R, 64, M, 01110, 111, 0000001, REMUW)
      m4_instr(I, 32, F, 00001, 010, FLW)
      m4_instr(S, 32, F, 01001, 010, FSW)
      m4_instr(R4, 32, F, 10000, rm, 00, FMADDS)
      m4_instr(R4, 32, F, 10001, rm, 00, FMSUBS)
      m4_instr(R4, 32, F, 10010, rm, 00, FNMSUBS)
      m4_instr(R4, 32, F, 10011, rm, 00, FNMADDS)
      m4_instr(R, 32, F, 10100, rm, 0000000, FADDS)
      m4_instr(R, 32, F, 10100, rm, 0000100, FSUBS)
      m4_instr(R, 32, F, 10100, rm, 0001000, FMULS)
      m4_instr(R, 32, F, 10100, rm, 0001100, FDIVS)
      m4_instr(R2, 32, F, 10100, rm, 0101100, 00000, FSQRTS)
      m4_instr(R, 32, F, 10100, 000, 0010000, FSGNJS)
      m4_instr(R, 32, F, 10100, 001, 0010000, FSGNJNS)
      m4_instr(R, 32, F, 10100, 010, 0010000, FSGNJXS)
      m4_instr(R, 32, F, 10100, 000, 0010100, FMINS)
      m4_instr(R, 32, F, 10100, 001, 0010100, FMAXS)
      m4_instr(R2, 32, F, 10100, rm, 1100000, 00000, FCVTWS)
      m4_instr(R2, 32, F, 10100, rm, 1100000, 00001, FCVTWUS)
      m4_instr(R2, 32, F, 10100, 000, 1110000, 00000, FMVXW)
      m4_instr(R, 32, F, 10100, 010, 1010000, FEQS)
      m4_instr(R, 32, F, 10100, 001, 1010000, FLTS)
      m4_instr(R, 32, F, 10100, 000, 1010000, FLES)
      m4_instr(R2, 32, F, 10100, 001, 1110000, 00000, FCLASSS)
      m4_instr(R2, 32, F, 10100, rm, 1101000, 00000, FCVTSW)
      m4_instr(R2, 32, F, 10100, rm, 1101000, 00001, FCVTSWU)
      m4_instr(R2, 32, F, 10100, 000, 1111000, 00000, FMVWX)
      m4_instr(R2, 64, F, 10100, rm, 1100000, 00010, FCVTLS)
      m4_instr(R2, 64, F, 10100, rm, 1100000, 00011, FCVTLUS)
      m4_instr(R2, 64, F, 10100, rm, 1101000, 00010, FCVTSL)
      m4_instr(R2, 64, F, 10100, rm, 1101000, 00011, FCVTSLU)
      m4_instr(I, 32, D, 00001, 011, FLD)
      m4_instr(S, 32, D, 01001, 011, FSD)
      m4_instr(R4, 32, D, 10000, rm, 01, FMADDD)
      m4_instr(R4, 32, D, 10001, rm, 01, FMSUBD)
      m4_instr(R4, 32, D, 10010, rm, 01, FNMSUBD)
      m4_instr(R4, 32, D, 10011, rm, 01, FNMADDD)
      m4_instr(R, 32, D, 10100, rm, 0000001, FADDD)
      m4_instr(R, 32, D, 10100, rm, 0000101, FSUBD)
      m4_instr(R, 32, D, 10100, rm, 0001001, FMULD)
      m4_instr(R, 32, D, 10100, rm, 0001101, FDIVD)
      m4_instr(R2, 32, D, 10100, rm, 0101101, 00000, FSQRTD)
      m4_instr(R, 32, D, 10100, 000, 0010001, FSGNJD)
      m4_instr(R, 32, D, 10100, 001, 0010001, FSGNJND)
      m4_instr(R, 32, D, 10100, 010, 0010001, FSGNJXD)
      m4_instr(R, 32, D, 10100, 000, 0010101, FMIND)
      m4_instr(R, 32, D, 10100, 001, 0010101, FMAXD)
      m4_instr(R2, 32, D, 10100, rm, 0100000, 00001, FCVTSD)
      m4_instr(R2, 32, D, 10100, rm, 0100001, 00000, FCVTDS)
      m4_instr(R, 32, D, 10100, 010, 1010001, FEQD)
      m4_instr(R, 32, D, 10100, 001, 1010001, FLTD)
      m4_instr(R, 32, D, 10100, 000, 1010001, FLED)
      m4_instr(R2, 32, D, 10100, 001, 1110001, 00000, FCLASSD)
      m4_instr(R2, 32, D, 10100, rm, 1110001, 00000, FCVTWD)
      m4_instr(R2, 32, D, 10100, rm, 1100001, 00001, FCVTWUD)
      m4_instr(R2, 32, D, 10100, rm, 1101001, 00000, FCVTDW)
      m4_instr(R2, 32, D, 10100, rm, 1101001, 00001, FCVTDWU)
      m4_instr(R2, 64, D, 10100, rm, 1100001, 00010, FCVTLD)
      m4_instr(R2, 64, D, 10100, rm, 1100001, 00011, FCVTLUD)
      m4_instr(R2, 64, D, 10100, 000, 1110001, 00000, FMVXD)
      m4_instr(R2, 64, D, 10100, rm, 1101001, 00010, FCVTDL)
      m4_instr(R2, 64, D, 10100, rm, 1101001, 00011, FCVTDLU)
      m4_instr(R2, 64, D, 10100, 000, 1111001, 00000, FMVDX)
      m4_instr(I, 32, Q, 00001, 100, FLQ)
      m4_instr(S, 32, Q, 01001, 100, FSQ)
      m4_instr(R4, 32, Q, 10000, rm, 11, FMADDQ)
      m4_instr(R4, 32, Q, 10001, rm, 11, FMSUBQ)
      m4_instr(R4, 32, Q, 10010, rm, 11, FNMSUBQ)
      m4_instr(R4, 32, Q, 10011, rm, 11, FNMADDQ)
      m4_instr(R, 32, Q, 10100, rm, 0000011, FADDQ)
      m4_instr(R, 32, Q, 10100, rm, 0000111, FSUBQ)
      m4_instr(R, 32, Q, 10100, rm, 0001011, FMULQ)
      m4_instr(R, 32, Q, 10100, rm, 0001111, FDIVQ)
      m4_instr(R2, 32, Q, 10100, rm, 0101111, 00000, FSQRTQ)
      m4_instr(R, 32, Q, 10100, 000, 0010011, FSGNJQ)
      m4_instr(R, 32, Q, 10100, 001, 0010011, FSGNJNQ)
      m4_instr(R, 32, Q, 10100, 010, 0010011, FSGNJXQ)
      m4_instr(R, 32, Q, 10100, 000, 0010111, FMINQ)
      m4_instr(R, 32, Q, 10100, 001, 0010111, FMAXQ)
      m4_instr(R2, 32, Q, 10100, rm, 0100000, 00011, FCVTSQ)
      m4_instr(R2, 32, Q, 10100, rm, 0100011, 00000, FCVTQS)
      m4_instr(R2, 32, Q, 10100, rm, 0100001, 00011, FCVTDQ)
      m4_instr(R2, 32, Q, 10100, rm, 0100011, 00001, FCVTQD)
      m4_instr(R, 32, Q, 10100, 010, 1010011, FEQQ)
      m4_instr(R, 32, Q, 10100, 001, 1010011, FLTQ)
      m4_instr(R, 32, Q, 10100, 000, 1010011, FLEQ)
      m4_instr(R2, 32, Q, 10100, 001, 1110011, 00000, FCLASSQ)
      m4_instr(R2, 32, Q, 10100, rm, 1110011, 00000, FCVTWQ)
      m4_instr(R2, 32, Q, 10100, rm, 1100011, 00001, FCVTWUQ)
      m4_instr(R2, 32, Q, 10100, rm, 1101011, 00000, FCVTQW)
      m4_instr(R2, 32, Q, 10100, rm, 1101011, 00001, FCVTQWU)
      m4_instr(R2, 64, Q, 10100, rm, 1100011, 00010, FCVTLQ)
      m4_instr(R2, 64, Q, 10100, rm, 1100011, 00011, FCVTLUQ)
      m4_instr(R2, 64, Q, 10100, rm, 1101011, 00010, FCVTQL)
      m4_instr(R2, 64, Q, 10100, rm, 1101011, 00011, FCVTQLU)
      m4_instr(R2, 32, A, 01011, 010, 00010, 00000, LRW)
      m4_instr(R, 32, A, 01011, 010, 00011, SCW)
      m4_instr(R, 32, A, 01011, 010, 00001, AMOSWAPW)
      m4_instr(R, 32, A, 01011, 010, 00000, AMOADDW)
      m4_instr(R, 32, A, 01011, 010, 00100, AMOXORW)
      m4_instr(R, 32, A, 01011, 010, 01100, AMOANDW)
      m4_instr(R, 32, A, 01011, 010, 01000, AMOORW)
      m4_instr(R, 32, A, 01011, 010, 10000, AMOMINW)
      m4_instr(R, 32, A, 01011, 010, 10100, AMOMAXW)
      m4_instr(R, 32, A, 01011, 010, 11000, AMOMINUW)
      m4_instr(R, 32, A, 01011, 010, 11100, AMOMAXUW)
      m4_instr(R2, 64, A, 01011, 011, 00010, 00000, LRD)
      m4_instr(R, 64, A, 01011, 011, 00011, SCD)
      m4_instr(R, 64, A, 01011, 011, 00001, AMOSWAPD)
      m4_instr(R, 64, A, 01011, 011, 00000, AMOADDD)
      m4_instr(R, 64, A, 01011, 011, 00100, AMOXORD)
      m4_instr(R, 64, A, 01011, 011, 01100, AMOANDD)
      m4_instr(R, 64, A, 01011, 011, 01000, AMOORD)
      m4_instr(R, 64, A, 01011, 011, 10000, AMOMIND)
      m4_instr(R, 64, A, 01011, 011, 10100, AMOMAXD)
      m4_instr(R, 64, A, 01011, 011, 11000, AMOMINUD)
      m4_instr(R, 64, A, 01011, 011, 11100, AMOMAXUD)
   // ^---------------------