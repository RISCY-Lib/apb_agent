/************************************************************************************
 * A full-featured APB UVM Agent
 * Copyright (C) 2025  RISCY-Lib Contributors
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 ************************************************************************************/

module tb();
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import apb_tb_example_pkg::*;

    logic pclk;
    logic presetn;

    `APB_IF_INST(32, 32, APB, pclk, presetn)

    initial begin
        pclk = 1'b0;
        forever begin
            #10ns;
            pclk = ~pclk;
        end
    end

    initial begin
        presetn = 1'b0;

        repeat(3) begin
            @(posedge pclk);
        end

        presetn = 1'b1;
    end

    initial begin
        run_test();
    end
endmodule : tb