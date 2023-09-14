module
    MUX2 (
        input                   [31 : 0]        src0, src1, src2, src3,
        input                   [1 : 0]         sel,

        output                  [31 : 0]        res
    );

    assign res = sel[1] ? (sel[0] ? src3 : src2) : (sel[0] ? src1 : src0);

endmodule