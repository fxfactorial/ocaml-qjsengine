/* -*- c++ -*- */

#define CAML_NAME_SPACE

#include <QJSEngine>
#include <QDebug>
#include <QtCore>

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

static QCoreApplication *dummy_app;

/* Qt library requires that QCoreApplication at a minimum be
   created, so take that hassle off the library's users. */
__attribute__((constructor))
void init_qt(void)
{
  DEBUG("Initialize QCoreApplication in bindings");

  int argc = 1;
  char *argv[] = {(char*)"qjsengine_stubs.dummy_app"};
  dummy_app = new QCoreApplication(argc, argv);
}

extern "C" {

  CAMLprim value
  qjs_ml_init(value __attribute__((unused)) unit)
  {
    CAMLparam0();
    CAMLlocal1(res);
    DEBUG("Creating a new QJSEngine");

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
    CAMLlocalN(errors, 3);
    DEBUG("Evaluating JavaScript");

    QJSEngine *handle = (QJSEngine*)Data_custom_val(engine_ptr);
    QJSValue result = handle->evaluate(caml_strdup(String_val(script)));

    if (result.isError()) {
      errors[0] = caml_copy_string(qPrintable(result.toString()));
      errors[1] = Val_int(result.property("lineNumber").toInt());
      errors[2] = caml_copy_string(qPrintable(result.property("stack").toString()));
      caml_raise_with_args(*caml_named_value("eval_exn"), 3, errors);
    }

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
    CAMLlocalN(errors, 3);
    DEBUG("Evaling script from file");

    const char *s = caml_strdup(String_val(ml_filename));
    // Easiest way to load a file into a string
    std::ifstream infile { s };
    std::stringstream buffer;

    buffer << infile.rdbuf();

    QJSEngine *e = (QJSEngine*)Data_custom_val(engine_ptr);
    QJSValue result = e->evaluate(QString::fromStdString(buffer.str()), s);

    if (result.isError()) {
      errors[0] = caml_copy_string(qPrintable(result.toString()));
      errors[1] = Val_int(result.property("lineNumber").toInt());
      errors[2] = caml_copy_string(qPrintable(result.property("stack").toString()));
      caml_raise_with_args(*caml_named_value("eval_exn"), 3, errors);
    }

    CAMLreturn(caml_copy_string(qPrintable(result.toString())));
  }

  CAMLprim value
  qjs_ml_set_property(value engine_ptr, value propname, value propvalue)
  {
    CAMLparam3(engine_ptr, propname, propvalue);
    DEBUG("Setting property on global object");

    QJSEngine *handle = (QJSEngine*)Data_custom_val(engine_ptr);
    handle->globalObject().setProperty(caml_strdup(String_val(propname)),
				       caml_strdup(String_val(propvalue)));
    CAMLreturn(Val_unit);
  }

  // Now JSValue stuff

  CAMLprim value
  qjs_ml_jsvalue_init(value __attribute__((unused)))
  {
    CAMLparam0();
    CAMLlocal1(res);
    DEBUG("Created JSValue");

    res = caml_alloc_custom(&caml_qjsengine_jsvalue_custom_ops,
  			    sizeof(QJSValue),
  			    1,
  			    sizeof(QJSValue));
    new(Data_custom_val(res))QJSValue;
    CAMLreturn(res);
  }

  CAMLprim value
  qjs_ml_jsvalue_with_string(value ml_string)
  {
    CAMLparam1(ml_string);
    CAMLlocal1(res);
    DEBUG("Creating JSValue with a ML string");

    res = caml_alloc_custom(&caml_qjsengine_jsvalue_custom_ops,
  			    sizeof(QJSValue),
  			    1,
  			    sizeof(QJSValue));
    new(Data_custom_val(res))QJSValue(caml_strdup(String_val(ml_string)));
    CAMLreturn(res);
  }

  CAMLprim value
  qjs_ml_jsvalue_is_bool(value jsvalue_ptr)
  {
    CAMLparam1(jsvalue_ptr);
    DEBUG("Checking if value is bool");

    QJSValue *v = (QJSValue*)Data_custom_val(jsvalue_ptr);

    CAMLreturn(Bool_val(v->isBool()));
  }

}
