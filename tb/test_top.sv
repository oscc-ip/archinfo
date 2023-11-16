// Copyright (c) 2023 Beijing Institute of Open Source Chip
// archinfo is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//             http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

`include "apb4_if.sv"

program automatic test_top (
    apb4_if.master apb4
);

  // APB4Master archinfo_mst_hdl;
  ArchInfoTest archinfo_hdl;
  initial begin
    archinfo_hdl = new("archinfo_test", apb4);
    archinfo_hdl.init();
    archinfo_hdl.test_reset_register();
    #21000 $finish;
  end
endprogram
