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
interface apb_vip_if
    import apb_agent_pkg::*;
#(
    `_APB_AGENT_PARAM_DEFS
) (
    input logic preset_n,
    input logic pclk
);


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

    // Signal: pwrite
    // Write
    apb_write_e                pwrite;

    // Signal: pwdata
    // Write Data
    logic [    DATA_WIDTH-1:0] pwdata;

    // Signal: pstrb
    // Write strobe
    logic [   _STRB_WIDTH-1:0] pstrb;

    // Group: Completer Signals
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Signal: pready
    // pready
    logic                  pready;

    // Signal: prdata
    // Read Data
    logic [DATA_WIDTH-1:0] prdata;

    // Signal: pslverr
    // Completer Error
    logic                  pslverr;

    // Group: Clocking Blocks
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Clocking Block: drv_req_cb
    // Drives the requester-side stimulus (used by the driver in APB_COMPLETER_AGENT mode)
    clocking drv_req_cb @(posedge pclk);
        default input #1step output #1;
        output paddr, pprot, psel, penable, pwrite, pwdata, pstrb;
        input  pready, prdata, pslverr;
    endclocking : drv_req_cb

    // Clocking Block: drv_comp_cb
    // Drives the completer-side response (used by the driver in APB_REQUESTER_AGENT mode)
    clocking drv_comp_cb @(posedge pclk);
        default input #1step output #1;
        output pready, prdata, pslverr;
        input  paddr, pprot, psel, penable, pwrite, pwdata, pstrb;
    endclocking : drv_comp_cb

    // Clocking Block: mon_cb
    // Samples every functional signal (used by the monitor)
    clocking mon_cb @(posedge pclk);
        default input #1step;
        input paddr, pprot, psel, penable, pwrite, pwdata, pstrb,
              pready, prdata, pslverr;
    endclocking : mon_cb

    // Group: Modports
    ////////////////////////////////////////////////////////////////////////////////////////////////

    // Modport: drv_req
    // Requester-stimulus driver view
    modport drv_req (clocking drv_req_cb, input pclk, input preset_n);

    // Modport: drv_comp
    // Completer-response driver view
    modport drv_comp (clocking drv_comp_cb, input pclk, input preset_n);

    // Modport: mon
    // Passive monitor view
    modport mon (clocking mon_cb, input pclk, input preset_n);

endinterface : apb_vip_if