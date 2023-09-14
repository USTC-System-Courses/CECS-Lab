module
    PC #(
        parameter PC_RST = 32'H80000000
    )
    (
        input                                   clk, rstn,
        input                   [31 : 0]        pc_next,

        output                  [31 : 0]        pc_cur
    );

    reg         [31 : 0]        pc;

    initial begin
        pc = PC_RST;
    end

    always @(posedge clk) begin
        if(!rstn) pc <= PC_RST;
        else pc <= pc_next;
    end

    assign pc_cur = pc;

endmodule