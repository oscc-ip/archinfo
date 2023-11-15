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
`include "helper.sv"

module apb4_archinfo_tb ();
  localparam CLK_PEROID = 10;
  logic rst_n_i, clk_i;
  always #(CLK_PEROID / 2) clk_i <= ~clk_i;

  string wave_name = "default.fsdb";
  task sim_config();
    $timeformat(-9, 1, "ns", 10);
    if ($test$plusargs("WAVE_ON")) begin
      $value$plusargs("WAVE_NAME=%s", wave_name);
      $fsdbDumpfile(wave_name);
      $fsdbDumpvars("+all");
    end
  endtask

  task sim_reset(int unsigned delay);
    clk_i   = 1'b0;
    rst_n_i = 1'b0;
    repeat (delay) @(posedge clk_i);
    #1 rst_n_i = 1'b1;
  endtask

  apb4_if u_apb4_if (
      clk_i,
      rst_n_i
  );

  test_top u_test_top (u_apb4_if);
  apb4_archinfo u_apb4_archinfo (u_apb4_if);

  initial begin
    Helper::start_banner();
    sim_config();
    sim_reset(40);
    Helper::print("tb init done");
    Helper::end_banner();
    #11000 $finish;
  end

endmodule
