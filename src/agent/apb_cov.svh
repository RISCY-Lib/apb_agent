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

// Class: apb_agent_pkg.apb_cov
// The coverage collector for the APB UVM Agent
class apb_cov#(`_APB_AGENT_PARAM_DEFS) extends uvm_subscriber#(apb_transaction#(`_APB_AGENT_PARAM_MAP));
    `uvm_component_param_utils(apb_cov#(`_APB_AGENT_PARAM_MAP))
    `uvm_type_name_decl("apb_cov")

    // Group: Class Properties
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Property: pkt
    // The apb_transaction packet which is transmitted
    apb_transaction#(`_APB_AGENT_PARAM_MAP) pkt;

    // Reference: m_cfg
    // The agent config for this APB Agent
    apb_agent_config m_cfg;

    // Group: Covergroups
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Covergroup: apb_cg
    // The functional cover group
    covergroup apb_cg(string name = "apb_cg");
        option.name = name;
        option.per_instance = 1;
    endgroup

    // Group: Constructor
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Constructor: new
    function new(string name="apb_cov", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    // Group: UVM Build Phases
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Function: build_phase
    // The build_phase for apb_cov
    //
    // Performs the following
    // - Fetches teh config if it isn't set
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (m_cfg == null) begin
            if (!uvm_config_db#(apb_agent_config)::get(this, "", "m_cfg", m_cfg)) begin
                `uvm_fatal(
                    get_type_name(),
                    "Cannot get() configuration 'm_cfg' from uvm_config_db. Did you set() it?"
                )
            end
        end
    endfunction : build_phase

    // Group: UVM Run Phases
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Group: UVM Subscriber Methods
    ////////////////////////////////////////////////////////////////////////////////////////////////

    virtual function void write (apb_transaction#(`_APB_AGENT_PARAM_MAP) t);
        pkt = t;

        apb_cg.sample();
    endfunction
endclass : apb_cov