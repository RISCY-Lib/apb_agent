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

// Class: apb_agent_pkg.apb_transaction
// The APB Transaction class
class apb_transaction#(`_APB_AGENT_PARAM_DEFS) extends uvm_sequence_item;
    `uvm_object_param_utils(apb_transaction#(`_APB_AGENT_PARAM_MAP))
    `uvm_type_name_decl("apb_transaction")

    // Group: Class Properties
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Property: rand_type
    // The agent mode to use when randomizing.
    // Only randomizes values which should be set by a sequence
    apb_agent_mode_e rand_type = APB_COMPLETER_AGENT;

    // Property: write
    // Whether the transaction is read or write
    // Set by the sequence in APB_COMPLETER_AGENT mode.
    // Set by the agent in APB_REQUESTER_MODE
    rand apb_write_e write = APB_WRITE;

    // Property: addr
    // The address of the transaction
    // Set by the sequence in APB_COMPLETER_AGENT mode.
    // Set by the agent in APB_REQUESTER_AGENT mode.
    rand logic [ADDR_WIDTH-1:0] addr = '0;

    // Property: data
    // The data transmitted by this transaction
    rand logic [DATA_WIDTH-1:0] data = '0;

    // Property: wstrb
    // The write strobe use in this transaction
    // Set by the sequence in APB_COMPLETER_AGENT mode.
    // Set by the agent in APB_REQUESTER_AGENT mode.
    rand logic [DATA_WIDTH/8-1:0] wstrb = '1;

    // Property: pprot
    // The protection unit support for the tranaction.
    // Set by the sequence in APB_COMPLETER_AGENT mode.
    // Set by the agent in APB_REQUESTER_AGENT mode.
    rand apb_pprot_t pprot = '0;

    // Poperty: error
    // The Completer Error signal from the transaction.
    // Set by the sequence in APB_REQUESTER_AGENT mode.
    // set by the agent in APB_COMPLETER_AGENT mode.
    rand bit error = 1'b0;

    // Property: wait_states
    // The number of wait states in the transaction.
    // Set by sequence in APB_REQUESTER_AGENT mode.
    // Set by agent in APB_COMPLETER_AGENT mode.
    rand int wait_states = 0;

    // Group: Constraints
    ////////////////////////////////////////////////////////////////////////////////////////////////

    constraint write_before_data_c { solve write before data; }

    function void pre_randomize();
        super.pre_randomize();

        if (rand_type == APB_COMPLETER_AGENT) begin
            error.rand_mode(0);
            wait_states.rand_mode(0);
            return;
        end

        if (rand_type == APB_REQUESTER_AGENT) begin
            write.rand_mode(0);
            addr.rand_mode(0);
            wstrb.rand_mode(0);
            pprot.rand_mode(0);
            return;
        end

    endfunction : pre_randomize

    // Group: Constructors
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Constructor: new
    function new(string name = "apb_transaction");
        super.new(name);
    endfunction : new

    // Group: UVM do_* methods
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Function: do_print
    virtual function void do_print(uvm_printer printer);
        `uvm_print_enum(apb_agent_mode_e, rand_type)
        `uvm_print_enum(apb_write_e, write)
        printer.print_field("addr", addr, $bits(addr));
        printer.print_field("data", data, $bits(data));
        printer.print_field("pprot", pprot, $bits(pprot));
        `uvm_print_int(wait_states, $size(wait_states))
    endfunction : do_print

    // Function: do_record
    virtual function void do_record(uvm_recorder recorder);
        super.do_record(recorder);

        `uvm_record_enum("rand_type", rand_type, apb_agent_mode_e)
        `uvm_record_enum("write", write, apb_write_e)
        `uvm_record_field("addr", addr)
        `uvm_record_field("data", data)
        `uvm_record_int("wait_states", wait_states, 32)

    endfunction : do_record

    // Function: do_copy
    virtual function void do_copy(uvm_object rhs);
        apb_transaction#(`_APB_AGENT_PARAM_MAP) _rhs;
        super.do_copy(rhs);

        if (!$cast(_rhs, rhs))
            `uvm_fatal(get_type_name(), "Could not cast rhs to ransaction in do_copy")

        rand_type = _rhs.rand_type;
        write = _rhs.write;
        addr = _rhs.addr;
        data = _rhs.data;
        wstrb = _rhs.wstrb;
        pprot = _rhs.pprot;
        wait_states = _rhs.wait_states;
    endfunction : do_copy

endclass : apb_transaction
