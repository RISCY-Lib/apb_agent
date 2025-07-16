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

// Class: apb_agent_pkg.apb_requester_reactive_seq
// The base sequence extended by reactive sequences used for APB Requestor agents
class apb_requester_reactive_seq#(
    `_APB_AGENT_PARAM_DEFS
) extends uvm_sequence#(apb_transaction#(`_APB_AGENT_PARAM_MAP));
    `uvm_object_param_utils(apb_requester_reactive_seq#(`_APB_AGENT_PARAM_MAP))
    `uvm_type_name_decl("apb_requester_reactive_seq")
    `uvm_declare_p_sequencer(apb_sequencer#(`_APB_AGENT_PARAM_MAP))

    // Group: Constructors
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Constructor: new
    function new(string name = "apb_requester_reactive_seq");
        super.new(name);
    endfunction : new

    // Group: Body Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Task: body
    virtual task body();
        `uvm_fatal(get_type_name(), "Using base apb_requester_reactive_seq directly.")
    endtask

endclass : apb_requester_reactive_seq