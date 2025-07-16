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

// Class: apb_agent_pkg.apb_monitor
// The UVM Monitor for the APB agent
class apb_monitor#(`_APB_AGENT_PARAM_DEFS) extends uvm_monitor;
    `uvm_component_param_utils(apb_monitor#(`_APB_AGENT_PARAM_MAP))
    `uvm_type_name_decl("apb_monitor")

    // Group: Class Properties
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Reference: m_vif
    // The virtual interface
    virtual apb_vip_if#(`_APB_AGENT_PARAM_MAP) m_vif;

    // Property: ap
    // The analysis port which this monitor uses to export to
    uvm_analysis_port #(apb_transaction#(`_APB_AGENT_PARAM_MAP)) ap;

    // Property: req_ap
    // The analysis port which sends request transactions to be used by reactive agent sequences
    uvm_analysis_port #(apb_transaction#(`_APB_AGENT_PARAM_MAP)) req_ap;

    // Reference: m_cfg
    // The agent config for this APB agent
    apb_agent_config m_cfg;

    // Group: Constructors
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Constructor: new
    function new(string name="apb_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    // Group: UVM Build Phases
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Function: build_phase
    // The build_phase for the apb_monitor
    //
    // Performs the following
    // - Create the analysis port
    // - Fetches the config if it isn't set
    // - Fetches the virtual interface
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        ap = new("ap", this);
        req_ap = new("req_ap", this);

        if (m_cfg == null) begin
            if (!uvm_config_db#(apb_agent_config)::get(this, "", "m_cfg", m_cfg)) begin
                `uvm_fatal(
                    get_type_name(),
                    "Cannot get() configuration 'm_cfg' from uvm_config_db. Did you set() it?"
                )
            end
        end

        if (m_vif == null) begin
            if (!uvm_config_db#(virtual apb_vip_if#(`_APB_AGENT_PARAM_MAP))::get(
                this, "", m_cfg.vif_handle, m_vif
            )) begin
                `uvm_fatal(
                    get_type_name(),
                    $sformatf(
                        "Cannot get() configuration '%s' from uvm_config_db. Did you set() it?",
                        m_cfg.vif_handle
                    )
                )
            end
        end

    endfunction : build_phase

    // Group: UVM Run Phases
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Function: run_phase
    // The run_phase for the apb_monitor
    virtual task run_phase(uvm_phase phase);
        apb_transaction #(`_APB_AGENT_PARAM_MAP) trans;

        forever begin
            @(posedge m_vif.pclk);

            if (!m_vif.preset_n) begin
                trans = null;
                continue;
            end

            // Idle Phase
            if (!m_vif.psel) begin
                // TODO: Check no oustanding transactions
                // TODO: Check penable
                continue;
            end

            // Setup Phase
            if (trans == null) begin
                apb_transaction#(`_APB_AGENT_PARAM_MAP) req;
                // TODO: Check penable

                trans = apb_transaction#(`_APB_AGENT_PARAM_MAP)::type_id::create("monitor_trans");
                trans.write = (m_vif.pwrite) ? APB_WRITE : APB_READ;
                trans.addr = m_vif.paddr;
                trans.wstrb = m_vif.pstrb;
                trans.pprot = m_vif.pprot;
                trans.wait_states = 0;

                if (m_cfg.agent_mode == APB_REQUESTER_AGENT) begin
                    $cast(req, trans.clone());
                    req.data = m_vif.pwdata;
                    req_ap.write(req);
                end

                continue;
            end

            // Access Phase
            // TODO: Check penable

            if (m_vif.pready) begin
                if (trans.write == APB_READ) begin
                    trans.data = m_vif.prdata;
                end
                else begin
                    trans.data = m_vif.pwdata;
                end

                ap.write(trans);
                trans = null;

                continue;
            end

            // Wait-state in access phase
            trans.wait_states++;
        end

    endtask : run_phase

endclass : apb_monitor