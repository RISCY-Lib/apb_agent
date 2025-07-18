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

// Class: apb_agent_pkg.apb_driver
class apb_driver#(`_APB_AGENT_PARAM_DEFS) extends uvm_driver#(apb_transaction#(`_APB_AGENT_PARAM_MAP));
    `uvm_component_param_utils(apb_driver#(`_APB_AGENT_PARAM_MAP))
    `uvm_type_name_decl("apb_driver")

    // Group: Class Properties
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Reference: m_vif
    // The virtual interface
    virtual apb_vip_if#(`_APB_AGENT_PARAM_MAP) m_vif;

    // Reference: m_cfg
    // The agent configuration
    apb_agent_config m_cfg;

    // Group: Constructors
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Constructor: new
    function new(string name = "apb_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    // Group: UVM Build Phases
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Function: build_phase
    // The build_phase for the apb_driver
    //
    // Performs the following
    // - Fetches the config if it isn't set
    // - Fetches the virtual interface
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

    // Task: run_phase
    // The UVM Run-Phase
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        if (m_cfg.agent_mode == APB_COMPLETER_AGENT) begin
            completer_run_phase();
        end
        else if (m_cfg.agent_mode == APB_REQUESTER_AGENT) begin
            requester_run_phase();
        end
        else begin
            `uvm_error(
                get_type_name(),
                $sformatf(
                    "Driver not implmented for selected agent_mode: %s",
                    m_cfg.agent_mode.name()
                )
            )
        end
    endtask : run_phase

    // Task: completer_run_phase
    // The UVM Run-Phase for a completer agent
    virtual task completer_run_phase();
        apb_transaction#(`_APB_AGENT_PARAM_MAP) trans;  // The transaction in the address phase
        apb_phase_e phase;

        trans = null;
        phase = APB_SETUP_PHASE;

        m_vif.paddr     = '0;
        m_vif.pprot     = '0;
        m_vif.pwdata    = '0;
        m_vif.pstrb     = '1;
        m_vif.pwrite    = APB_READ;

        m_vif.psel      = 1'b0;
        m_vif.penable   = 1'b0;

        forever begin
            @(posedge m_vif.pclk);

            if (!m_vif.preset_n)
                continue;

            // First check if the previous transaction is done
            if (m_vif.pready && phase == APB_ACCESS_PHASE && trans != null) begin
                if (trans.write == APB_READ) begin
                    trans.data = m_vif.prdata;
                end

                `uvm_info(get_type_name(), "Finished transaction", UVM_HIGH)
                seq_item_port.item_done();

                trans = null;
                phase = APB_SETUP_PHASE;
            end

            // Check if a new transaction is ready
            if (trans == null) begin
                seq_item_port.try_next_item(trans);
            end

            // Drive setup-phase signals if applicable
            if (trans != null && phase == APB_SETUP_PHASE) begin
                m_vif.paddr = trans.addr;
                m_vif.pprot = trans.pprot;
                m_vif.pwrite = trans.write;

                if (trans.write == APB_WRITE) begin
                    m_vif.pwdata = trans.data;
                    m_vif.pstrb = trans.wstrb;
                end
            end

            // Set psel and penable based on the transaction stage
            if (trans == null) begin
                m_vif.psel = 1'b0;
                m_vif.penable = 1'b0;
            end
            else if (phase == APB_SETUP_PHASE) begin
                m_vif.psel = 1'b1;
                m_vif.penable = 1'b0;
                phase = APB_ACCESS_PHASE;
            end
            else begin
                m_vif.psel = 1'b1;
                m_vif.penable = 1'b1;
            end
        end
    endtask : completer_run_phase


    // Task: requester_run_phase
    // The UVM Run-Phase for a requester agent
    virtual task requester_run_phase();
        apb_transaction#(`_APB_AGENT_PARAM_MAP) trans;
        int wait_states;

        m_vif.pready = 1'b0;
        m_vif.prdata = '0;
        m_vif.pslverr = 1'b0;

        forever begin
            m_vif.pready = 1'b0;

            // Get the reaction
            seq_item_port.get_next_item(trans);

            repeat(trans.wait_states) begin
                @(posedge m_vif.pclk);
            end

            if (trans.write == APB_READ) begin
                m_vif.prdata = trans.data;
            end

            m_vif.pready = 1'b1;
            m_vif.pslverr = trans.error;

            @(posedge m_vif.pclk);
            seq_item_port.item_done();
        end
    endtask : requester_run_phase

endclass