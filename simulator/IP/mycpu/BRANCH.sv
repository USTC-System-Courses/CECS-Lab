// br_type: (the same as opcode)
//   3'H0: beq
//   3'H1: bne
//   3'H4: blt
//   3'H5: bge
//   3'H6: bltu
//   3'H7: bgeu

module BRANCH (
        input                   [2 : 0]         br_type,
        input                                   br_en,
        input                   [31 : 0]        rf_rd0, rf_rd1,

        output      reg                         br
    );

    always @(*) begin
        case(br_type)
            3'H0:                                        // beq
                br = rf_rd0 == rf_rd1 && br_en;
            3'H1:                                        // bne
                br = rf_rd0 != rf_rd1 && br_en;
            3'H4:                                        // blt
                br = $signed(rf_rd0) < $signed(rf_rd1) && br_en;
            3'H5:                                        // bge
                br = $signed(rf_rd0) >= $signed(rf_rd1) && br_en;
            3'H6:                                        // bltu
                br = rf_rd0 < rf_rd1 && br_en;
            3'H7:                                        // bgeu
                br = rf_rd0 >= rf_rd1 && br_en;
            default:                                     // no branch
                br = 0;
        endcase
    end

endmodule
