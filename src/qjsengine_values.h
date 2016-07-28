/* -*- c++ -*- */

#ifndef QJSENGINE_VALUES_H
#define QJSENGINE_VALUES_H

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/memory.h>
#include <caml/custom.h>
#include <caml/fail.h>

#include <QJSEngine>
#include <QDebug>

#ifndef _DEBUG
#define DEBUG(s)
#else
#include <time.h>

const std::string current_date_time();
// http://stackoverflow.com/questions/997946/how-to-get-current-time-and-date-in-c
// TrungTN's was easiest to use
#define DEBUG(s)				\
  std::cout << "\033[1;33m["			\
  << current_date_time ()			\
  << "]\036" << " \033[1;36m["			\
  <<  __PRETTY_FUNCTION__ << "]\033[0m: "	\
  << s << "\n"
#endif

extern struct custom_operations caml_qjsengine_vm_custom_ops;

#endif
