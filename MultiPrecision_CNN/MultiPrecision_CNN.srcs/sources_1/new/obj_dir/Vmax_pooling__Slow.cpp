// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmax_pooling.h for the primary calling header

#include "Vmax_pooling.h"
#include "Vmax_pooling__Syms.h"

//==========

VL_CTOR_IMP(Vmax_pooling) {
    Vmax_pooling__Syms* __restrict vlSymsp = __VlSymsp = new Vmax_pooling__Syms(this, name());
    Vmax_pooling* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vmax_pooling::__Vconfigure(Vmax_pooling__Syms* vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
    if (false && this->__VlSymsp) {}  // Prevent unused
    Verilated::timeunit(-9);
    Verilated::timeprecision(-12);
}

Vmax_pooling::~Vmax_pooling() {
    VL_DO_CLEAR(delete __VlSymsp, __VlSymsp = NULL);
}

void Vmax_pooling::_eval_initial(Vmax_pooling__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmax_pooling::_eval_initial\n"); );
    Vmax_pooling* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vmax_pooling::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmax_pooling::final\n"); );
    // Variables
    Vmax_pooling__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vmax_pooling* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vmax_pooling::_eval_settle(Vmax_pooling__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmax_pooling::_eval_settle\n"); );
    Vmax_pooling* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
}

void Vmax_pooling::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmax_pooling::_ctor_var_reset\n"); );
    // Body
    VL_RAND_RESET_W(72, i_data);
    o_max = VL_RAND_RESET_I(8);
}
