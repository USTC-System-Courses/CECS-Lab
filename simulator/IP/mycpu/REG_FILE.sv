module
    REG_FILE (
        input                                   clk,

        input                   [4 : 0]         rf_ra0, rf_ra1, rf_wa,
        input                                   rf_we,
        input                   [31 : 0]        rf_wd,

        output                  [31 : 0]        rf_rd0, rf_rd1
    );
    import "DPI-C" function void set_gpr_ptr(input logic [31 : 0] a []);
    reg         [31 : 0]        reg_file        [0 : 31];

    integer i;
    initial begin
        set_gpr_ptr(reg_file);
        for(i = 0; i < 32; i = i + 1) begin
            reg_file[i] = 32'H0;
        end
    end

    always @(posedge clk) begin
        if(rf_we && rf_wa != 5'H0) begin
            reg_file[rf_wa] <= rf_wd;
        end
    end

    assign rf_rd0 = reg_file[rf_ra0];
    assign rf_rd1 = reg_file[rf_ra1];

endmodule