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

class apb_coverage_monitor extends uvm_subscriber #(apb_seq_item);
  `uvm_component_utils(apb_coverage_monitor);

  // Component Members
  apb_seq_item analysis_transaction;

  // Coverage Groups
  covergroup apb_cov;
    OPCODE: coverpoint analysis_transaction.we {
      bins write = {1};
      bins read = {0};
    }
  endgroup

  // Methods
  function new(string name = "apb_coverage_monitor", uvm_component parent = null);
    super.new(name, parent);
    apb_cov = new();
  endfunction

  function void write(T t);
    analysis_transaction = t;
    apb_cov.sample();
  endfunction: write

endclass: apb_coverage_monitor
