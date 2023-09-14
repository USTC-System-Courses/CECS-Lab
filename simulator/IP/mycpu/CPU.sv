module
    CPU #(
        parameter PC_RST = 32'H80000000,
        parameter I_CACHE_DEPTH = 8,
        parameter D_CACHE_DEPTH = 8
    )
    (
        input                                   clk, rstn,
        output [31: 0] pc_cur, inst,
        output commit_wb, uncache_read_wb
`ifdef DEBUG
        ,
        output                                  putchar,
        output                  [7 : 0]         c
`endif
    );

    wire        [31 : 0]                        pc_next;//, pc_cur;
//    wire        [31 : 0]                        inst;
    wire        [2 : 0]                         imm_type;
    wire                                        alu_src0_sel, alu_src1_sel;
    wire        [4 : 0]                         alu_ctrl;
    wire        [2 : 0]                         br_type;
    wire                                        br_en, jal, jalr;
    wire                                        rf_we;
    wire        [1 : 0]                         rf_wd_sel;
    wire        [2 : 0]                         dm_type;
    wire                                        dm_we_raw;
    wire        [4 : 0]                         rf_ra0, rf_ra1, rf_wa;
    wire        [31 : 0]                        rf_wd;
    wire        [31 : 0]                        rf_rd0, rf_rd1;
    wire        [31 : 0]                        imm;
    wire        [31 : 0]                        alu_src0, alu_src1;
    wire        [31 : 0]                        alu_res;
    wire                                        br;
    wire        [31 : 0]                        pc_add4, pc_jal_br, pc_jalr;
    wire        [31 : 0]                        dm_rd_raw, dm_rd, dm_wd;
    wire        [31 : 0]         dm_addr;
    wire                                        dm_we, dm_re;
    wire [1:0] mask;    

    assign commit_wb = 1;
    assign uncache_read_wb = inst[6:0] == 7'b0000011 && alu_res[31:28] == 4'ha;
    PC #(
        .PC_RST(PC_RST)
    ) pc (
        .clk(clk),
        .rstn(rstn),
        .pc_next(pc_next),
        .pc_cur(pc_cur)
    );

    I_CACHE #(
        .DEPTH(I_CACHE_DEPTH)
    ) i_cache (
        .addr(pc_cur),
        .inst(inst)
    );

    INST_DECODER inst_decoder (
        .inst(inst),
        .imm_type(imm_type),
        .alu_src0_sel(alu_src0_sel),
        .alu_src1_sel(alu_src1_sel),
        .alu_ctrl(alu_ctrl),
        .br_type(br_type),
        .br_en(br_en),
        .jal(jal),
        .jalr(jalr),
        .rf_we(rf_we),
        .rf_wd_sel(rf_wd_sel),
        .dm_type(dm_type),
        .dm_we_raw(dm_we_raw),
        .dm_re_raw(dm_re)
    );

    assign rf_ra0 = inst[19 : 15];
    assign rf_ra1 = inst[24 : 20];
    assign rf_wa = inst[11 : 7];
    REG_FILE reg_file (
        .clk(clk),
        .rf_ra0(rf_ra0),
        .rf_ra1(rf_ra1),
        .rf_wa(rf_wa),
        .rf_we(rf_we),
        .rf_wd(rf_wd),
        .rf_rd0(rf_rd0),
        .rf_rd1(rf_rd1)
    );

    IMM_GEN imm_gen (
        .inst(inst),
        .imm_type(imm_type),
        .imm(imm)
    );

    MUX1 alu_sel0 (
        .src0(rf_rd0),
        .src1(pc_cur),
        .sel(alu_src0_sel),
        .res(alu_src0)
    );

    MUX1 alu_sel1 (
        .src0(rf_rd1),
        .src1(imm),
        .sel(alu_src1_sel),
        .res(alu_src1)
    );

    ALU alu (
        .alu_src0(alu_src0),
        .alu_src1(alu_src1),
        .alu_ctrl(alu_ctrl),
        .alu_res(alu_res)
    );

    BRANCH branch (
        .br_type(br_type),
        .br_en(br_en),
        .rf_rd0(rf_rd0),
        .rf_rd1(rf_rd1),
        .br(br)
    );

    assign pc_add4 = pc_cur + 32'H4;
    assign pc_jal_br = alu_res;
    assign pc_jalr = alu_res & 32'HFFFFFFFE;
    NPC_SEL npc_sel (
        .jal(jal),
        .jalr(jalr),
        .br(br),
        .pc_add4(pc_add4),
        .pc_jal_br(pc_jal_br),
        .pc_jalr(pc_jalr),
        .pc_next(pc_next)
    );

    D_CACHE_CTRL #(
        .DEPTH(D_CACHE_DEPTH)
    ) d_cache_ctrl (
        .addr_raw(alu_res),
        .wd_raw(rf_rd1),
        .rd_raw(dm_rd_raw),
        .we_raw(dm_we_raw),
        .dm_type(dm_type),
        .addr(dm_addr),
        .wd(dm_wd),
        .rd(dm_rd),
        .we(dm_we),
        .mask(mask)
    );

    D_CACHE #(
        .DEPTH(D_CACHE_DEPTH)
    ) d_cache (
        .clk(clk),
        .addr(dm_addr),
        .wd(dm_wd),
        .we(dm_we),
        .rd(dm_rd_raw),
        .re(dm_re),
        .mask(mask)
    );

    MUX2 rf_sel (
        .src0(alu_res),
        .src1(pc_add4),
        .src2(dm_rd),
        .src3(32'H0),
        .sel(rf_wd_sel),
        .res(rf_wd)
    );

`ifdef DEBUG
    assign putchar = dm_we_raw && (&dm_addr);
    assign c = rf_rd1[7 : 0];
`endif

endmodule