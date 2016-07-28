/* -*- c++ -*- */

#define CAML_NAME_SPACE

#include <QJSEngine>
#include <QDebug>

// OCaml declarations
#include <caml/mlvalues.h>
#include <caml/alloc.h>
#include <caml/callback.h>
#include <caml/memory.h>
#include <caml/custom.h>
#include <caml/fail.h>

#include <iostream>
#include <string>
#include <fstream>
#include <sstream>

#include "qjsengine_values.h"

enum {
  String, Integer
} Types;

extern "C" {

  CAMLprim value
  qjs_ml_init(value __attribute__((unused)) unit)
  {
    CAMLparam0();
    CAMLlocal1(res);

    res = caml_alloc_custom(&caml_qjsengine_vm_custom_ops,
			    sizeof(QJSEngine),
			    1,
			    sizeof(QJSEngine));
    new(Data_custom_val(res))QJSEngine;
    CAMLreturn(res);
  }

  CAMLprim value
  qjs_ml_eval_js(value engine_ptr, value script)
  {
    CAMLparam2(engine_ptr, script);

    QJSEngine *handle = (QJSEngine*)Data_custom_val(engine_ptr);
    QJSValue result = handle->evaluate(caml_strdup(String_val(script)));

    CAMLreturn(caml_copy_string(qPrintable(result.toString())));
  }

  CAMLprim value
  qjs_ml_garbage_collect(value engine_ptr)
  {
    CAMLparam1(engine_ptr);
    DEBUG("Calling garbage collect");

    QJSEngine *handle = (QJSEngine*)Data_custom_val(engine_ptr);

    handle->collectGarbage();

    CAMLreturn(Val_unit);
  }

  CAMLprim value
  qjs_ml_eval_from_file(value engine_ptr, value ml_filename)
  {
    CAMLparam2(engine_ptr, ml_filename);

    const char *s = caml_strdup(String_val(ml_filename));
    std::ifstream infile { s };
    std::stringstream buffer;

    buffer << infile.rdbuf();

    // std::cout << buffer.str() << std::endl;

    QJSEngine *e = (QJSEngine*)Data_custom_val(engine_ptr);
    QJSValue result = e->evaluate(QString::fromStdString(buffer.str()), s);

    CAMLreturn(caml_copy_string(qPrintable(result.toString())));
  }
}
