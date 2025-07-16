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

// Class: apb_agent_pkg.apb_requester_wait_states_seq
// The base sequence extended by reactive sequences used for APB Requestor agents
class apb_requester_wait_states_seq#(
    `_APB_AGENT_PARAM_DEFS
) extends apb_requester_no_wait_states_seq#(`_APB_AGENT_PARAM_MAP);
    `uvm_object_param_utils(apb_requester_wait_states_seq#(`_APB_AGENT_PARAM_MAP))
    `uvm_type_name_decl("apb_requester_wait_states_seq")

    // Group: Class Properties
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Property: max_wait_states
    // The maximum number of wait states to introduce
    int max_wait_states = 64;

    // Group: Constructors
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Constructor: new
    function new(string name = "apb_requester_wait_states_seq");
        super.new(name);
    endfunction : new

    // Group: Body Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Function: populate_trans
    // Update the transaction to send-back
    //
    // See Also:
    //  <apb_transaction>
    virtual function void populate_trans(apb_transaction#(`_APB_AGENT_PARAM_MAP) trans);
        if (!trans.randomize(wait_states) with { wait_states < max_wait_states; })
            `uvm_error(get_type_name(), "Could not randomize the number of wait states")
    endfunction : populate_trans

endclass : apb_requester_wait_states_seq