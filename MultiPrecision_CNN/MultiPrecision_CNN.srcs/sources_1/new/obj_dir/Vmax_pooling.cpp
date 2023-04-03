// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vmax_pooling.h for the primary calling header

#include "Vmax_pooling.h"
#include "Vmax_pooling__Syms.h"

//==========

void Vmax_pooling::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vmax_pooling::eval\n"); );
    Vmax_pooling__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vmax_pooling* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("max_pooling.sv", 27, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vmax_pooling::_eval_initial_loop(Vmax_pooling__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("max_pooling.sv", 27, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

VL_INLINE_OPT void Vmax_pooling::_combo__TOP__1(Vmax_pooling__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmax_pooling::_combo__TOP__1\n"); );
    Vmax_pooling* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->o_max = 0U;
    vlTOPp->o_max = (0xffU & (VL_LTS_III(1,8,8, (IData)(vlTOPp->o_max), 
                                         (0xffU & vlTOPp->i_data[0U]))
                               ? vlTOPp->i_data[0U]
                               : (IData)(vlTOPp->o_max)));
    vlTOPp->o_max = (0xffU & (VL_LTS_III(1,8,8, (IData)(vlTOPp->o_max), 
                                         (0xffU & (
                                                   (vlTOPp->i_data[1U] 
                                                    << 0x18U) 
                                                   | (vlTOPp->i_data[0U] 
                                                      >> 8U))))
                               ? ((vlTOPp->i_data[1U] 
                                   << 0x18U) | (vlTOPp->i_data[0U] 
                                                >> 8U))
                               : (IData)(vlTOPp->o_max)));
    vlTOPp->o_max = (0xffU & (VL_LTS_III(1,8,8, (IData)(vlTOPp->o_max), 
                                         (0xffU & (
                                                   (vlTOPp->i_data[1U] 
                                                    << 0x10U) 
                                                   | (vlTOPp->i_data[0U] 
                                                      >> 0x10U))))
                               ? ((vlTOPp->i_data[1U] 
                                   << 0x10U) | (vlTOPp->i_data[0U] 
                                                >> 0x10U))
                               : (IData)(vlTOPp->o_max)));
    vlTOPp->o_max = (0xffU & (VL_LTS_III(1,8,8, (IData)(vlTOPp->o_max), 
                                         (0xffU & (
                                                   (vlTOPp->i_data[1U] 
                                                    << 8U) 
                                                   | (vlTOPp->i_data[0U] 
                                                      >> 0x18U))))
                               ? ((vlTOPp->i_data[1U] 
                                   << 8U) | (vlTOPp->i_data[0U] 
                                             >> 0x18U))
                               : (IData)(vlTOPp->o_max)));
    vlTOPp->o_max = (0xffU & (VL_LTS_III(1,8,8, (IData)(vlTOPp->o_max), 
                                         (0xffU & vlTOPp->i_data[1U]))
                               ? vlTOPp->i_data[1U]
                               : (IData)(vlTOPp->o_max)));
    vlTOPp->o_max = (0xffU & (VL_LTS_III(1,8,8, (IData)(vlTOPp->o_max), 
                                         (0xffU & (
                                                   (vlTOPp->i_data[2U] 
                                                    << 0x18U) 
                                                   | (vlTOPp->i_data[1U] 
                                                      >> 8U))))
                               ? ((vlTOPp->i_data[2U] 
                                   << 0x18U) | (vlTOPp->i_data[1U] 
                                                >> 8U))
                               : (IData)(vlTOPp->o_max)));
    vlTOPp->o_max = (0xffU & (VL_LTS_III(1,8,8, (IData)(vlTOPp->o_max), 
                                         (0xffU & (
                                                   (vlTOPp->i_data[2U] 
                                                    << 0x10U) 
                                                   | (vlTOPp->i_data[1U] 
                                                      >> 0x10U))))
                               ? ((vlTOPp->i_data[2U] 
                                   << 0x10U) | (vlTOPp->i_data[1U] 
                                                >> 0x10U))
                               : (IData)(vlTOPp->o_max)));
    vlTOPp->o_max = (0xffU & (VL_LTS_III(1,8,8, (IData)(vlTOPp->o_max), 
                                         (0xffU & (
                                                   (vlTOPp->i_data[2U] 
                                                    << 8U) 
                                                   | (vlTOPp->i_data[1U] 
                                                      >> 0x18U))))
                               ? ((vlTOPp->i_data[2U] 
                                   << 8U) | (vlTOPp->i_data[1U] 
                                             >> 0x18U))
                               : (IData)(vlTOPp->o_max)));
    vlTOPp->o_max = (0xffU & (VL_LTS_III(1,8,8, (IData)(vlTOPp->o_max), 
                                         (0xffU & vlTOPp->i_data[2U]))
                               ? vlTOPp->i_data[2U]
                               : (IData)(vlTOPp->o_max)));
}

void Vmax_pooling::_eval(Vmax_pooling__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmax_pooling::_eval\n"); );
    Vmax_pooling* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_combo__TOP__1(vlSymsp);
}

VL_INLINE_OPT QData Vmax_pooling::_change_request(Vmax_pooling__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmax_pooling::_change_request\n"); );
    Vmax_pooling* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    return (vlTOPp->_change_request_1(vlSymsp));
}

VL_INLINE_OPT QData Vmax_pooling::_change_request_1(Vmax_pooling__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmax_pooling::_change_request_1\n"); );
    Vmax_pooling* const __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vmax_pooling::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vmax_pooling::_eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((i_data[2U] & 0xffffff00U))) {
        Verilated::overWidthError("i_data");}
}
#endif  // VL_DEBUG
