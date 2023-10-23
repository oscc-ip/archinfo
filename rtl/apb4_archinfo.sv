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
    apb4_if.slave apb4
);

  logic [3:0] s_apb_addr;
  logic [31:0] s_arch_sys_d, s_arch_sys_q;
  logic [31:0] s_arch_idl_d, s_arch_idl_q;
  logic [31:0] s_arch_idh_d, s_arch_idh_q;
  logic s_apb4_wr_hdshk, s_apb4_rd_hdshk;

  assign s_apb_addr = apb4.paddr[5:2];
  assign s_apb4_wr_hdshk = apb4.psel && apb4.penable && apb4.pwrite;
  assign s_apb4_rd_hdshk = apb4.psel && apb4.penable && (~apb4.pwrite);

  assign r_arch_sys_d = (s_apb4_wr_hdshk && s_apb_addr == `ARCH_SYS) ? apb4.pwdata : r_arch_sys_q;
  dffrc #(32, `SYS_VAL) u_arch_sys_dffrc (
      apb4.hclk,
      apb4.hresetn,
      s_arch_sys_d,
      s_arch_sys_q
  );

  assign r_arch_idl_d = (s_apb4_wr_hdshk && s_apb_addr == `ARCH_IDL) ? apb4.pwdata : r_arch_idl_q;
  dffrc #(32, `IDL_VAL) u_arch_idl_dffrc (
      apb4.hclk,
      apb4.hresetn,
      s_arch_idl_d,
      s_arch_idl_q
  );

  assign r_arch_idh_d = (s_apb4_wr_hdshk && s_apb_addr == `ARCH_IDH) ? apb4.pwdata : r_arch_idh_q;
  dffrc #(32, `IDH_VAL) u_arch_idh_dffrc (
      apb4.hclk,
      apb4.hresetn,
      s_arch_idh_d,
      s_arch_idh_q
  );

  always_comb begin
    apb4.prdata = '0;
    if (s_apb4_rd_hdshk) begin
      unique case (s_apb_addr)
        `ARCH_SYS: apb4.prdata = s_arch_sys_q;
        `ARCH_IDL: apb4.prdata = s_arch_idl_q;
        `ARCH_IDH: apb4.prdata = s_arch_idh_q;
      endcase
    end
  end

  assign apb4.pready = 1'b1;
  assign apb4.pslerr = 1'b0;

endmodule
