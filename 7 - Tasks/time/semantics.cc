
#include <string>
#include "semantics.h"

std::string type_name(type t) {
    if (t == integer)   return "integer";
    if (t == boolean)   return "boolean";
    if (t == time_type) return "time";
    return "(unknown type)";
}
