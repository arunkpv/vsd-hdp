\m4_TLV_version 1d: tl-x.org
\SV
   m4_makerchip_module
\TLV
   //$reset = *reset;
   
   // 2-Cycle Calculator with Validity
   |calc
      @0
         $reset = *reset;
      @1 
         // 1-bit Counter used as a valid signal 
         $valid = $reset ? 1'b0 : (>>1$valid + 1'b1);
         $valid_or_reset = $valid | $reset;
         
         $val1[31:0] = >>2$out[31:0];
         $val2[31:0] = $rand2[3:0];
         $op[2:0]    = $rand2[3:1];  // Somehow, using another rng doesn't generate the Diagram
         
      ?$valid_or_reset
         @1 
            $sum[31:0]  = $val1 + $val2;
            $diff[31:0] = $val1 - $val2;
            $prod[31:0] = $val1 * $val2;
            $quot[31:0] = $val1 / $val2;
         @2
            $mem[31:0] = $reset ? 32'b0
                                : ($op[2:0] == 3'b101) ? $val1 : >>2$mem;
            
            $out[31:0] = $reset ? 32'b0
                                : ($op[2:0] == 3'b000) ? $sum
                                : ($op[2:0] == 3'b001) ? $diff
                                : ($op[2:0] == 3'b010) ? $prod
                                : ($op[2:0] == 3'b011) ? $quot
                                : ($op[2:0] == 3'b100) ? >>2$mem
                                : >>2$out;
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
endmodule

