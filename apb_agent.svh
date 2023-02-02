/**************************************************************************
 * A UVM APB agent                                                        *
 * Copyright (C) 2023, Benjamin Davis                                     *
 *                                                                        *
 * This program is free software: you can redistribute it and/or modify   *
 * it under the terms of the GNU General Public License as published by   *
 * the Free Software Foundation, either version 3 of the License, or      *
 * (at your option) any later version.                                    *
 *                                                                        *
 * This program is distributed in the hope that it will be useful,        *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
 * GNU General Public License for more details.                           *
 *                                                                        *
 * You should have received a copy of the GNU General Public License      *
 * along with this program.  If not, see <https://www.gnu.org/licenses/>. *
 **************************************************************************/

class apb_agent extends uvm_component;
  `uvm_component_utils(apb_agent)

  // Members
  apb_agent_config m_cfg;

  uvm_analysis_port #(apb_seq_item) m_ap;
  apb_monitor   m_monitor;
  apb_sequencer m_sequencer;
  apb_driver    m_driver;
  apb_coverage_monitor m_cov_monitor;

  // Methods
  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg))
      `uvm_fatal("apb_driver.build_phase", "Cannot get configuration 'apb_agent_config' from uvm_config_db. Is it set?")

    // Monitor is always present
    m_monitor = apb_monitor::type_id::create("m_monitor", this);
    m_monitor.m_cfg = m_cfg;

    // Build the driver and sequencer if active
    if(m_cfg.active == UVM_ACTIVE) begin
      m_driver = apb_driver::type_id::create("m_driver", this);
      m_driver.m_cfg = m_cfg;
      m_sequencer = apb_sequencer::type_id::create("m_sequencer", this);
    end

    // Build functional monitor if functional coverage is enabled
    if(m_cfg.has_functional_coverage) begin
      m_cov_monitor = apb_coverage_monitor::type_id::create("m_cov_monitor", this);
    end
  endfunction:  build_phase

  function void connect_phase(uvm_phase phase);
    m_ap = m_monitor.m_ap;

    // Connect the driver and the sequencer if active
    if(m_cfg.active == UVM_ACTIVE) begin
      m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end

    // Connect the functional monitory if functional coverage is enabled
    if(m_cfg.has_functional_coverage) begin
      m_monitor.m_ap.connect(m_cov_monitor.analysis_export);
    end
  endfunction:  connect_phase

endclass: apb_agent