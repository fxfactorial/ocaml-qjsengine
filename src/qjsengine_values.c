/* -*- c++ -*- */

#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/memory.h>
#include <caml/custom.h>
#include <caml/fail.h>

#include <QJSEngine>
#include <QDebug>

#include <iostream>

#include "qjsengine_values.h"

char qjs_engine_identifier[] = "qjsengine.vm";

static void
qjs_ml_vm_finalize(value qjs)
{
  QJSEngine *eng = (QJSEngine*)Data_custom_val(qjs);
  eng->~QJSEngine();
}

struct custom_operations
caml_qjsengine_vm_custom_ops = {
  qjs_engine_identifier,
  qjs_ml_vm_finalize,
  custom_compare_default,
  custom_hash_default,
  custom_serialize_default,
  custom_deserialize_default,
  custom_compare_ext_default
};

CAMLprim value
Val_some(value v)
{
  CAMLparam1(v);
  CAMLlocal1(some);
  some = caml_alloc(1, 0);
  Store_field(some, 0, v);
  CAMLreturn(some);
}
