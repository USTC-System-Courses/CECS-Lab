// mem_type: (the same as opcode)
//   3'H0: lb, sb
//   3'H1: lh, sh
//   3'H2: lw, sw
//   3'H4: lbu
//   3'H5: lhu

module
    D_CACHE_CTRL #(
        parameter DEPTH = 8
    )
    (
        input                   [31 : 0]                addr_raw,
        input                   [31 : 0]                wd_raw, rd_raw,
        input                                           we_raw,

        input                   [2 : 0]                 dm_type,

        output                  [31 : 0]         addr,
        output      reg         [31 : 0]                wd, rd,
        output                                          we,
        output                  [1 : 0]                 mask
    );
    assign mask = dm_type[1:0];
    always @(*) begin
        case(dm_type)
            3'H0: begin // lb
                rd = {{24{rd_raw[7]}}, rd_raw[7 : 0]};
            end
            3'H1: begin // lh
                rd = {{16{rd_raw[15]}}, rd_raw[15 : 0]};
            end
            3'H2:       // lw
                rd = rd_raw;
            3'H4: begin // lbu
                rd = {24'h0, rd_raw[7 : 0]};
            end
            3'H5: begin // lhu
                rd = {16'h0, rd_raw[15 : 0]};
            end
            default:
                rd = 32'H0;
        endcase

        wd = wd_raw;
    end

    assign addr = addr_raw;
    assign we = we_raw;

endmodule