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

interface apb_if(
  input PCLK,
  input PRESETn
);

  logic[31:0] PADDR;
  logic[31:0] PRDATA;
  logic[31:0] PWDATA;
  logic       PSEL;
  logic       PENABLE;
  logic       PWRITE;
  logic       PREADY;

  property psel_xcheck;
    @(posedge PCLK) disable iff (PRESETn == 1'b0)
      !$isunknown(PSEL);
  endproperty: psel_xcheck

  CHK_PSEL: assert property(psel_xcheck);

  COVER_PSEL: cover property(psel_xcheck);

endinterface: apb_if
