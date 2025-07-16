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

class apb_test extends uvm_test;
    `uvm_component_utils(apb_test)

    apb_env_example m_env;
    apb_requester_no_wait_states_seq#(.ADDR_WIDTH(32), .DATA_WIDTH(32)) requester_seq;
    apb_seq completer_seq;

    function new(string name="apb_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_env = apb_env_example::type_id::create("m_env", this);
    endfunction : build_phase

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);

        #100ns;

        phase.drop_objection(this);
    endtask : reset_phase

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);

        fork
            begin
                requester_seq = apb_requester_no_wait_states_seq#(.ADDR_WIDTH(32), .DATA_WIDTH(32))::type_id::create("requester_seq");
                requester_seq.start(m_env.requester_agent.m_sequencer);
            end
        join_none

        completer_seq = apb_seq::type_id::create("completer_seq");
        completer_seq.start(m_env.completer_agent.m_sequencer);

        phase.drop_objection(this);
    endtask : main_phase
endclass : apb_test