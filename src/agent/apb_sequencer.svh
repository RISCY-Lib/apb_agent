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

// Class: apb_agent_pkg.apb_sequencer
class apb_sequencer#(
    `_APB_AGENT_PARAM_DEFS
) extends uvm_sequencer#(apb_transaction#(`_APB_AGENT_PARAM_MAP));
    `uvm_component_param_utils(apb_sequencer#(`_APB_AGENT_PARAM_MAP))
    `uvm_type_name_decl("apb_sequencer")

    // Group: Class Properties
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Property: request_export
    // The analysis export for reactive request transactions when in Completer mode
    uvm_analysis_export#(apb_transaction#(`_APB_AGENT_PARAM_MAP)) request_export;

    // Property: request_fifo
    // The TLM analysis fifo for reactive request transactions when in completer mode
    uvm_tlm_analysis_fifo#(apb_transaction#(`_APB_AGENT_PARAM_MAP)) request_fifo;

    // Group: Constructors
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Constructor: new
    function new(string name="apb_sequencer", uvm_component parent=null);
        super.new(name, parent);

        request_fifo = new("request_fifo", this);
        request_export = new("request_export", this);
    endfunction : new

    // Group: UVM Build Phases
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Function: connect_phase
    // The UVM Connect phase
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        request_export.connect(request_fifo.analysis_export);
    endfunction : connect_phase
endclass : apb_sequencer