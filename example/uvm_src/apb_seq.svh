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

// Class: apb_tb_example_pkg.apb_seq
class apb_seq extends uvm_sequence#(apb_transaction#(.DATA_WIDTH(32), .ADDR_WIDTH(32)));
    `uvm_object_utils(apb_seq)

    logic[31:0] addr_q[$];

    function new(string name="apb_seq");
        super.new(name);
    endfunction : new

    virtual task body();
        repeat(10) begin
            apb_transaction#(.DATA_WIDTH(32), .ADDR_WIDTH(32)) trans;

            trans = apb_transaction#(.DATA_WIDTH(32), .ADDR_WIDTH(32))::type_id::create("trans");

            start_item(trans);
            trans.rand_type = APB_COMPLETER_AGENT;
            void'(trans.randomize());
            `uvm_info(get_type_name(), $sformatf("Sending Transaction: %s", trans.sprint()), UVM_LOW)
            if (trans.write == APB_WRITE)
                addr_q.push_back(trans.addr);
            finish_item(trans);
        end

        while(addr_q.size() > 0) begin
            apb_transaction#(.DATA_WIDTH(32), .ADDR_WIDTH(32)) trans;

            trans = apb_transaction#(.DATA_WIDTH(32), .ADDR_WIDTH(32))::type_id::create("trans");

            start_item(trans);
            trans.rand_type = APB_COMPLETER_AGENT;
            trans.addr = addr_q.pop_front();
            trans.write = APB_READ;
            `uvm_info(get_type_name(), $sformatf("Sending Transaction: %s", trans.sprint()), UVM_LOW)
            finish_item(trans);
        end
    endtask : body
endclass : apb_seq