module
    I_CACHE #(
        parameter DEPTH = 8
    )
    (
        input                   [31 : 0]         addr,
        output                  [31 : 0]                inst
    );

    reg         [31 : 0]        i_cache         [0 : (1 << DEPTH) - 1];

    import "DPI-C" function void pmem_read(input bit re, input int addr, input int mask, output int rword);
    always@(*) begin
        if (1'h1) pmem_read(1'h1, addr, 32'H3, inst);
    end

endmodule