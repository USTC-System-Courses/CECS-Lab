module
    NPC_SEL (
        input                                   jal, jalr, br,
        input                   [31 : 0]        pc_add4, pc_jal_br, pc_jalr,

        output                  [31 : 0]        pc_next
    );

    assign pc_next = (jal | br) ? pc_jal_br : (jalr ? pc_jalr : pc_add4);

endmodule