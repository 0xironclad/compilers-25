
#include <string>
#include "semantics.h"

std::string type_name(type t) {
    if (t == integer)   return "integer";
    if (t == boolean)   return "boolean";
    if (t == string_type) return "string";
    return "(unknown type)";
}
