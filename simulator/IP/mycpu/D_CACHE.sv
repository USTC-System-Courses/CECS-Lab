module 
    D_CACHE #(
        parameter DEPTH = 8
    )
    (
        input                                           clk,
        input                   [31 : 0]         addr,
        input                   [31 : 0]                wd,
        input                                           we,re,
        input                   [1 : 0]                 mask,

        output                  [31 : 0]                rd
    );

    reg         [31 : 0]        d_cache         [0 : (1 << DEPTH) - 1];
    import "DPI-C" function void pmem_read(input bit re, input int addr, input int mask, output int rword);
    import "DPI-C" function void pmem_write(input bit we, input int addr, input int mask, input int wword);

    always @(*) begin
        pmem_read(re, addr, {30'H0, mask}, rd);
    end
    always @(posedge clk) begin
        if(we) pmem_write(we, addr, {30'H0, mask}, wd);
    end
endmodule