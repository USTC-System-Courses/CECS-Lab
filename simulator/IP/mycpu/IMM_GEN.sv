// imm_type
//   3'H1: I type
//   3'H2: S type
//   3'H3: B type
//   3'H4: U type
//   3'H5: J type
//   3'H6: I type, only for shift
//   else: output 32'H0

module
    IMM_GEN (
        input                   [31 : 0]        inst,
        input                   [2 : 0]         imm_type,

        output      reg         [31 : 0]        imm
    );

    always @(*) begin
        case(imm_type)
            3'H1:                                                                          // I type
                imm = {{20{inst[31]}}, inst[31 : 20]};
            3'H2:                                                                          // S type
                imm = {{20{inst[31]}}, inst[31 : 25], inst[11 : 7]};
            3'H3:                                                                          // B type
                imm = {{20{inst[31]}}, inst[7], inst[30 : 25], inst[11 : 8], 1'H0};
            3'H4:                                                                          // U type
                imm = {inst[31 : 12], 12'H0};
            3'H5:                                                                          // J type
                imm = {{12{inst[31]}}, inst[19 : 12], inst[20], inst[30 : 21], 1'H0};
            default:
                imm = 32'H0;
        endcase
    end

endmodule
