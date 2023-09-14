// alu_ctrl: {funct7[5], funct7[0], funct3}

module
    ALU (
        input                   [31 : 0]        alu_src0, alu_src1,
        input                   [4 : 0]         alu_ctrl,

        output      reg         [31 : 0]        alu_res
    );

    reg         [63 : 0]        mul_res;
    always @(*) begin
        mul_res = 64'H0;
        alu_res = 32'H0;
        case(alu_ctrl)
            5'B00000:                                                          // add
                alu_res = alu_src0 + alu_src1;
            5'B10000:                                                          // sub
                alu_res = alu_src0 - alu_src1;
            5'B00001:                                                          // sll
                alu_res = alu_src0 << alu_src1[4 : 0];
            5'B00010:                                                          // slt
                alu_res = {31'H0, $signed(alu_src0) < $signed(alu_src1)};
            5'B00011:                                                          // sltu
                alu_res = {31'H0, alu_src0 < alu_src1};
            5'B00100:                                                          // xor
                alu_res = alu_src0 ^ alu_src1;
            5'B00101:                                                          // srl
                alu_res = alu_src0 >> alu_src1[4 : 0];
            5'B10101:                                                          // sra
                alu_res = $signed(alu_src0) >>> alu_src1[4 : 0];
            5'B00110:                                                          // or
                alu_res = alu_src0 | alu_src1;
            5'B00111:                                                          // and
                alu_res = alu_src0 & alu_src1;
            5'B01000: begin                                                    // mul
                mul_res = alu_src0 * alu_src1;
                alu_res = mul_res[31: 0];
            end
            5'B01001: begin                                                    // mulh
                mul_res = $signed(alu_src0) * $signed(alu_src1);
                alu_res = mul_res[63: 32];
            end
            5'B01010: begin                                                    // mulhsu
                if(alu_src0 >= 32'H80000000) begin
                    mul_res = alu_src0 * alu_src1 - alu_src1 * 33'H100000000;
                end
                else begin
                    mul_res = alu_src0 * alu_src1;
                end
                alu_res = mul_res[63: 32];
            end
            5'B01011: begin                                                    // mulhu
                mul_res = alu_src0 * alu_src1;
                alu_res = mul_res[63: 32];
            end
            5'B01100: begin                                                    // div
                if(alu_src1 == 0) begin
                    alu_res = 32'HFFFFFFFF;
                end
                else if(alu_src0 == 32'H80000000 && alu_src1 == 32'HFFFFFFFF) begin
                    alu_res = 32'H80000000;
                end
                else begin
                    alu_res = $signed(alu_src0) / $signed(alu_src1);
                end
            end
            5'B01101: begin                                                    // divu
                if(alu_src1 == 0) begin
                    alu_res = 32'HFFFFFFFF;
                end
                else begin
                    alu_res = alu_src0 / alu_src1;
                end
            end
            5'B01110: begin                                                    // rem
                if(alu_src1 == 0) begin
                    alu_res = alu_src0;
                end
                else begin
                    alu_res = $signed(alu_src0) % $signed(alu_src1);
                end
            end
            5'B01111: begin                                                    // remu
                if(alu_src1 == 0) begin
                    alu_res = alu_src0;
                end
                else begin
                    alu_res = alu_src0 % alu_src1;
                end
            end
            5'B11000:                                                          // alu_src1
                alu_res = alu_src1;
            default: begin
                mul_res = 64'H0;
                alu_res = 32'H0;
            end
        endcase
    end

endmodule