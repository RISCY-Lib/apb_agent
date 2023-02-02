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

class apb_agent_config extends uvm_object;
  localparam string config_id = "apb_agent_config";

  `uvm_object_utils(apb_agent_config)

  // Virtual Interface BFMs
  virtual apb_monitor_bfm mon_bfm;
  virtual apb_driver_bfm  drv_bfm;

  // Members
  uvm_active_passive_enum active = UVM_ACTIVE;
  bit has_functional_coverage = 0;
  bit has_scoreboard = 0;

  // TODO: Can this be removed?
  int no_select_lines = 1;
  int apb_index = 0; // Which PSEL is the monitor connected to
  logic[31:0] start_address[15:0];
  logic[31:0] range[15:0];

  // Methods
  function new(string name = "apb_agent_config");
    super.new(name);
  endfunction

  function automatic apb_agent_config get_config(uvm_component c);
    apb_agent_config tmp;

    if (!uvm_config_db #(apb_agent_config)::get(c, "", config_id, tmp) )
      `uvm_fatal("apb_agent_config.get_config", $sformatf("Cannot get configuration %s from uvm_config_db. Is it set?", config_id))

    return tmp;
  endfunction

endclass: apb_agent_config
