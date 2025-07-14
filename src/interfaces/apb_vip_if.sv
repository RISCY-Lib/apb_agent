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

`include "apb_agent_macros.svh"

// Interface: apb_vip_if
//
// Parameters:
//  DATA_WIDTH - The width of the data lines. Should be 8, 16, or 32
//  ADDR_WIDTH - The width of the address line. Should be <= 32
//
// Ports:
//  preset_n - The active-low reset signal for the bus
//  pclk     - The bus clock
//
// See Also:
//  <_APB_AGENT_PARAM_DEFS>
interface apb_vip_if #(
    `_APB_AGENT_PARAM_DEFS
) (
    input logic preset_n,
    input logic pclk
);

    import apb_agent_pkg::*;

    localparam int _STRB_WIDTH = DATA_WIDTH/8;

    // Group: Requester Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Signal: paddr
    // Address
    logic [    ADDR_WIDTH-1:0] paddr;

    // Signal: pprot
    // Protection type
    apb_pprot_t                pprot;

    // Signal: psel
    // Select
    logic                      psel;

    // Signal: penable
    // Enable
    logic                      penable;
    apb_write_e                pwrite;
    logic [    DATA_WIDTH-1:0] pwdata;
    logic [   _STRB_WIDTH-1:0] pstrb;

    // Group: Completer Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    logic                  pready;
    logic [DATA_WIDTH-1:0] prdata;
    logic                  pslverr;

endinterface : apb_vip_if