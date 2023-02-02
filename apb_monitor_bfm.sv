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

interface apb_monitor_bfm (
  input PCLK,
  input PRESETn,

  input logic [31:0] PADDR,
  input logic [31:0] PRDATA,
  input logic [31:0] PWDATA,
  input logic        PSEL,
  input logic        PENABLE,
  input logic        PWRITE,
  input logic        PREADY
);

  import apb_agent_pkg::*;

  // Members
  apb_monitor proxy;

  task run();
    apb_seq_item item;
    apb_seq_item cloned_item;

    item = apb_seq_item::type_id::create("item");

    forever begin
      // Detect the protocol event on the TBAI virtual interface
      @(posedge PCLK);

      if(PENABLE && PREADY && PSEL)
        // Assign the relevant values to the analysis item fields
        begin
          item.addr = PADDR;
          item.we = PWRITE;

          if(PWRITE) begin
            item.data = PWDATA;
          end
          else begin
            item.data = PRDATA;
          end

          // Clone and publish the cloned item to the subscribers
          $cast(cloned_item, item.clone());
          proxy.notify_transaction(cloned_item);
        end
    end
  endtask: run

endinterface: apb_monitor_bfm
