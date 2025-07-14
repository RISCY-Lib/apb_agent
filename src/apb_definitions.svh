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

// Enum: apb_agent_mode_e
typedef enum {
    APB_COMPLETER_AGENT,
    APB_REQUESTER_AGENT
} apb_agent_mode_e;

// Struct: apb_agent_pkg.apb_pprot_t
typedef struct packed {
    logic privileged;
    logic insecure;
    logic instruction;
} apb_pprot_t;

// Enum: apb_write_e
typedef enum logic {
    APB_WRITE = 1'b1,
    APB_READ  = 1'b0
} apb_write_e;

// Enum: apb_phase_e
typedef enum {
    APB_SETUP_PHASE,
    APB_ACCESS_PHASE
} apb_phase_e;
