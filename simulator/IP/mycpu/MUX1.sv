module
    MUX1 (
        input                   [31 : 0]        src0, src1,
        input                                   sel,

        output                  [31 : 0]        res
    );

    assign res = sel ? src1 : src0;

endmodule