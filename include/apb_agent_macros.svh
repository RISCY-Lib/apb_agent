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

`ifndef __APB_AGENT_MACROS__SVH__
`define __APB_AGENT_MACROS__SVH__

// Macro: _APB_AGENT_PARAM_DEFS
// Macro for instantiating the common parameters used around the agent
`define _APB_AGENT_PARAM_DEFS \
    parameter int ADDR_WIDTH = 32,  \
    parameter int DATA_WIDTH = 32

// Macro: _APB_AGENT_PARAM_MAP
// Map the parameters from the parent into a child instance
`define _APB_AGENT_PARAM_MAP \
    .ADDR_WIDTH(ADDR_WIDTH),      \
    .DATA_WIDTH(DATA_WIDTH)

// Macro: APB_IF_INST
// Instantiate the apb_vip_if and set it in the config_db
`define APB_IF_INST(ADDR, DATA, IF_NAME=APB, CLK_NAME=pclk, RST_NAME=presetn) \
    apb_vip_if #(                            \
        .ADDR_WIDTH(ADDR),                   \
        .DATA_WIDTH(DATA)                    \
    ) IF_NAME (                              \
        .pclk(CLK_NAME),                     \
        .preset_n(RST_NAME)                  \
    );                                       \
    initial begin                            \
        uvm_config_db#(                      \
            virtual apb_vip_if #(            \
                .ADDR_WIDTH(ADDR),           \
                .DATA_WIDTH(DATA)            \
            )                                \
        )::set(null, "*", "m_vif", IF_NAME); \
    end

`endif // __APB_AGENT_MACROS__SVH__