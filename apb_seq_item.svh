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

class apb_seq_item extends uvm_sequence_item;
  `uvm_object_utils(apb_seq_item)

  // Members
  rand logic[31:0] addr;
  rand logic[31:0] data;
  rand logic we;
  rand int delay;

  bit error;

  constraint c_align_addr {
    addr % 4 == 0;
  }

  constraint c_delay {
    delay inside {[0:20]};
  }

  // Functions
  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    apb_seq_item rhs_;

    if(!$cast(rhs_, rhs)) begin
      `uvm_fatal("do_copy", "cast of rhs object failed")
    end
    super.do_copy(rhs);
    // Copy over data members:
    addr = rhs_.addr;
    data = rhs_.data;
    we = rhs_.we;
    delay = rhs_.delay;

  endfunction: do_copy

  function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    apb_seq_item rhs_;

    if(!$cast(rhs_, rhs)) begin
      `uvm_error("do_copy", "cast of rhs object failed")
      return 0;
    end
    return super.do_compare(rhs, comparer) &&
          addr == rhs_.addr &&
          data == rhs_.data &&
          we   == rhs_.data;
  endfunction: do_compare

  function string convert2string();
    string s;

    $sformat(s, "%s\n", super.convert2string());
    $sformat(s, "%s\n addr:\t0x%0X\n data:\t0x%0X\n we:\t%0b\n delay:\t%0d\n", s, addr, data, we, delay);
    return s;

  endfunction: convert2string

  function void do_print(uvm_printer printer);
    printer.m_string = convert2string();
  endfunction: do_print

  function void do_record(uvm_recorder recorder);
    super.do_record(recorder);

    `uvm_record_field("addr", addr)
    `uvm_record_field("data", data)
    `uvm_record_field("we", we)
    `uvm_record_field("delay", delay)
  endfunction: do_record

endclass:apb_seq_item