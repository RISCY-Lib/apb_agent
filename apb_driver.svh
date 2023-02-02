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

class apb_driver extends uvm_driver #(apb_seq_item);
  `uvm_component_utils(apb_driver)

  // Virtual Interface BFMs
  virtual apb_driver_bfm m_bfm;

  // Members
  apb_agent_config m_cfg;

  // Methods
  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", m_cfg))
      `uvm_fatal("apb_driver.build_phase", "Cannot get configuration 'apb_agent_config' from uvm_config_db. Is it set?")

    m_bfm = m_cfg.drv_bfm;
  endfunction:  build_phase

  task run_phase(uvm_phase phase);
    apb_seq_item req;
    int psel_index;

    m_bfm.m_cfg = m_cfg;

    forever begin
      m_bfm.clear_sigs();
      seq_item_port.get_next_item(req);

      m_bfm.send(req);
      seq_item_port.item_done();
    end

  endtask: run_phase

endclass: apb_driver