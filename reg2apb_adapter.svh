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

class reg2apb_adapter extends uvm_reg_adapter;
  `uvm_object_utils(reg2apb_adapter)

  function new (string name = "reg2apb_adapter" );
    super.new(name);

    supports_byte_enable = 0;
    provides_responses = 0;

  endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    apb_seq_item seq_item = apb_seq_item::type_id::create("seq_item");

    seq_item.we = (rw.kind == UVM_READ) ? 1'b0 : 1'b1;
    seq_item.addr = rw.addr;
    seq_item.data = rw.data;
    seq_item.delay = 1;

    return seq_item;
  endfunction: reg2bus

  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    apb_seq_item seq_item;

    if (!$cast(seq_item, bus_item)) begin
      `uvm_fatal("NOT_BUS_TYPE","Provided bus_item is not of the correct type")
      return;
    end

    rw.kind = (seq_item.we == 1'b1) ? UVM_WRITE : UVM_READ;
    rw.addr = seq_item.addr;
    rw.data = seq_item.data;
    rw.status = (seq_item.error == 1'b1) ? UVM_NOT_OK : UVM_IS_OK;
  endfunction: bus2reg

endclass: reg2apb_adapter

