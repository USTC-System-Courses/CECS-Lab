module
    INST_DECODER (
        input                   [31 : 0]        inst,

        output      reg         [2 : 0]         imm_type,
        output                                  alu_src0_sel, alu_src1_sel,
        output      reg         [4 : 0]         alu_ctrl,
        output                  [2 : 0]         br_type,
        output                                  br_en, jal, jalr,
        output                                  rf_we,
        output      reg         [1 : 0]         rf_wd_sel,
        output                  [2 : 0]         dm_type,
        output                                  dm_we_raw,
        output                                  dm_re_raw
    );

    wire        [6 : 0]         opcode;
    wire        [2 : 0]         funct3;
    wire        [6 : 0]         funct7;
    assign opcode = inst[6 : 0];
    assign funct3 = inst[14 : 12];
    assign funct7 = inst[31 : 25];

    wire                        is_r_type, is_i_type, is_s_type, is_b_type, is_u_type, is_j_type;
    assign is_r_type = (opcode == 7'H33);
    assign is_i_type = (opcode == 7'H03 || opcode == 7'H13 || opcode == 7'H67 /* || opcode == 7'H73 */);
    assign is_s_type = (opcode == 7'H23);
    assign is_b_type = (opcode == 7'H63);
    assign is_u_type = (opcode == 7'H17 || opcode == 7'H37);
    assign is_j_type = (opcode == 7'H6F);

    wire                        is_load, is_i_basic;
    assign is_load = (opcode == 7'H03);
    assign is_i_basic = (opcode == 7'H13);

    wire is_jalr, is_auipc, is_lui;
    assign is_jalr = (opcode == 7'H67);
    assign is_auipc = (opcode == 7'H17);
    assign is_lui = (opcode == 7'H37);

    always @(*) begin
        imm_type = 3'H0;
        if(is_i_type) imm_type = 3'H1;
        if(is_s_type) imm_type = 3'H2;
        if(is_b_type) imm_type = 3'H3;
        if(is_u_type) imm_type = 3'H4;
        if(is_j_type) imm_type = 3'H5;
    end

    always @(*) begin
        alu_ctrl = 5'B00000;
        if(is_lui) alu_ctrl = 5'B11000;
        if(is_r_type) alu_ctrl = {funct7[5], funct7[0], funct3};
        if(is_i_basic) alu_ctrl = {2'H0, funct3};
        if(is_i_basic && funct3 == 3'H5 && funct7 == 7'H20) alu_ctrl = 5'B10101;    // srai
    end

    always @(*) begin
        rf_wd_sel = 2'H0;
        if(is_j_type || is_jalr) rf_wd_sel = 2'H1;
        if(is_load) rf_wd_sel = 2'H2;
    end

    assign alu_src0_sel = (is_auipc || is_j_type || is_b_type);
    assign alu_src1_sel = (is_i_type || is_s_type || is_b_type || is_u_type || is_j_type);
    assign br_type = funct3;
    assign br_en = is_b_type;
    assign jal = is_j_type;
    assign jalr = is_jalr;
    assign rf_we = (is_u_type || is_j_type || is_i_type || is_r_type);
    assign dm_type = funct3;
    assign dm_we_raw = is_s_type;
    assign dm_re_raw = is_load;

endmodule