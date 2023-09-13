// Copyright (c) 2023 Beijing Institute of Open Source Chip
// archinfo is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

// verilog_format: off
`define ARCH_SYS 4'b0000 //BASEADDR+0x00 [16] [19:8]: clock freq [7:0]: sram size
`define ARCH_IDL 4'b0001 //BASEADDR+0x04 [31:30]: type [29:22]: vendor [21:6]: process(BCD) [5:0]: cust
`define ARCH_IDH 4'b0010 //BASEADDR+0x08 [31:24] reserve [23:0]: date(BCD)
// verilog_format: on

`define SYS_VAL 32'hFFFF_FFFF
`define IDL_VAL 32'hFFFF_FFFF
`define IDH_VAL 32'hFFFF_FFFF

module apb4_archinfo (
    apb4_if apb4
);

  logic [31:0] r_arch_sys;
  logic [31:0] r_arch_idl;
  logic [31:0] r_arch_idh;
  logic [ 3:0] s_apb_addr;

  assign s_apb_addr = apb4.paddr[5:2];

  always_ff @(posedge apb4.hclk, negedge apb4.hresetn) begin
    if (~apb4.hresetn) begin
      r_arch_sys <= `SYS_VAL;
      r_arch_idl <= `IDL_VAL;
      r_arch_idh <= `IDH_VAL;
    end else if ((apb4.psel && apb4.penable) && apb4.pwrite) begin
      unique case (s_apb_addr)
        `ARCH_SYS: r_arch_sys <= apb4.pwdata;
        `ARCH_IDL: r_arch_idl <= apb4.pwdata;
        `ARCH_IDH: r_arch_idh <= apb4.pwdata;
      endcase
    end
  end

  always_comb begin
    unique case (s_apb_addr)
      `ARCH_SYS: apb4.prdata = r_arch_sys;
      `ARCH_IDL: apb4.prdata = r_arch_idl;
      `ARCH_IDH: apb4.prdata = r_arch_idh;
      default:   apb4.prdata = 'h0;
    endcase
  end

  assign apb4.pready = 1'b1;
  assign apb4.pslerr = 1'b0;

endmodule
