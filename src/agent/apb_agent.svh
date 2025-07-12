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

// Class: apb_agent_pkg.apb_agent
class apb_agent #(
    `_APB_AGENT_PARAM_DEFS
) extends uvm_agent;
    `uvm_component_param_utils(apb_agent#(`_APB_AGENT_PARAM_MAP))
    `uvm_type_name_decl("apb_agent")

    // Group: Class Properties
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Reference: m_cfg
    // The agent config for this APB Agent
    apb_agent_config m_cfg;

    // Reference: ap
    // Analysis Port for APB Transactions. Internal reference to monitor AP
    uvm_analysis_port #(apb_transaction#(`_APB_AGENT_PARAM_MAP)) ap;

    // Property: m_monitor
    // The UVM Monitor for the APB Agent
    apb_monitor#(`_APB_AGENT_PARAM_MAP) m_monitor;

    // Property: m_sequencer
    // The UVM Sequencer for the APB Agent
    uvm_sequencer#(apb_transaction#(`_APB_AGENT_PARAM_MAP)) m_sequencer;

    // Property: m_driver
    // The UVM Driver for the APB Agent
    apb_driver#(`_APB_AGENT_PARAM_MAP) m_driver;

    // Property: m_cov
    // The UVM Coverage Collector for the APB Agent
    apb_cov#(`_APB_AGENT_PARAM_MAP) m_cov;

    // Group: Constructors
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Constructor: new
    function new(string name = "apb_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    // Group: UVM Build Phases
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Function: build_phase
    // The build_phase for the APB Agent.
    //
    // This phase performs the following
    // - Get the configuration object if not set
    // - Check the parameters fall within the APB Spec
    // - Build the monitor
    // - Build the driver and sequencer if active
    // - Build the coverage collector if enabled in the config
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

        check_params();

        // Instantiate the Monitor (always present)
        m_monitor = apb_monitor#(`_APB_AGENT_PARAM_MAP)::type_id::create("m_monitor", this);
        m_monitor.m_cfg = m_cfg;

        ap = new("ap", this);

        // Build the driver and sequencer if active
        if (m_cfg.is_active == UVM_ACTIVE) begin
            m_driver = apb_driver#(`_APB_AGENT_PARAM_MAP)::type_id::create("m_driver", this);
            m_driver.m_cfg = m_cfg;

            m_sequencer = uvm_sequencer#(apb_transaction#(`_APB_AGENT_PARAM_MAP))::
                            type_id::create("m_sequencer", this);
        end

        // Build the coverage if there is functional coverage
        if (m_cfg.has_functional_coverage) begin
            m_cov = apb_cov#(`_APB_AGENT_PARAM_MAP)::type_id::create("m_cov", this);
            m_cov.m_cfg = m_cfg;
        end

    endfunction : build_phase

    // Function: connect_phase
    // The connect_phase for the APB Agent.
    //
    // This phase performs the following
    // - Connect the monitor to the agent AP
    // - Connect the driver and sequencer if the agent is active
    // - Connect the monitor and coverage collector if there is functional coverage
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the analysis port of the monitor
        ap = m_monitor.ap;

        // Connect driver and sequencer if the agent is active
        if (m_cfg.is_active == UVM_ACTIVE) begin
            m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
        end

        // Connect the coverage collector if there is functional coverage
        if (m_cfg.has_functional_coverage) begin
            m_monitor.ap.connect(m_cov.analysis_export);
        end
    endfunction : connect_phase

    // Function: check_params
    // A function which checks that the params fall within the limits perscribed by the spec
    virtual function void check_params();
        if (m_cfg.no_parameter_check)
            return;

        if (ADDR_WIDTH > 32) begin
            `uvm_error(
                get_type_name(),
                $sformatf(
                    "ADDR_WIDTH is set to %0d. APB Spec requires ADDR_WDITH be <= 32. (Section 2.1)",
                    ADDR_WIDTH
                )
            )
        end

        if (!DATA_WIDTH inside {8, 16, 32}) begin
            `uvm_error(
                get_type_name(),
                $sformatf(
                    "DATA_WIDTH is set to %0d. APB Spec requires DATA_WIDTH be 8, 16, or 32. (Section 2.1)",
                    DATA_WIDTH
                )
            )
        end

    endfunction : check_params

endclass : apb_agent