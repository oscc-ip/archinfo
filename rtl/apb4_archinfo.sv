// Copyright (c) 2023 Beijing Institute of Open Source Chip
// archinfo is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`include "register.sv"

// verilog_format: off
`define ARCH_SYS 4'b0000 // BASEADDR + 0x00
`define ARCH_IDL 4'b0001 // BASEADDR + 0x04
`define ARCH_IDH 4'b0010 // BASEADDR + 0x08
// verilog_format: on

/* register mapping
 * ARCH_SYS:
 * BITS:   | 31:20 | 19:8  | 7:0  |
 * FIELDS: | RES   | CLOCK | SRAM |
 * PERMS:  | NONE  | RW    | RW   |
 * -------------------------------------------
 * ARCH_IDL:
 * BITS:   | 31:30 | 29:22  | 21:6    | 5:0  |
 * FIELDS: | TYPE  | VENDOR | PROCESS | CUST |
 * PERMS:  | RW    | RW     | RW      | RW   |
 * -------------------------------------------
 * ARCH_IDH:
 * BITS:   | 31:24 | 23:0 |
 * FIELDS: | RES   | DATE |
 * PERMS:  | NONE  | RW   |
 * -------------------------------------------
*/

`define SYS_VAL 32'h101F_1010
`define IDL_VAL 32'hFFFF_2022
`define IDH_VAL 32'hFFFF_FFFF

module apb4_archinfo (
    apb4_if.slave apb4
);

  logic [3:0] s_apb4_addr;
  logic [31:0] s_arch_sys_d, s_arch_sys_q;
  logic [31:0] s_arch_idl_d, s_arch_idl_q;
  logic [31:0] s_arch_idh_d, s_arch_idh_q;
  logic s_apb4_wr_hdshk, s_apb4_rd_hdshk;

  assign s_apb4_addr = apb4.paddr[5:2];
  assign s_apb4_wr_hdshk = apb4.psel && apb4.penable && apb4.pwrite;
  assign s_apb4_rd_hdshk = apb4.psel && apb4.penable && (~apb4.pwrite);
  assign apb4.pready = 1'b1;
  assign apb4.pslverr = 1'b0;

  assign s_arch_sys_d = (s_apb4_wr_hdshk && s_apb4_addr == `ARCH_SYS) ? apb4.pwdata : s_arch_sys_q;
  dffrc #(32, `SYS_VAL) u_arch_sys_dffrc (
      apb4.pclk,
      apb4.presetn,
      s_arch_sys_d,
      s_arch_sys_q
  );

  assign s_arch_idl_d = (s_apb4_wr_hdshk && s_apb4_addr == `ARCH_IDL) ? apb4.pwdata : s_arch_idl_q;
  dffrc #(32, `IDL_VAL) u_arch_idl_dffrc (
      apb4.pclk,
      apb4.presetn,
      s_arch_idl_d,
      s_arch_idl_q
  );

  assign s_arch_idh_d = (s_apb4_wr_hdshk && s_apb4_addr == `ARCH_IDH) ? apb4.pwdata : s_arch_idh_q;
  dffrc #(32, `IDH_VAL) u_arch_idh_dffrc (
      apb4.pclk,
      apb4.presetn,
      s_arch_idh_d,
      s_arch_idh_q
  );

  always_comb begin
    apb4.prdata = '0;
    if (s_apb4_rd_hdshk) begin
      unique case (s_apb4_addr)
        `ARCH_SYS: apb4.prdata = s_arch_sys_q;
        `ARCH_IDL: apb4.prdata = s_arch_idl_q;
        `ARCH_IDH: apb4.prdata = s_arch_idh_q;
        default:   apb4.prdata = '0;
      endcase
    end
  end

endmodule
