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
`include "apb4_master.sv"

program automatic test_top (
    apb4_if.master apb4
);

  APB4Master apb4_mst_hdl;
  initial begin
    apb4_mst_hdl = new("apb4_master", apb4);
    apb4_mst_hdl.init();
    apb4_mst_hdl.test_reset_register();
    #21000 $finish;
  end
endprogram
