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

// Package: apb_agent_pkg
// Package which contains the apb_agent an relevant definitions
package apb_agent_pkg;

    // UVM Imports
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // General Includes
    `include "apb_agent_macros.svh"

    `include "apb_definitions.svh"

    // Agent Includes
    `include "agent/apb_agent_config.svh"
    `include "agent/apb_transaction.svh"
    `include "agent/apb_monitor.svh"
    `include "agent/apb_driver.svh"
    `include "agent/apb_cov.svh"
    `include "agent/apb_agent.svh"

endpackage : apb_agent_pkg