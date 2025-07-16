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

// Class: apb_agent_pkg.apb_requester_no_wait_states_seq
// The base sequence extended by reactive sequences used for APB Requestor agents
class apb_requester_no_wait_states_seq#(
    `_APB_AGENT_PARAM_DEFS
) extends apb_requester_reactive_seq#(`_APB_AGENT_PARAM_MAP);
    `uvm_object_param_utils(apb_requester_no_wait_states_seq#(`_APB_AGENT_PARAM_MAP))
    `uvm_type_name_decl("apb_requester_no_wait_states_seq")

    // Group: Class Properties
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Property: trans
    // The transaction being processed
    apb_transaction#(`_APB_AGENT_PARAM_MAP) trans;

    // Property: memory
    // The byte-wise memory map
    logic[7:0] memory[bit[ADDR_WIDTH-1:0]];

    // Group: Constructors
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Constructor: new
    function new(string name = "apb_requester_no_wait_states_seq");
        super.new(name);
    endfunction : new

    // Group: Body Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Task: body
    virtual task body();
        forever begin
            // Wait for the start of the transaction from the manager
            p_sequencer.request_fifo.get(trans);

            // Start the item
            start_item(trans);

            // Generate Response based on observed request
            populate_trans(trans);

            `uvm_info(get_type_name(), $sformatf("Responding to requester with: %s", trans.sprint()), UVM_LOW)

            // Send the response
            finish_item(trans);
        end
    endtask

    // Function: populate_trans
    // Update the transaction to send-back
    //
    // See Also:
    //  <apb_transaction>
    virtual function void populate_trans(apb_transaction#(`_APB_AGENT_PARAM_MAP) trans);
        trans.wait_states = 0;
        for (int idx = 0; idx < DATA_WIDTH/8; idx++) begin
            bit[ADDR_WIDTH-1:0] byte_addr;

            byte_addr = trans.addr + ADDR_WIDTH'(idx);

            if (trans.write == APB_WRITE && trans.wstrb[idx]) begin
                memory[byte_addr] = trans.data[8*(idx+1)-1-:8];
            end

            if (trans.write == APB_READ) begin
                if (memory.exists(byte_addr)) begin
                    trans.data[8*(idx+1)-1-:8] = memory[byte_addr];
                end
                else begin
                    trans.data[8*(idx+1)-1-:8] = 8'h00;
                end
            end
        end
    endfunction : populate_trans

endclass : apb_requester_no_wait_states_seq