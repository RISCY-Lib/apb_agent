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

interface apb_driver_bfm (
  input         PCLK,
  input         PRESETn,

  output logic [31:0] PADDR,
  input  logic [31:0] PRDATA,
  output logic [31:0] PWDATA,
  output logic        PSEL,
  output logic        PENABLE,
  output logic        PWRITE,
  input  logic        PREADY
);

  import apb_agent_pkg::*;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Members
  apb_agent_config m_cfg;


  function void clear_sigs();
    PSEL <= 0;
    PENABLE <= 0;
    PADDR <= 0;
  endfunction : clear_sigs

  task send (apb_seq_item req);
    int psel_index;

    // Delay x-clock cycles before starting the
    repeat(req.delay)
      @(posedge PCLK);

    PSEL <= 1;
    PADDR <= req.addr;
    PWDATA <= req.data;
    PWRITE <= req.we;

    @(posedge PCLK);

    PENABLE <= 1;

    while (!PREADY)
      @(posedge PCLK);

    if(!PWRITE)
      req.data = PRDATA;
  endtask : send

endinterface: apb_driver_bfm
