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
         $op[1:0]    = $rand2[3:2];  // Somehow, using another rng doesn't generate the Diagram
         
      ?$valid_or_reset
         @1 
            $sum[31:0]  = $val1 + $val2;
            $diff[31:0] = $val1 - $val2;
            $prod[31:0] = $val1 * $val2;
            $quot[31:0] = $val1 / $val2;
         @2
            $out[31:0] = $reset ? 32'b0
                                : ($op[1:0] == 2'b00) ? $sum
                                : ($op[1:0] == 2'b01) ? $diff
                                : ($op[1:0] == 2'b10) ? $prod
                                : ($op[1:0] == 2'b11) ? $quot
                                : 0;

   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
endmodule

