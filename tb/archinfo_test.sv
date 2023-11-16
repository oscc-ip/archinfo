// Copyright (c) 2023 Beijing Institute of Open Source Chip
// archinfo is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`ifndef INC_ARCHINFO_TEST_SV
`define INC_ARCHINFO_TEST_SV

`include "apb4_master.sv"

`define SYS_VAL 32'h101F_1010
`define IDL_VAL 32'hFFFF_2022
`define IDH_VAL 32'hFFFF_FFFF

class ArchInfoTest extends APB4Master;
  string                        name;
  virtual apb4_if.master        apb4;

  extern function new(string name = "archinfo_test", virtual apb4_if.master apb4);
  extern task test_reset_register();
endclass

function ArchInfoTest::new(string name, virtual apb4_if.master apb4);
  super.new("apb4_master", apb4);
  this.name = name;
  this.apb4 = apb4;
endfunction

task ArchInfoTest::test_reset_register();
  super.test_reset_register();
  this.read(32'hFFFF_0000);
  Helper::check("SYS_VAL REG", super.rd_data, `SYS_VAL, Helper::EQUL);
  this.read(32'hFFFF_0004);
  Helper::check("IDL_VAL REG", super.rd_data, `IDL_VAL, Helper::EQUL);
  this.read(32'hFFFF_0008);
  Helper::check("IDH_VAL REG", super.rd_data, `IDH_VAL, Helper::EQUL);
endtask
`endif


