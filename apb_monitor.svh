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

class apb_monitor extends uvm_component;
  `uvm_component_utils(apb_monitor);

  // Virtual Interface BFM
  virtual apb_monitor_bfm m_bfm;

  // Members
  apb_agent_config m_cfg;

  uvm_analysis_port #(apb_seq_item) m_ap;

  // Methods
  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg))
      `uvm_fatal("apb_driver.build_phase", "Cannot get configuration 'apb_agent_config' from uvm_config_db. Is it set?")

    m_bfm = m_cfg.mon_bfm;
    m_bfm.proxy = this;
    set_apb_index(m_cfg.apb_index);

    m_ap = new("m_ap", this);
  endfunction:  build_phase

  task run_phase(uvm_phase phase);
    m_bfm.run();
  endtask: run_phase

  function void notify_transaction(apb_seq_item item);
    m_ap.write(item);
  endfunction : notify_transaction

  function void set_apb_index(int index = 0);
    m_bfm.apb_index = index;
  endfunction : set_apb_index

endclass: apb_monitor