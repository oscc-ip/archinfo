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
`include "archinfo_define.sv"

class ArchInfoTest extends APB4Master;
  string                 name;
  virtual apb4_if.master apb4;

  extern function new(string name = "archinfo_test", virtual apb4_if.master apb4);
  extern task test_reset_register();
  extern task test_wr_rd_register(input bit [31:0] run_times = 1000);
endclass

function ArchInfoTest::new(string name, virtual apb4_if.master apb4);
  super.new("apb4_master", apb4);
  this.name = name;
  this.apb4 = apb4;
endfunction

task ArchInfoTest::test_reset_register();
  super.test_reset_register();
  this.rd_check(`ARCHINFO_SYS_ADDR, "SYS_VAL REG", `SYS_VAL, Helper::EQUL);
  this.rd_check(`ARCHINFO_IDL_ADDR, "IDL_VAL REG", `IDL_VAL, Helper::EQUL);
  this.rd_check(`ARCHINFO_IDH_ADDR, "IDH_VAL REG", `IDH_VAL, Helper::EQUL);
endtask

task ArchInfoTest::test_wr_rd_register(input bit [31:0] run_times = 1000);
  super.test_wr_rd_register();

  for (int i = 0; i < run_times; i++) begin
    this.wr_check(`ARCHINFO_SYS_ADDR, "SYS_VAL REG", $random, Helper::EQUL);
    this.wr_check(`ARCHINFO_IDL_ADDR, "IDL_VAL REG", $random, Helper::EQUL);
    this.wr_check(`ARCHINFO_IDH_ADDR, "IDH_VAL REG", $random, Helper::EQUL);
  end

endtask

`endif


